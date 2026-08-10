import json
import re
import time
import unicodedata
from threading import Lock

import requests


GOMETA_URL = "https://apis.gometa.org/cedulas/{identity}"
HACIENDA_URL = "https://api.hacienda.go.cr/fe/ae"
REQUEST_TIMEOUT = 10
CACHE_TTL_SECONDS = 24 * 60 * 60

ACCENTED_WORDS = {
    "ACUNA": "Acuña", "AGUERO": "Agüero", "ALARCON": "Alarcón", "ALVAREZ": "Álvarez",
    "ANDRES": "Andrés", "ANGEL": "Ángel", "ANGELICA": "Angélica", "ARGUELLO": "Argüello",
    "AVALOS": "Ávalos", "AVILA": "Ávila", "BARBARA": "Bárbara", "BEITAN": "Beitán",
    "BELEN": "Belén", "BENJAMIN": "Benjamín", "BERMUDEZ": "Bermúdez", "BOLANOS": "Bolaños",
    "CALDERON": "Calderón", "CASTANEDA": "Castañeda", "CESAR": "César", "CESPEDES": "Céspedes",
    "CHACON": "Chacón", "CHAVARRIA": "Chavarría", "CHAVEZ": "Chávez", "CORDOBA": "Córdoba",
    "DAMIAN": "Damián", "DIAZ": "Díaz", "DURAN": "Durán", "ECHEVERRIA": "Echeverría",
    "ELIAS": "Elías", "FABIAN": "Fabián", "FELIX": "Félix", "FERNANDEZ": "Fernández",
    "GALVEZ": "Gálvez", "GAMEZ": "Gámez", "GARCIA": "García", "GENESIS": "Génesis",
    "GERMAN": "Germán", "GODINEZ": "Godínez", "GOMEZ": "Gómez", "GONZALEZ": "González",
    "GUTIERREZ": "Gutiérrez", "GUZMAN": "Guzmán", "HECTOR": "Héctor", "HERNANDEZ": "Hernández",
    "IBANEZ": "Ibáñez", "ISAIAS": "Isaías", "IVAN": "Iván", "JAZMIN": "Jazmín",
    "JEREMIAS": "Jeremías", "JESUS": "Jesús", "JIMENEZ": "Jiménez", "JOAQUIN": "Joaquín",
    "JOSE": "José", "LEON": "León", "LOPEZ": "López", "LUCIA": "Lucía",
    "MARIA": "María", "MARIN": "Marín", "MARTIN": "Martín", "MARTINEZ": "Martínez",
    "MASIS": "Masís", "MATIAS": "Matías", "MEJIA": "Mejía", "MENDEZ": "Méndez",
    "MOISES": "Moisés", "MONICA": "Mónica", "MUNOZ": "Muñoz", "NICOLAS": "Nicolás",
    "NOEMI": "Noemí", "NUNEZ": "Núñez", "OCON": "Ocón", "ORDONEZ": "Ordóñez",
    "OSCAR": "Óscar", "PARIS": "París", "PENA": "Peña", "PEREZ": "Pérez",
    "QUIROS": "Quirós", "RAMIREZ": "Ramírez", "RAMON": "Ramón", "RAUL": "Raúl",
    "RENTERIA": "Rentería", "RINCON": "Rincón", "RODRIGUEZ": "Rodríguez", "RUBEN": "Rubén",
    "SABORIO": "Saborío", "SANCHEZ": "Sánchez", "SANDI": "Sandí", "SEBASTIAN": "Sebastián",
    "SIMON": "Simón", "SOFIA": "Sofía", "SOLIS": "Solís", "SUAREZ": "Suárez",
    "TOMAS": "Tomás", "TRISTAN": "Tristán", "UMANA": "Umaña", "VALDES": "Valdés",
    "VALENTIN": "Valentín", "VASQUEZ": "Vásquez", "VAZQUEZ": "Vázquez", "VELASQUEZ": "Velásquez",
    "VERONICA": "Verónica", "VICTOR": "Víctor", "VIQUEZ": "Víquez", "ZUNIGA": "Zúñiga",
}
LOWERCASE_PARTICLES = {"DE", "DEL", "LA", "LAS", "LOS", "VAN", "VON", "Y"}

_cache = {}
_cache_lock = Lock()


class IdentityLookupError(Exception):
    pass


def normalize_identity(value) -> str:
    digits = re.sub(r"\D", "", str(value or ""))
    if len(digits) == 8:
        digits = "0" + digits
    if not 9 <= len(digits) <= 12:
        raise IdentityLookupError("La cédula debe contener entre 9 y 12 dígitos.")
    return digits


def accent_name(value: str) -> str:
    words = []
    for word in re.split(r"\s+", str(value or "").strip()):
        key = word.upper()
        if key in ACCENTED_WORDS:
            words.append(ACCENTED_WORDS[key])
        elif key in LOWERCASE_PARTICLES:
            words.append(key.lower())
        else:
            words.append(word.capitalize())
    return " ".join(words)


def _json(response):
    return json.loads(response.content.decode("utf-8", errors="replace"))


def _gometa(identity):
    response = requests.get(GOMETA_URL.format(identity=identity), timeout=REQUEST_TIMEOUT)
    if response.status_code != 200:
        return None
    results = (_json(response).get("results") or [])
    if not results:
        return None
    person = results[0]
    return " ".join(filter(None, (person.get("firstname"), person.get("lastname1"), person.get("lastname2")))).strip() or person.get("fullname")


def _hacienda(identity):
    response = requests.get(HACIENDA_URL, params={"identificacion": identity}, timeout=REQUEST_TIMEOUT)
    if response.status_code != 200:
        return None
    return (_json(response).get("nombre") or "").strip() or None


def _comparison_key(value):
    normalized = unicodedata.normalize("NFKD", str(value or ""))
    plain = "".join(character for character in normalized if not unicodedata.combining(character))
    return re.sub(r"[^A-Z0-9]+", " ", plain.upper()).strip()


def lookup_identity_name(identity_value, current_name="") -> dict:
    identity = normalize_identity(identity_value)
    now = time.time()
    with _cache_lock:
        cached = _cache.get(identity)
        if cached and now - cached[0] < CACHE_TTL_SECONDS:
            raw_name, source = cached[1], cached[2]
        else:
            raw_name = source = None
    if not raw_name:
        service_responded = False
        try:
            raw_name = _gometa(identity)
            service_responded = True
            source = "GoMeta" if raw_name else None
        except (requests.RequestException, ValueError, json.JSONDecodeError):
            raw_name = None
        if not raw_name:
            try:
                raw_name = _hacienda(identity)
                service_responded = True
                source = "Hacienda" if raw_name else None
            except (requests.RequestException, ValueError, json.JSONDecodeError):
                raw_name = None
        if not raw_name:
            if not service_responded:
                raise IdentityLookupError("No fue posible consultar los servicios de cédulas en este momento.")
            raise IdentityLookupError("No se encontró un nombre para esta cédula.")
        with _cache_lock:
            _cache[identity] = (now, raw_name, source)
    suggested_name = accent_name(raw_name)
    comparison = "same" if suggested_name == current_name.strip() else (
        "format_only" if _comparison_key(suggested_name) == _comparison_key(current_name) else "different"
    )
    return {"name": suggested_name, "source": source, "comparison": comparison}

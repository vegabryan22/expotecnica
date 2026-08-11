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
    "ARGUEDAS": "Argüedas", "AVALOS": "Ávalos", "AVILA": "Ávila", "BARBARA": "Bárbara", "BEITAN": "Beitán",
    "BELEN": "Belén", "BENJAMIN": "Benjamín", "BERMUDEZ": "Bermúdez", "BOLANOS": "Bolaños",
    "CALDERON": "Calderón", "CASTANEDA": "Castañeda", "CEDENO": "Cedeño", "CESAR": "César", "CESPEDES": "Céspedes",
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
ACCENTED_WORDS.update({
    # Nombres masculinos y unisex frecuentes
    "ABDIAS": "Abdías", "ADAN": "Adán", "ADRIAN": "Adrián", "AGUSTIN": "Agustín",
    "ALVARO": "Álvaro", "ANIBAL": "Aníbal", "ANTON": "Antón", "ARISTIDES": "Arístides",
    "BALTAZAR": "Baltazar", "BARTOLOME": "Bartolomé", "CRISTOBAL": "Cristóbal",
    "DARIO": "Darío", "EFRAIN": "Efraín", "EMILIAN": "Emilián", "ERICK": "Érick",
    "ESTEFANO": "Estéfano", "FERMIN": "Fermín", "FRANCESC": "Francesc", "GASTON": "Gastón",
    "HERNAN": "Hernán", "HIPOLITO": "Hipólito", "IÑAKI": "Iñaki", "JONAS": "Jonás",
    "JORGE": "Jorge", "JOSUE": "Josué", "JULIAN": "Julián", "LAZARO": "Lázaro",
    "MAXIMO": "Máximo", "MIGUEL": "Miguel", "NATAN": "Natán", "PASCUAL": "Pascual",
    "PATRICIO": "Patricio", "ROMAN": "Román", "SALOMON": "Salomón", "SAUL": "Saúl",
    "TEOFILO": "Teófilo", "ULISES": "Ulises", "ZACARIAS": "Zacarías",

    # Nombres femeninos frecuentes
    "ALICIA": "Alicia", "AMBAR": "Ámbar", "ANGELA": "Ángela", "BEATRIZ": "Beatriz",
    "CECILIA": "Cecilia", "CLOE": "Cloé", "DEBORA": "Débora", "ELIZABETH": "Elizabeth",
    "ESTEFANIA": "Estefanía", "EVA": "Eva", "FATIMA": "Fátima", "INES": "Inés",
    "ISABEL": "Isabel", "JULIANA": "Juliana", "LIA": "Lía", "MAITE": "Maite",
    "MARILU": "Marilú", "MERCEDES": "Mercedes", "MIRIAM": "Míriam", "NATALIA": "Natalia",
    "OLGA": "Olga", "ROCIO": "Rocío", "SALOME": "Salomé", "SARA": "Sara",
    "TATIANA": "Tatiana", "URSULA": "Úrsula", "VIOLETA": "Violeta",

    # Apellidos frecuentes con tilde, diéresis o eñe
    "ADRIAN": "Adrián", "ALCANTARA": "Alcántara", "ALCÁZAR": "Alcázar", "ALEMAN": "Alemán",
    "ARAGON": "Aragón", "ARAUZ": "Araúz", "ARCE": "Arce", "AREVALO": "Arévalo",
    "BAEZ": "Báez", "BENITEZ": "Benítez", "BRICEÑO": "Briceño", "CABEZAS": "Cabezas",
    "CADIZ": "Cádiz", "CAICEDO": "Caicedo", "CANTON": "Cantón", "CARVAJAL": "Carvajal",
    "CATALAN": "Catalán", "COLON": "Colón", "CORTES": "Cortés", "DELGADO": "Delgado",
    "DIEGUEZ": "Diéguez", "DUEÑAS": "Dueñas", "ESCAMEZ": "Escámez", "ESCOBAR": "Escobar",
    "FABREGA": "Fábrega", "FARIAS": "Farías", "FRIAS": "Frías", "GAVILAN": "Gavilán",
    "GIMENEZ": "Giménez", "GÜELL": "Güell", "HENRIQUEZ": "Henríquez", "HUERTAS": "Huertas",
    "ILLANES": "Illanes", "IÑIGUEZ": "Íñiguez", "LARIOS": "Larios", "LEIVA": "Leiva",
    "LUCERO": "Lucero", "MACIAS": "Macías", "MALDONADO": "Maldonado", "MANRIQUE": "Manrique",
    "MARQUEZ": "Márquez", "MELENDEZ": "Meléndez", "MESEN": "Mesén", "MILLAN": "Millán",
    "MONGE": "Monge", "MORAN": "Morán", "MORENO": "Moreno", "NARANJO": "Naranjo",
    "NAVARRETE": "Navarrete", "OLIVAN": "Oliván", "OLMEDO": "Olmedo", "ORTIZ": "Ortiz",
    "PEÑARANDA": "Peñaranda", "PIÑEIRO": "Piñeiro", "PONCE": "Ponce", "RAMON": "Ramón",
    "RIOFRIO": "Riofrío", "RONDON": "Rondón", "SÁENZ": "Sáenz", "SAENZ": "Sáenz",
    "SANTOS": "Santos", "SIMON": "Simón", "TÉLLEZ": "Téllez", "TELLEZ": "Téllez",
    "TRIVIÑO": "Triviño", "UREÑA": "Ureña", "URENA": "Ureña", "VALLEJO": "Vallejo",
    "VILCHEZ": "Vílchez", "YÁÑEZ": "Yáñez", "YANEZ": "Yáñez",
})
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


def _accent_word(word: str) -> str:
    parts = re.split(r"([-'])", word)
    accented_parts = []
    for part in parts:
        if part in {"-", "'"}:
            accented_parts.append(part)
            continue
        key = part.upper()
        if key in ACCENTED_WORDS:
            accented_parts.append(ACCENTED_WORDS[key])
        elif key in LOWERCASE_PARTICLES:
            accented_parts.append(key.lower())
        else:
            accented_parts.append(part.capitalize())
    return "".join(accented_parts)


def accent_name(value: str, current_name: str = "") -> str:
    words = []
    source_words = re.split(r"\s+", str(value or "").strip())
    current_words = re.split(r"\s+", str(current_name or "").strip())
    for index, word in enumerate(source_words):
        current_word = current_words[index] if len(current_words) == len(source_words) else ""
        # Si el nombre ya contiene una tilde o una ñ y coincide con el padrón,
        # se conserva esa escritura en lugar de degradarla por falta de diccionario.
        if current_word and _comparison_key(word) == _comparison_key(current_word):
            normalized_current = unicodedata.normalize("NFD", current_word)
            if any(unicodedata.combining(character) for character in normalized_current) or "ñ" in current_word.casefold():
                words.append(_accent_word(current_word))
                continue
        words.append(_accent_word(word))
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
    suggested_name = accent_name(raw_name, current_name)
    comparison = "same" if suggested_name == current_name.strip() else (
        "format_only" if _comparison_key(suggested_name) == _comparison_key(current_name) else "different"
    )
    return {"name": suggested_name, "source": source, "comparison": comparison}

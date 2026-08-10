import re
import unicodedata


SPECIALTY_ALIASES = {
    "configuracion y soporte": "configuracion y soporte a redes de comunicacion y sistemas operativos",
}


def specialty_key(value: str) -> str:
    normalized = unicodedata.normalize("NFKD", str(value or ""))
    without_accents = "".join(character for character in normalized if not unicodedata.combining(character))
    return re.sub(r"[^a-z0-9]+", " ", without_accents.casefold()).strip()


def canonical_specialty_name(value: str, specialty_names) -> str:
    """Devuelve el nombre oficial del catálogo para variantes equivalentes."""
    raw_value = str(value or "").strip()
    if not raw_value:
        return ""
    catalog = {specialty_key(name): str(name).strip() for name in specialty_names if str(name or "").strip()}
    key = SPECIALTY_ALIASES.get(specialty_key(raw_value), specialty_key(raw_value))
    return catalog.get(key, raw_value)


def is_catalog_specialty(value: str, specialty_names) -> bool:
    raw_value = str(value or "").strip()
    if not raw_value:
        return False
    official = canonical_specialty_name(raw_value, specialty_names)
    return specialty_key(official) in {specialty_key(name) for name in specialty_names}

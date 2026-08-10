import unittest

from app.services.specialty_service import canonical_specialty_name, is_catalog_specialty


class SpecialtyNormalizationTest(unittest.TestCase):
    def setUp(self):
        self.catalog = [
            "Dibujo y Modelado de Edificaciones",
            "Configuración y Soporte a Redes de Comunicación y Sistemas Operativos",
            "Contabilidad y Finanzas",
        ]

    def test_case_and_accents_use_catalog_spelling(self):
        self.assertEqual(
            canonical_specialty_name("CONTABILIDAD Y FINANZAS", self.catalog),
            "Contabilidad y Finanzas",
        )

    def test_legacy_short_networking_name_uses_full_official_name(self):
        self.assertEqual(
            canonical_specialty_name("Configuracion y Soporte", self.catalog),
            "Configuración y Soporte a Redes de Comunicación y Sistemas Operativos",
        )

    def test_unknown_value_is_not_accepted_as_catalog_value(self):
        self.assertFalse(is_catalog_specialty("Otra especialidad", self.catalog))


if __name__ == "__main__":
    unittest.main()

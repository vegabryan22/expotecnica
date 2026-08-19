import unittest
from datetime import date
from types import SimpleNamespace
from xml.etree import ElementTree as ET
from zipfile import ZipFile

from app.services.institutional_matrix_service import (
    MAIN_NS,
    NS,
    TARGET_SHEET_NAME,
    _ensure_birth_date_column,
    _sheet_xml_path,
    _student_row,
)


class InstitutionalMatrixTest(unittest.TestCase):
    def test_student_row_includes_formatted_birth_date(self):
        member = SimpleNamespace(
            full_name="Ana Prueba",
            identity_number="123456789",
            birth_date=date(2010, 9, 15),
            section_name="10-1",
            specialty_ref=None,
            specialty="Informática",
        )
        project = SimpleNamespace(
            title="Proyecto",
            grade_level="10",
            section=None,
            members=[member],
            category="steam",
            thematic_axis=None,
            specialty_ref=None,
            specialty="",
            tutor=None,
            advisor_name="Docente",
            advisor_specialty="Informática",
        )

        row = _student_row(project, member, ["Informática"])

        self.assertEqual(10, len(row))
        self.assertEqual("15/09/2010", row[9])

    def test_matrix_adds_formatted_birth_date_column(self):
        template = "app/static/templates/matriz_registro_expotecnica_institucional.xlsx"
        with ZipFile(template) as archive:
            sheet_path = _sheet_xml_path(archive, TARGET_SHEET_NAME)
            root = ET.fromstring(archive.read(sheet_path))

        _ensure_birth_date_column(root, 42)

        header = root.find("m:sheetData/m:row[@r='12']/m:c[@r='J12']", NS)
        header_text = header.find(f".//{{{MAIN_NS}}}t").text
        self.assertEqual("Fecha de nacimiento de la persona estudiante", header_text)
        self.assertEqual("A1:J42", root.find("m:dimension", NS).get("ref"))


if __name__ == "__main__":
    unittest.main()

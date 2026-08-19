import unittest
from io import BytesIO
from unittest.mock import patch
from zipfile import ZipFile
from xml.etree import ElementTree as ET

from flask import Flask

from app.controllers.admin_controller import WORD_NS, _build_winners_acta_docx


class WinnersActaTest(unittest.TestCase):
    def test_acta_includes_number_and_school_without_parentheses(self):
        app = Flask(__name__)
        settings = {
            "expotec_event_date": "2026-08-20",
            "school_name": "CTP Roberto Gamboa Valverde",
            "expotec_school_year": "2026",
        }
        overview = {"category_winners": []}

        with (
            app.test_request_context("/?numero=07"),
            patch(
                "app.controllers.admin_controller.build_admin_evaluation_overview",
                return_value=overview,
            ),
            patch(
                "app.controllers.admin_controller.SystemSetting.get_value",
                side_effect=lambda key, default="": settings.get(key, default),
            ),
        ):
            output = _build_winners_acta_docx()

        with ZipFile(BytesIO(output.getvalue())) as document:
            root = ET.fromstring(document.read("word/document.xml"))
        paragraphs = root.findall(f".//{{{WORD_NS}}}body/{{{WORD_NS}}}p")
        title = "".join(node.text or "" for node in paragraphs[0].findall(f".//{{{WORD_NS}}}t"))
        narrative = "".join(node.text or "" for node in paragraphs[2].findall(f".//{{{WORD_NS}}}t"))

        self.assertEqual("Acta N° 07 -2026", title)
        self.assertIn("centro educativo CTP Roberto Gamboa Valverde,", narrative)
        self.assertNotIn("(CTP Roberto Gamboa Valverde)", narrative)


if __name__ == "__main__":
    unittest.main()

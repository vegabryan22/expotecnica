import unittest
import json
from pathlib import Path

from flask import Flask

from app.controllers.admin_controller import _rubric_score_descriptions_from_form
from app.models.rubric_criterion import RubricCriterion
from app.services.parameter_service import DEFAULT_RUBRICS


class OfficialRubricsTest(unittest.TestCase):
    def test_evaluation_table_shows_scale_in_header_without_repeating_it_per_row(self):
        template = Path("app/templates/judge/evaluate.html").read_text(encoding="utf-8")

        self.assertIn("<th>{{ score_labels.get(score_value, score_value) }}</th>", template)
        self.assertIn('aria-label="{{ score_labels.get(score_value, score_value) }}"', template)
        self.assertNotIn("<span>{{ score_labels.get(score_value, score_value) }}</span>", template)

    def test_admin_can_save_each_score_description(self):
        app = Flask(__name__)
        with app.test_request_context(
            method="POST",
            data={
                "rubric_score_description_5": "Exceptional description",
                "rubric_score_description_4": "Very good description",
                "rubric_score_description_3": "",
            },
        ):
            descriptions = json.loads(_rubric_score_descriptions_from_form(1, 5))

        self.assertEqual("Exceptional description", descriptions["5"])
        self.assertEqual("Very good description", descriptions["4"])
        self.assertNotIn("3", descriptions)

    def test_english_rubric_has_official_descriptions_for_every_score(self):
        criteria = DEFAULT_RUBRICS["english_project_performance"]

        self.assertEqual(8, len(criteria))
        for row in criteria:
            criterion = RubricCriterion(score_descriptions=row["score_descriptions"])
            self.assertEqual({1, 2, 3, 4, 5}, set(criterion.get_score_descriptions()))

        first = RubricCriterion(score_descriptions=criteria[0]["score_descriptions"])
        self.assertEqual(
            "Student's ideas are always clear, logical and well organized.",
            first.get_score_descriptions()[5],
        )

    def test_exposition_rubrics_match_official_indicator_counts(self):
        self.assertEqual(37, len(DEFAULT_RUBRICS["steam_exposicion"]))
        self.assertEqual(17, len(DEFAULT_RUBRICS["modelo_negocio_exposicion"]))
        self.assertEqual(
            "Describe las alianzas estratégicas de su propuesta de valor.",
            DEFAULT_RUBRICS["modelo_negocio_exposicion"][-1]["name"],
        )


if __name__ == "__main__":
    unittest.main()

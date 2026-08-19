import unittest

from app.models.rubric_criterion import RubricCriterion
from app.services.parameter_service import DEFAULT_RUBRICS


class OfficialRubricsTest(unittest.TestCase):
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

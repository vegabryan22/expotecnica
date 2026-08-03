import unittest
from types import SimpleNamespace

from app.services.regional_integration_service import RegionalIntegrationError, _headers, _project_payload, validate_settings


class RegionalIntegrationTests(unittest.TestCase):
    def test_settings_require_url_token_and_school_code(self):
        with self.assertRaises(RegionalIntegrationError):
            validate_settings({"base_url": "not-a-url", "token": "", "institution_code": ""})

    def test_payload_uses_stable_external_id_and_orders_students(self):
        project = SimpleNamespace(
            title="Proyecto ganador", team_name="Equipo", category="steam", description="Descripción",
            advisor_name="Tutor", advisor_email="tutor@example.com", advisor_phone="8888-8888",
            members=[
                SimpleNamespace(student_number=2, full_name="Dos", identity_number=None, email=None, phone=None, section_name=None, specialty=None),
                SimpleNamespace(student_number=1, full_name="Uno", identity_number="1", email="uno@example.com", phone=None, section_name="12-1", specialty="Informática"),
            ],
        )
        submission = SimpleNamespace(external_project_id="CTPRGV-000123")

        payload = _project_payload(project, submission)

        self.assertEqual("CTPRGV-000123", payload["external_project_id"])
        self.assertTrue(payload["institutional_result"]["winner"])
        self.assertEqual(["Uno", "Dos"], [student["name"] for student in payload["students"]])

    def test_auth_header_uses_bearer_and_idempotency(self):
        headers = _headers("secret-token", "CTPRGV-000123")

        self.assertEqual("Bearer secret-token", headers["Authorization"])
        self.assertEqual("CTPRGV-000123", headers["Idempotency-Key"])


if __name__ == "__main__":
    unittest.main()

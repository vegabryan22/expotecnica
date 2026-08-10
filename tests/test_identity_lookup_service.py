import json
import unittest
from unittest.mock import Mock, patch

import requests

from app.services import identity_lookup_service as service


class IdentityLookupServiceTest(unittest.TestCase):
    def setUp(self):
        service._cache.clear()

    def response(self, payload, status=200):
        response = Mock()
        response.status_code = status
        response.content = json.dumps(payload).encode("utf-8")
        return response

    @patch("app.services.identity_lookup_service.requests.get")
    def test_accent_only_difference_is_proposed(self, get):
        get.return_value = self.response({"results": [{"firstname": "SEBASTIAN", "lastname1": "GUTIERREZ", "lastname2": "MUNOZ"}]})
        result = service.lookup_identity_name("1-2345-6789", "Sebastian Gutierrez Munoz")
        self.assertEqual(result["name"], "Sebastián Gutiérrez Muñoz")
        self.assertEqual(result["comparison"], "format_only")
        self.assertEqual(result["source"], "GoMeta")

    @patch("app.services.identity_lookup_service.requests.get")
    def test_hacienda_is_used_as_fallback(self, get):
        get.side_effect = [self.response({"results": []}), self.response({"nombre": "MARIA RODRIGUEZ"})]
        result = service.lookup_identity_name("123456789", "Maria Rodriguez")
        self.assertEqual(result["name"], "María Rodríguez")
        self.assertEqual(result["source"], "Hacienda")

    @patch("app.services.identity_lookup_service.requests.get")
    def test_hacienda_is_used_when_gometa_is_unavailable(self, get):
        get.side_effect = [requests.ConnectionError(), self.response({"nombre": "JOSE PEREZ"})]
        result = service.lookup_identity_name("123456789", "Jose Perez")
        self.assertEqual(result["name"], "José Pérez")
        self.assertEqual(result["source"], "Hacienda")

    def test_invalid_identity_is_rejected_without_external_request(self):
        with self.assertRaises(service.IdentityLookupError):
            service.lookup_identity_name("123", "Nombre")


if __name__ == "__main__":
    unittest.main()

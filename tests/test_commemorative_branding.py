import unittest
from pathlib import Path


class CommemorativeBrandingTest(unittest.TestCase):
    def test_official_205_brand_assets_are_present_and_used(self):
        template = Path("app/templates/base.html").read_text(encoding="utf-8")
        static_root = Path("app/static")
        white_logo = static_root / "branding/costa-rica-205-horizontal-white.png"
        color_logo = static_root / "branding/costa-rica-205-horizontal-color.png"

        self.assertTrue(white_logo.is_file())
        self.assertTrue(color_logo.is_file())
        self.assertIn("branding/costa-rica-205-horizontal-white.png", template)
        self.assertIn("branding/costa-rica-205-horizontal-color.png", template)
        self.assertIn("205 a&ntilde;os libres, en paz y sembrando futuro", template)


if __name__ == "__main__":
    unittest.main()

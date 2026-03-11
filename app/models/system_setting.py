from datetime import datetime

from app.extensions import db


class SystemSetting(db.Model):
    __tablename__ = "system_settings"

    key = db.Column(db.String(80), primary_key=True)
    value = db.Column(db.Text, nullable=True)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    @classmethod
    def get_value(cls, key: str, default=None):
        row = cls.query.get(key)
        return row.value if row and row.value is not None else default

    @classmethod
    def set_value(cls, key: str, value):
        row = cls.query.get(key)
        if row is None:
            row = cls(key=key)
            db.session.add(row)
        row.value = value
        row.updated_at = datetime.utcnow()
        return row

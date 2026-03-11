from datetime import datetime

from app.extensions import db


class SystemAuditLog(db.Model):
    __tablename__ = "system_audit_logs"

    id = db.Column(db.Integer, primary_key=True)
    actor_name = db.Column(db.String(140), nullable=False)
    actor_email = db.Column(db.String(160), nullable=True)
    actor_role = db.Column(db.String(40), nullable=True)
    action = db.Column(db.String(120), nullable=False, index=True)
    entity = db.Column(db.String(80), nullable=False, index=True)
    entity_id = db.Column(db.Integer, nullable=True, index=True)
    detail = db.Column(db.Text, nullable=True)
    ip_address = db.Column(db.String(45), nullable=True)
    user_agent = db.Column(db.String(255), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)

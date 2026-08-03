from datetime import datetime

from app.extensions import db


class RegionalSubmission(db.Model):
    __tablename__ = "regional_submissions"

    id = db.Column(db.Integer, primary_key=True)
    project_id = db.Column(db.Integer, db.ForeignKey("projects.id", ondelete="CASCADE"), unique=True, nullable=False, index=True)
    external_project_id = db.Column(db.String(120), unique=True, nullable=False, index=True)
    status = db.Column(db.String(30), nullable=False, default="pending", index=True)
    regional_project_id = db.Column(db.Integer, nullable=True)
    regional_status = db.Column(db.String(40), nullable=True)
    attempts = db.Column(db.Integer, nullable=False, default=0)
    last_http_status = db.Column(db.Integer, nullable=True)
    last_error = db.Column(db.Text, nullable=True)
    last_response_json = db.Column(db.Text, nullable=True)
    sent_at = db.Column(db.DateTime, nullable=True)
    last_attempt_at = db.Column(db.DateTime, nullable=True)
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow)

    project = db.relationship("Project", backref=db.backref("regional_submission", uselist=False, cascade="all, delete-orphan"))

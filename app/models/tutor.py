from datetime import datetime
import secrets

from app.extensions import db


class Tutor(db.Model):
    __tablename__ = "tutors"

    id = db.Column(db.Integer, primary_key=True)
    full_name = db.Column(db.String(120), nullable=False)
    identity_number = db.Column(db.String(40), nullable=False, unique=True, index=True)
    birth_date = db.Column(db.Date, nullable=True)
    gender = db.Column(db.String(20), nullable=True)
    specialty = db.Column(db.String(140), nullable=True)
    specialty_id = db.Column(db.Integer, db.ForeignKey("specialties.id", ondelete="SET NULL"), nullable=True, index=True)
    email = db.Column(db.String(120), nullable=True, index=True)
    phone = db.Column(db.String(40), nullable=True)
    is_active = db.Column(db.Boolean, nullable=False, default=True, index=True)
    results_access_token = db.Column(db.String(64), nullable=True, unique=True, index=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    projects = db.relationship("Project", back_populates="tutor")
    specialty_ref = db.relationship("Specialty")

    def ensure_results_access_token(self):
        if not self.results_access_token:
            self.results_access_token = secrets.token_urlsafe(32)
        return self.results_access_token

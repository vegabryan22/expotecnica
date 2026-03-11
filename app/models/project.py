from datetime import datetime

from app.extensions import db


class Project(db.Model):
    __tablename__ = "projects"

    id = db.Column(db.Integer, primary_key=True)
    registration_date = db.Column(db.Date, nullable=True)
    title = db.Column(db.String(180), nullable=False)
    team_name = db.Column(db.String(180), nullable=False)
    representative_name = db.Column(db.String(120), nullable=False)
    representative_email = db.Column(db.String(120), nullable=False)
    representative_phone = db.Column(db.String(40), nullable=True)
    institution_name = db.Column(db.String(180), nullable=True)
    grade_level = db.Column(db.String(60), nullable=True)
    specialty = db.Column(db.String(120), nullable=True)
    section_id = db.Column(db.Integer, db.ForeignKey("sections.id"), nullable=True, index=True)
    specialty_id = db.Column(db.Integer, db.ForeignKey("specialties.id"), nullable=True, index=True)
    workshop_id = db.Column(db.Integer, db.ForeignKey("workshops.id"), nullable=True, index=True)
    advisor_name = db.Column(db.String(120), nullable=True)
    advisor_identity = db.Column(db.String(40), nullable=True)
    advisor_email = db.Column(db.String(120), nullable=True)
    advisor_phone = db.Column(db.String(40), nullable=True)
    category = db.Column(db.String(60), nullable=False, index=True)
    description = db.Column(db.Text, nullable=False)
    project_objective = db.Column(db.Text, nullable=True)
    expected_impact = db.Column(db.Text, nullable=True)
    required_resources = db.Column(db.Text, nullable=True)
    requirements_summary = db.Column(db.Text, nullable=True)
    requirements_other = db.Column(db.String(255), nullable=True)
    project_document_path = db.Column(db.String(300), nullable=True)
    consent_terms = db.Column(db.Boolean, default=False, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    assignments = db.relationship("Assignment", back_populates="project", cascade="all, delete-orphan")
    evaluations = db.relationship("Evaluation", back_populates="project", cascade="all, delete-orphan")
    members = db.relationship("ProjectMember", back_populates="project", cascade="all, delete-orphan")
    section = db.relationship("Section")
    specialty_ref = db.relationship("Specialty")
    workshop_ref = db.relationship("Workshop")

from datetime import datetime

from app.extensions import db


class Project(db.Model):
    __tablename__ = "projects"

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(180), nullable=False)
    team_name = db.Column(db.String(180), nullable=False)
    representative_name = db.Column(db.String(120), nullable=False)
    representative_email = db.Column(db.String(120), nullable=False)
    category = db.Column(db.Enum("steam", "emprendimiento", name="project_category"), nullable=False)
    description = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    assignments = db.relationship("Assignment", back_populates="project", cascade="all, delete-orphan")
    evaluations = db.relationship("Evaluation", back_populates="project", cascade="all, delete-orphan")
    members = db.relationship("ProjectMember", back_populates="project", cascade="all, delete-orphan")

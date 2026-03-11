from datetime import datetime

from app.extensions import db


class ProjectMemberChange(db.Model):
    __tablename__ = "project_member_changes"

    id = db.Column(db.Integer, primary_key=True)
    project_id = db.Column(db.Integer, db.ForeignKey("projects.id"), nullable=False, index=True)
    member_id = db.Column(db.Integer, db.ForeignKey("project_members.id"), nullable=True, index=True)
    action = db.Column(db.String(40), nullable=False)
    details = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    project = db.relationship("Project", back_populates="member_changes")
    member = db.relationship("ProjectMember")

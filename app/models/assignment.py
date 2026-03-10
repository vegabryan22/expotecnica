from app.extensions import db


class Assignment(db.Model):
    __tablename__ = "assignments"
    __table_args__ = (
        db.UniqueConstraint("judge_id", "project_id", name="uq_assignment_judge_project"),
    )

    id = db.Column(db.Integer, primary_key=True)
    judge_id = db.Column(db.Integer, db.ForeignKey("judges.id"), nullable=False)
    project_id = db.Column(db.Integer, db.ForeignKey("projects.id"), nullable=False)

    judge = db.relationship("Judge", back_populates="assignments")
    project = db.relationship("Project", back_populates="assignments")


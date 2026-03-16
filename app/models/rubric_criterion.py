from app.extensions import db


class RubricCriterion(db.Model):
    __tablename__ = "rubric_criteria"

    id = db.Column(db.Integer, primary_key=True)
    evaluation_type_id = db.Column(db.Integer, db.ForeignKey("evaluation_types.id"), nullable=False, index=True)
    section_name = db.Column(db.String(180), nullable=True)
    section_sort_order = db.Column(db.Integer, default=0, nullable=False)
    name = db.Column(db.String(500), nullable=False)
    min_score = db.Column(db.Integer, default=1, nullable=False)
    max_score = db.Column(db.Integer, default=25, nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)

    evaluation_type = db.relationship("EvaluationType", back_populates="rubric_criteria")
    scores = db.relationship("EvaluationScore", back_populates="criterion", cascade="all, delete-orphan")

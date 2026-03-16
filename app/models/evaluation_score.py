from app.extensions import db


class EvaluationScore(db.Model):
    __tablename__ = "evaluation_scores"
    __table_args__ = (
        db.UniqueConstraint("evaluation_id", "rubric_criterion_id", name="uq_evaluation_score_criterion"),
    )

    id = db.Column(db.Integer, primary_key=True)
    evaluation_id = db.Column(db.Integer, db.ForeignKey("evaluations.id"), nullable=False, index=True)
    rubric_criterion_id = db.Column(db.Integer, db.ForeignKey("rubric_criteria.id"), nullable=False, index=True)
    score = db.Column(db.Integer, nullable=False)
    observation = db.Column(db.Text, nullable=True)

    evaluation = db.relationship("Evaluation", back_populates="scores")
    criterion = db.relationship("RubricCriterion", back_populates="scores")

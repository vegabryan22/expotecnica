from app.extensions import db


class EvaluationType(db.Model):
    __tablename__ = "evaluation_types"

    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(60), unique=True, nullable=False, index=True)
    name = db.Column(db.String(120), nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)

    rubric_criteria = db.relationship(
        "RubricCriterion",
        back_populates="evaluation_type",
        cascade="all, delete-orphan",
        order_by="RubricCriterion.sort_order.asc()",
    )

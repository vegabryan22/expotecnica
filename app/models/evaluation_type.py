import json

from app.extensions import db


class EvaluationType(db.Model):
    __tablename__ = "evaluation_types"

    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(60), unique=True, nullable=False, index=True)
    name = db.Column(db.String(120), nullable=False)
    description = db.Column(db.Text, nullable=True)
    scale_labels = db.Column(db.Text, nullable=True)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)

    rubric_criteria = db.relationship(
        "RubricCriterion",
        back_populates="evaluation_type",
        cascade="all, delete-orphan",
        order_by="RubricCriterion.sort_order.asc()",
    )

    def get_scale_labels(self):
        if not self.scale_labels:
            return {}
        try:
            raw = json.loads(self.scale_labels)
        except (TypeError, ValueError, json.JSONDecodeError):
            return {}
        return {int(key): value for key, value in raw.items()}

    @property
    def short_name(self):
        return (self.name or "").strip()

    @property
    def long_description(self):
        return (self.description or self.name or "").strip()

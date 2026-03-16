from app.extensions import db


class Category(db.Model):
    __tablename__ = "categories"

    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(60), unique=True, nullable=False, index=True)
    name = db.Column(db.String(120), nullable=False)
    rubric_1_evaluation_type_id = db.Column(db.Integer, db.ForeignKey("evaluation_types.id"), nullable=True)
    rubric_2_evaluation_type_id = db.Column(db.Integer, db.ForeignKey("evaluation_types.id"), nullable=True)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    sort_order = db.Column(db.Integer, default=0, nullable=False)

    rubric_1_evaluation_type = db.relationship("EvaluationType", foreign_keys=[rubric_1_evaluation_type_id])
    rubric_2_evaluation_type = db.relationship("EvaluationType", foreign_keys=[rubric_2_evaluation_type_id])

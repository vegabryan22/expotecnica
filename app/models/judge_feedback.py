from datetime import datetime

from app.extensions import db


class JudgeFeedback(db.Model):
    __tablename__ = "judge_feedback"

    id = db.Column(db.Integer, primary_key=True)
    judge_id = db.Column(db.Integer, db.ForeignKey("judges.id", ondelete="SET NULL"), nullable=True, index=True)
    participation_id = db.Column(db.Integer, db.ForeignKey("judge_event_participations.id", ondelete="SET NULL"), nullable=True, unique=True, index=True)
    respondent_name = db.Column(db.String(140), nullable=True)
    organization_score = db.Column(db.Integer, nullable=False)
    attention_score = db.Column(db.Integer, nullable=False)
    ushers_score = db.Column(db.Integer, nullable=False)
    food_score = db.Column(db.Integer, nullable=False)
    had_breakfast = db.Column(db.Boolean, nullable=False, default=False)
    breakfast_score = db.Column(db.Integer, nullable=True)
    breakfast_opinion = db.Column(db.Text, nullable=True)
    stayed_for_lunch = db.Column(db.Boolean, nullable=False, default=False)
    lunch_score = db.Column(db.Integer, nullable=True)
    lunch_opinion = db.Column(db.Text, nullable=True)
    projects_score = db.Column(db.Integer, nullable=False)
    overall_score = db.Column(db.Integer, nullable=False)
    best_aspect = db.Column(db.Text, nullable=True)
    improvement_opportunity = db.Column(db.Text, nullable=True)
    additional_comments = db.Column(db.Text, nullable=True)
    would_participate_again = db.Column(db.Boolean, nullable=False, default=True)
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

    judge = db.relationship("Judge", backref="feedback_responses")
    participation = db.relationship("JudgeEventParticipation", backref=db.backref("feedback", uselist=False))

    SCORE_FIELDS = (
        "organization_score", "attention_score", "ushers_score",
        "projects_score", "overall_score",
    )

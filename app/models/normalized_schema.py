from datetime import datetime

from app.extensions import db


class Institution(db.Model):
    __tablename__ = "institutions"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(180), nullable=False, unique=True, index=True)
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)


class Mentor(db.Model):
    __tablename__ = "mentors"
    id = db.Column(db.Integer, primary_key=True)
    full_name = db.Column(db.String(120), nullable=False)
    identity_number = db.Column(db.String(40), nullable=True, unique=True, index=True)
    birth_date = db.Column(db.Date, nullable=True)
    gender = db.Column(db.String(20), nullable=True)
    specialty_id = db.Column(db.Integer, db.ForeignKey("specialties.id", ondelete="SET NULL"), nullable=True, index=True)
    email = db.Column(db.String(120), nullable=True, index=True)
    phone = db.Column(db.String(40), nullable=True)
    specialty = db.relationship("Specialty")


class CategoryEvaluationType(db.Model):
    __tablename__ = "category_evaluation_types"
    __table_args__ = (db.UniqueConstraint("category_id", "evaluation_type_id", name="uq_category_evaluation_type"),)
    id = db.Column(db.Integer, primary_key=True)
    category_id = db.Column(db.Integer, db.ForeignKey("categories.id", ondelete="CASCADE"), nullable=False, index=True)
    evaluation_type_id = db.Column(db.Integer, db.ForeignKey("evaluation_types.id", ondelete="RESTRICT"), nullable=False, index=True)
    sort_order = db.Column(db.Integer, nullable=False, default=0)


class RubricSection(db.Model):
    __tablename__ = "rubric_sections"
    __table_args__ = (db.UniqueConstraint("evaluation_type_id", "name", name="uq_rubric_section_name"),)
    id = db.Column(db.Integer, primary_key=True)
    evaluation_type_id = db.Column(db.Integer, db.ForeignKey("evaluation_types.id", ondelete="CASCADE"), nullable=False, index=True)
    name = db.Column(db.String(180), nullable=False)
    sort_order = db.Column(db.Integer, nullable=False, default=0)


class EvaluationScaleOption(db.Model):
    __tablename__ = "evaluation_scale_options"
    __table_args__ = (db.UniqueConstraint("evaluation_type_id", "score", name="uq_evaluation_scale_score"),)
    id = db.Column(db.Integer, primary_key=True)
    evaluation_type_id = db.Column(db.Integer, db.ForeignKey("evaluation_types.id", ondelete="CASCADE"), nullable=False, index=True)
    score = db.Column(db.Integer, nullable=False)
    label = db.Column(db.String(180), nullable=False)


class RubricScoreDescription(db.Model):
    __tablename__ = "rubric_score_descriptions"
    __table_args__ = (db.UniqueConstraint("rubric_criterion_id", "score", name="uq_rubric_description_score"),)
    id = db.Column(db.Integer, primary_key=True)
    rubric_criterion_id = db.Column(db.Integer, db.ForeignKey("rubric_criteria.id", ondelete="CASCADE"), nullable=False, index=True)
    score = db.Column(db.Integer, nullable=False)
    description = db.Column(db.Text, nullable=False)


class RequirementType(db.Model):
    __tablename__ = "requirement_types"
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(60), nullable=False, unique=True, index=True)
    name = db.Column(db.String(140), nullable=False)


class ProjectRequirement(db.Model):
    __tablename__ = "project_requirements"
    __table_args__ = (db.UniqueConstraint("project_id", "requirement_type_id", name="uq_project_requirement"),)
    id = db.Column(db.Integer, primary_key=True)
    project_id = db.Column(db.Integer, db.ForeignKey("projects.id", ondelete="CASCADE"), nullable=False, index=True)
    requirement_type_id = db.Column(db.Integer, db.ForeignKey("requirement_types.id", ondelete="RESTRICT"), nullable=False, index=True)
    is_confirmed = db.Column(db.Boolean, nullable=False, default=False)
    notes = db.Column(db.Text, nullable=True)


class ProjectRequirementItem(db.Model):
    __tablename__ = "project_requirement_items"
    __table_args__ = (db.UniqueConstraint("project_id", "sort_order", name="uq_project_requirement_item_order"),)
    id = db.Column(db.Integer, primary_key=True)
    project_id = db.Column(db.Integer, db.ForeignKey("projects.id", ondelete="CASCADE"), nullable=False, index=True)
    name = db.Column(db.String(255), nullable=False)
    quantity = db.Column(db.String(60), nullable=True)
    unit = db.Column(db.String(60), nullable=True)
    notes = db.Column(db.Text, nullable=True)
    is_confirmed = db.Column(db.Boolean, nullable=False, default=False)
    sort_order = db.Column(db.Integer, nullable=False, default=0)


class LogisticsCheckType(db.Model):
    __tablename__ = "logistics_check_types"
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(80), nullable=False, unique=True, index=True)
    name = db.Column(db.String(160), nullable=False)


class ProjectLogisticsCheck(db.Model):
    __tablename__ = "project_logistics_checks"
    __table_args__ = (db.UniqueConstraint("project_id", "check_type_id", name="uq_project_logistics_check"),)
    id = db.Column(db.Integer, primary_key=True)
    project_id = db.Column(db.Integer, db.ForeignKey("projects.id", ondelete="CASCADE"), nullable=False, index=True)
    check_type_id = db.Column(db.Integer, db.ForeignKey("logistics_check_types.id", ondelete="RESTRICT"), nullable=False, index=True)
    is_complete = db.Column(db.Boolean, nullable=False, default=False)
    notes = db.Column(db.Text, nullable=True)


class JudgeEventParticipation(db.Model):
    __tablename__ = "judge_event_participations"
    __table_args__ = (db.UniqueConstraint("judge_id", "campaign_id", name="uq_judge_campaign_participation"),)
    id = db.Column(db.Integer, primary_key=True)
    judge_id = db.Column(db.Integer, db.ForeignKey("judges.id", ondelete="CASCADE"), nullable=False, index=True)
    campaign_id = db.Column(db.Integer, db.ForeignKey("campaigns.id", ondelete="CASCADE"), nullable=False, index=True)
    attendance_token = db.Column(db.String(64), nullable=True, unique=True)
    attendance_confirmed = db.Column(db.Boolean, nullable=True)
    needs_parking = db.Column(db.Boolean, nullable=False, default=False)
    attendance_responded_at = db.Column(db.DateTime, nullable=True)
    attendance_invitation_sent_at = db.Column(db.DateTime, nullable=True)
    attendance_invitation_error = db.Column(db.Text, nullable=True)
    exposition_invitation_sent_at = db.Column(db.DateTime, nullable=True)
    exposition_attendance_confirmed = db.Column(db.Boolean, nullable=True)
    exposition_attendance_responded_at = db.Column(db.DateTime, nullable=True)


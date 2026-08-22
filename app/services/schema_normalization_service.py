import json

from sqlalchemy import inspect, text

from app.extensions import db


NORMALIZATION_VERSION = "2026.08.22.1"


def _columns(table):
    return {column["name"] for column in inspect(db.engine).get_columns(table)}


def _foreign_key_columns(table):
    return {tuple(item.get("constrained_columns") or ()) for item in inspect(db.engine).get_foreign_keys(table)}


def _add_column(connection, table, name, definition):
    if name not in _columns(table):
        connection.execute(text(f"ALTER TABLE {table} ADD COLUMN {name} {definition}"))


def _add_fk(connection, table, column, target, constraint, on_delete):
    if (column,) not in _foreign_key_columns(table):
        connection.execute(text(
            f"ALTER TABLE {table} ADD CONSTRAINT {constraint} FOREIGN KEY ({column}) "
            f"REFERENCES {target} ON DELETE {on_delete}"
        ))


def _add_unique_index(connection, table, name, columns):
    inspector = inspect(db.engine)
    existing = {item.get("name") for item in inspector.get_indexes(table)}
    existing.update(item.get("name") for item in inspector.get_unique_constraints(table))
    if name in existing:
        return
    grouped = ",".join(columns)
    duplicates = connection.execute(text(
        f"SELECT COUNT(*) FROM (SELECT {grouped} FROM {table} GROUP BY {grouped} HAVING COUNT(*)>1) duplicate_rows"
    )).scalar()
    if duplicates:
        raise RuntimeError(f"No se puede crear {name}: {table} contiene {duplicates} clave(s) duplicada(s).")
    connection.execute(text(f"CREATE UNIQUE INDEX {name} ON {table} ({grouped})"))


def migrate_normalized_schema():
    """Expand and backfill the normalized schema without deleting legacy evidence."""
    if db.engine.dialect.name != "mysql":
        return

    with db.engine.begin() as connection:
        _add_column(connection, "projects", "category_id", "INT NULL")
        _add_column(connection, "projects", "institution_id", "INT NULL")
        _add_column(connection, "projects", "mentor_id", "INT NULL")
        _add_column(connection, "project_members", "section_id", "INT NULL")
        _add_column(connection, "tutors", "specialty_id", "INT NULL")
        _add_column(connection, "evaluations", "evaluation_type_id", "INT NULL")
        _add_column(connection, "rubric_criteria", "rubric_section_id", "INT NULL")
        if "judge_feedback" in inspect(db.engine).get_table_names():
            _add_column(connection, "judge_feedback", "participation_id", "INT NULL")

        connection.execute(text(
            "INSERT IGNORE INTO institutions (name, created_at) "
            "SELECT DISTINCT TRIM(institution_name), UTC_TIMESTAMP() FROM projects "
            "WHERE NULLIF(TRIM(institution_name), '') IS NOT NULL"
        ))
        connection.execute(text(
            "UPDATE projects p JOIN institutions i ON LOWER(TRIM(i.name))=LOWER(TRIM(p.institution_name)) "
            "SET p.institution_id=i.id WHERE p.institution_id IS NULL"
        ))
        connection.execute(text(
            "UPDATE projects p JOIN categories c ON LOWER(TRIM(c.code))=LOWER(TRIM(p.category)) "
            "SET p.category_id=c.id WHERE p.category_id IS NULL"
        ))
        connection.execute(text(
            "INSERT IGNORE INTO mentors (full_name,identity_number,birth_date,gender,specialty_id,email,phone) "
            "SELECT MAX(NULLIF(TRIM(p.mentor_name),'')), MAX(NULLIF(REPLACE(REPLACE(UPPER(TRIM(p.mentor_identity)),'-',''),' ',''),'')), "
            "MAX(p.mentor_birth_date),MAX(NULLIF(TRIM(p.mentor_gender),'')),MAX(s.id),MAX(NULLIF(LOWER(TRIM(p.mentor_email)),'')),MAX(NULLIF(TRIM(p.mentor_phone),'')) "
            "FROM projects p LEFT JOIN specialties s ON LOWER(TRIM(s.name))=LOWER(TRIM(p.mentor_specialty)) "
            "WHERE NULLIF(TRIM(p.mentor_identity),'') IS NOT NULL GROUP BY REPLACE(REPLACE(UPPER(TRIM(p.mentor_identity)),'-',''),' ','')"
        ))
        connection.execute(text(
            "UPDATE projects p JOIN mentors m ON m.identity_number=REPLACE(REPLACE(UPPER(TRIM(p.mentor_identity)),'-',''),' ','') "
            "SET p.mentor_id=m.id WHERE p.mentor_id IS NULL"
        ))
        connection.execute(text(
            "UPDATE tutors t JOIN specialties s ON LOWER(TRIM(s.name))=LOWER(TRIM(t.specialty)) "
            "SET t.specialty_id=s.id WHERE t.specialty_id IS NULL"
        ))
        connection.execute(text(
            "UPDATE project_members m JOIN specialties s ON LOWER(TRIM(s.name))=LOWER(TRIM(m.specialty)) "
            "SET m.specialty_id=s.id WHERE m.specialty_id IS NULL"
        ))
        connection.execute(text(
            "UPDATE project_members m JOIN projects p ON p.id=m.project_id "
            "JOIN sections s ON LOWER(TRIM(s.name))=LOWER(TRIM(m.section_name)) "
            "SET m.section_id=s.id WHERE m.section_id IS NULL "
            "AND (p.section_id=s.id OR (SELECT COUNT(*) FROM sections sx WHERE LOWER(TRIM(sx.name))=LOWER(TRIM(m.section_name)))=1)"
        ))
        connection.execute(text(
            "UPDATE evaluations e JOIN evaluation_types t ON LOWER(TRIM(t.code))=LOWER(TRIM(e.evaluation_type)) "
            "SET e.evaluation_type_id=t.id WHERE e.evaluation_type_id IS NULL"
        ))
        connection.execute(text(
            "INSERT IGNORE INTO rubric_sections (evaluation_type_id,name,sort_order) "
            "SELECT evaluation_type_id,TRIM(section_name),MIN(section_sort_order) FROM rubric_criteria "
            "WHERE NULLIF(TRIM(section_name),'') IS NOT NULL GROUP BY evaluation_type_id,TRIM(section_name)"
        ))
        connection.execute(text(
            "UPDATE rubric_criteria c JOIN rubric_sections s ON s.evaluation_type_id=c.evaluation_type_id "
            "AND LOWER(TRIM(s.name))=LOWER(TRIM(c.section_name)) SET c.rubric_section_id=s.id "
            "WHERE c.rubric_section_id IS NULL"
        ))
        connection.execute(text(
            "INSERT IGNORE INTO category_evaluation_types (category_id,evaluation_type_id,sort_order) "
            "SELECT id,rubric_1_evaluation_type_id,1 FROM categories WHERE rubric_1_evaluation_type_id IS NOT NULL"
        ))
        connection.execute(text(
            "INSERT IGNORE INTO category_evaluation_types (category_id,evaluation_type_id,sort_order) "
            "SELECT id,rubric_2_evaluation_type_id,2 FROM categories WHERE rubric_2_evaluation_type_id IS NOT NULL"
        ))

        requirement_types = {
            "corriente": "Conexión a corriente", "salidas": "Salidas eléctricas",
            "internet": "Acceso a internet", "agua": "Acceso a agua", "otros": "Otros requerimientos",
        }
        for code, name in requirement_types.items():
            connection.execute(text("INSERT IGNORE INTO requirement_types (code,name) VALUES (:code,:name)"), {"code": code, "name": name})
        check_columns = {
            "corriente": "requirements_current_ok", "salidas": "requirements_outlets_ok",
            "internet": "requirements_internet_ok", "agua": "requirements_water_ok", "otros": "requirements_other_ok",
        }
        for code, column in check_columns.items():
            connection.execute(text(
                f"INSERT IGNORE INTO project_requirements (project_id,requirement_type_id,is_confirmed,notes) "
                f"SELECT p.id,t.id,p.{column},CASE WHEN t.code='otros' THEN p.requirements_other ELSE NULL END "
                "FROM projects p JOIN requirement_types t ON t.code=:code "
                "WHERE FIND_IN_SET(:code,REPLACE(COALESCE(p.requirements_summary,''),' ',''))>0"
            ), {"code": code})

        logistics = {
            "documento": ("Documento escrito", "logistics_document_ok"),
            "logo": ("Logo del proyecto", "logistics_logo_ok"),
            "fotografias": ("Fotografías", "logistics_photos_ok"),
            "formulario_firmado": ("Formulario de inscripción firmado", "logistics_registration_form_signed_ok"),
            "consentimientos": ("Consentimientos estudiantiles", "logistics_student_consents_signed_ok"),
            "cedula_tutor": ("Cédula del tutor", "logistics_cedula_tutor_ok"),
            "requerimientos": ("Requerimientos revisados", "logistics_requirements_reviewed_ok"),
        }
        for code, (name, column) in logistics.items():
            connection.execute(text("INSERT IGNORE INTO logistics_check_types (code,name) VALUES (:code,:name)"), {"code": code, "name": name})
            connection.execute(text(
                f"INSERT IGNORE INTO project_logistics_checks (project_id,check_type_id,is_complete) "
                f"SELECT p.id,t.id,p.{column} FROM projects p JOIN logistics_check_types t ON t.code=:code"
            ), {"code": code})

        campaign_id = connection.execute(text("SELECT id FROM campaigns ORDER BY end_date DESC,id DESC LIMIT 1")).scalar()
        if campaign_id:
            connection.execute(text(
                "INSERT IGNORE INTO judge_event_participations "
                "(judge_id,campaign_id,attendance_token,attendance_confirmed,needs_parking,attendance_responded_at,"
                "attendance_invitation_sent_at,attendance_invitation_error,exposition_invitation_sent_at,"
                "exposition_attendance_confirmed,exposition_attendance_responded_at) "
                "SELECT id,:campaign_id,attendance_token,attendance_confirmed,needs_parking,attendance_responded_at,"
                "attendance_invitation_sent_at,attendance_invitation_error,exposition_invitation_sent_at,"
                "exposition_attendance_confirmed,exposition_attendance_responded_at FROM judges WHERE role='judge'"
            ), {"campaign_id": campaign_id})
            if "judge_feedback" in inspect(db.engine).get_table_names():
                connection.execute(text(
                    "UPDATE judge_feedback f JOIN judge_event_participations p ON p.judge_id=f.judge_id "
                    "AND p.campaign_id=:campaign_id SET f.participation_id=p.id WHERE f.participation_id IS NULL"
                ), {"campaign_id": campaign_id})

        _add_fk(connection, "projects", "category_id", "categories(id)", "fk_projects_category", "RESTRICT")
        _add_fk(connection, "projects", "institution_id", "institutions(id)", "fk_projects_institution", "RESTRICT")
        _add_fk(connection, "projects", "mentor_id", "mentors(id)", "fk_projects_mentor", "SET NULL")
        _add_fk(connection, "project_members", "section_id", "sections(id)", "fk_members_section", "SET NULL")
        _add_fk(connection, "project_members", "specialty_id", "specialties(id)", "fk_members_specialty", "SET NULL")
        _add_fk(connection, "tutors", "specialty_id", "specialties(id)", "fk_tutors_specialty", "SET NULL")
        _add_fk(connection, "evaluations", "evaluation_type_id", "evaluation_types(id)", "fk_evaluations_type", "RESTRICT")
        _add_fk(connection, "rubric_criteria", "rubric_section_id", "rubric_sections(id)", "fk_criteria_section", "SET NULL")
        _add_fk(connection, "projects", "section_id", "sections(id)", "fk_projects_section", "SET NULL")
        _add_fk(connection, "projects", "specialty_id", "specialties(id)", "fk_projects_specialty", "SET NULL")
        _add_fk(connection, "projects", "thematic_axis_id", "thematic_axes(id)", "fk_projects_thematic_axis", "SET NULL")
        _add_fk(connection, "projects", "project_type_id", "project_types(id)", "fk_projects_project_type", "SET NULL")
        _add_fk(connection, "projects", "workshop_id", "workshops(id)", "fk_projects_workshop", "SET NULL")
        _add_fk(connection, "projects", "campaign_id", "campaigns(id)", "fk_projects_campaign", "RESTRICT")
        _add_fk(connection, "categories", "rubric_1_evaluation_type_id", "evaluation_types(id)", "fk_categories_rubric_1", "SET NULL")
        _add_fk(connection, "categories", "rubric_2_evaluation_type_id", "evaluation_types(id)", "fk_categories_rubric_2", "SET NULL")
        if "judge_feedback" in inspect(db.engine).get_table_names():
            _add_fk(connection, "judge_feedback", "participation_id", "judge_event_participations(id)", "fk_feedback_participation", "SET NULL")
        _add_unique_index(connection, "sections", "uq_sections_level_name", ("level_id", "name"))
        _add_unique_index(connection, "project_members", "uq_project_member_number", ("project_id", "student_number"))

    _migrate_json_values()


def _migrate_json_values():
    from app.models.evaluation_type import EvaluationType
    from app.models.project import Project
    from app.models.rubric_criterion import RubricCriterion
    from app.models.normalized_schema import EvaluationScaleOption, ProjectRequirementItem, RubricScoreDescription

    for evaluation_type in EvaluationType.query.all():
        try:
            labels = json.loads(evaluation_type.scale_labels or "{}")
        except (TypeError, ValueError):
            labels = {}
        for score, label in labels.items():
            numeric_score = int(score)
            existing = EvaluationScaleOption.query.filter_by(evaluation_type_id=evaluation_type.id, score=numeric_score).first()
            if existing:
                existing.label = str(label)
            else:
                db.session.add(EvaluationScaleOption(evaluation_type_id=evaluation_type.id, score=numeric_score, label=str(label)))
    for criterion in RubricCriterion.query.all():
        try:
            descriptions = json.loads(criterion.score_descriptions or "{}")
        except (TypeError, ValueError):
            descriptions = {}
        for score, description in descriptions.items():
            existing = RubricScoreDescription.query.filter_by(rubric_criterion_id=criterion.id, score=int(score)).first()
            if not existing:
                db.session.add(RubricScoreDescription(rubric_criterion_id=criterion.id, score=int(score), description=str(description)))
    for project in Project.query.all():
        if ProjectRequirementItem.query.filter_by(project_id=project.id).first():
            continue
        for order, item in enumerate(project.detailed_requirement_items, start=1):
            db.session.add(ProjectRequirementItem(
                project_id=project.id, name=item["name"], quantity=item["quantity"] or None,
                unit=item["unit"] or None, notes=item["notes"] or None,
                is_confirmed=bool(item["confirmed"]), sort_order=order,
            ))
    db.session.commit()

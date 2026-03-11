from app.models.category import Category
from app.models.evaluation_type import EvaluationType
from app.models.level import Level
from app.models.rubric_criterion import RubricCriterion
from app.models.section import Section
from app.models.specialty import Specialty
from app.models.system_setting import SystemSetting
from app.models.workshop import Workshop


DEFAULT_CATEGORIES = [
    {"code": "steam", "name": "STEAM", "sort_order": 1},
    {"code": "emprendimiento", "name": "Emprendimiento", "sort_order": 2},
]

DEFAULT_LEVELS = [
    {"code": "7", "name": "Septimo", "sort_order": 7},
    {"code": "8", "name": "Octavo", "sort_order": 8},
    {"code": "9", "name": "Noveno", "sort_order": 9},
    {"code": "10", "name": "Decimo", "sort_order": 10},
    {"code": "11", "name": "Undecimo", "sort_order": 11},
    {"code": "12", "name": "Duodecimo", "sort_order": 12},
]

DEFAULT_SECTIONS = [
    {"level_code": "7", "name": "7-1", "sort_order": 1},
    {"level_code": "8", "name": "8-1", "sort_order": 1},
    {"level_code": "9", "name": "9-1", "sort_order": 1},
    {"level_code": "10", "name": "10-1", "sort_order": 1},
    {"level_code": "11", "name": "11-1", "sort_order": 1},
    {"level_code": "12", "name": "12-1", "sort_order": 1},
]

DEFAULT_SPECIALTIES = [
    {"name": "Especialidad 1", "sort_order": 1},
    {"name": "Especialidad 2", "sort_order": 2},
]

DEFAULT_WORKSHOPS = [
    {"name": "Taller 1", "sort_order": 1},
    {"name": "Taller 2", "sort_order": 2},
]

DEFAULT_EVALUATION_TYPES = [
    {"code": "escrito", "name": "Escrito", "sort_order": 1},
    {"code": "exposicion", "name": "Exposicion", "sort_order": 2},
]

DEFAULT_RUBRICS = {
    "escrito": [
        {"name": "Dominio del tema", "min_score": 1, "max_score": 25, "sort_order": 1},
        {"name": "Metodologia", "min_score": 1, "max_score": 25, "sort_order": 2},
        {"name": "Innovacion", "min_score": 1, "max_score": 25, "sort_order": 3},
        {"name": "Impacto", "min_score": 1, "max_score": 25, "sort_order": 4},
    ],
    "exposicion": [
        {"name": "Claridad", "min_score": 1, "max_score": 25, "sort_order": 1},
        {"name": "Contenido", "min_score": 1, "max_score": 25, "sort_order": 2},
        {"name": "Argumentacion", "min_score": 1, "max_score": 25, "sort_order": 3},
        {"name": "Presentacion", "min_score": 1, "max_score": 25, "sort_order": 4},
    ],
}


def bootstrap_defaults(db):
    created = False

    if Category.query.count() == 0:
        for row in DEFAULT_CATEGORIES:
            db.session.add(Category(**row))
        created = True

    if Level.query.count() == 0:
        for row in DEFAULT_LEVELS:
            db.session.add(Level(**row))
        created = True

    if EvaluationType.query.count() == 0:
        for row in DEFAULT_EVALUATION_TYPES:
            db.session.add(EvaluationType(**row))
        created = True

    db.session.flush()

    for row in DEFAULT_SECTIONS:
        level = Level.query.filter_by(code=row["level_code"]).first()
        if not level:
            continue
        exists = Section.query.filter_by(level_id=level.id, name=row["name"]).first()
        if exists:
            continue
        db.session.add(
            Section(level_id=level.id, name=row["name"], sort_order=row["sort_order"], is_active=True)
        )
        created = True

    if Specialty.query.count() == 0:
        for row in DEFAULT_SPECIALTIES:
            db.session.add(Specialty(**row))
        created = True

    if Workshop.query.count() == 0:
        for row in DEFAULT_WORKSHOPS:
            db.session.add(Workshop(**row))
        created = True

    for type_code, rubric_rows in DEFAULT_RUBRICS.items():
        eval_type = EvaluationType.query.filter_by(code=type_code).first()
        if not eval_type:
            continue
        if RubricCriterion.query.filter_by(evaluation_type_id=eval_type.id).count() > 0:
            continue
        for rubric in rubric_rows:
            db.session.add(RubricCriterion(evaluation_type_id=eval_type.id, **rubric))
            created = True

    default_settings = {
        "school_name": "CTP Roberto Gamboa Valverde",
        "school_address": "Direccion institucional no configurada",
        "school_phone": "+506 0000-0000",
        "school_email": "direccion@ctprgv.edu",
        "school_logo_path": "",
        "maintenance_enabled": "0",
        "maintenance_message": "Estamos cargando informacion de proyectos. Vuelve pronto.",
        "maintenance_image_path": "",
    }
    for key, value in default_settings.items():
        if SystemSetting.get_value(key) is None:
            SystemSetting.set_value(key, value)
            created = True

    if created:
        db.session.commit()


def get_active_categories():
    return Category.query.filter_by(is_active=True).order_by(Category.sort_order.asc(), Category.name.asc()).all()


def get_active_evaluation_types():
    return (
        EvaluationType.query.filter_by(is_active=True)
        .order_by(EvaluationType.sort_order.asc(), EvaluationType.name.asc())
        .all()
    )


def get_active_rubrics_map():
    mapping = {}
    for evaluation_type in get_active_evaluation_types():
        criteria = (
            RubricCriterion.query.filter_by(evaluation_type_id=evaluation_type.id, is_active=True)
            .order_by(RubricCriterion.sort_order.asc(), RubricCriterion.id.asc())
            .all()
        )
        mapping[evaluation_type.code] = criteria[:4]
    return mapping

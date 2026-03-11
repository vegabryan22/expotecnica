from app.models.category import Category
from app.models.evaluation_type import EvaluationType
from app.models.rubric_criterion import RubricCriterion


DEFAULT_CATEGORIES = [
    {"code": "steam", "name": "STEAM", "sort_order": 1},
    {"code": "emprendimiento", "name": "Emprendimiento", "sort_order": 2},
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

    if EvaluationType.query.count() == 0:
        for row in DEFAULT_EVALUATION_TYPES:
            db.session.add(EvaluationType(**row))
        created = True

    db.session.flush()

    for type_code, rubric_rows in DEFAULT_RUBRICS.items():
        eval_type = EvaluationType.query.filter_by(code=type_code).first()
        if not eval_type:
            continue
        if RubricCriterion.query.filter_by(evaluation_type_id=eval_type.id).count() > 0:
            continue
        for rubric in rubric_rows:
            db.session.add(RubricCriterion(evaluation_type_id=eval_type.id, **rubric))
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

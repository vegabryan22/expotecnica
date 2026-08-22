"""Valida que la migración normalizada conserve datos y relaciones."""

import sys
from pathlib import Path

from sqlalchemy import inspect, text

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from app import create_app  # noqa: E402
from app.extensions import db  # noqa: E402


REQUIRED_FOREIGN_KEYS = {
    "projects": {"category_id", "institution_id", "mentor_id", "section_id", "specialty_id", "thematic_axis_id", "project_type_id", "workshop_id", "campaign_id", "tutor_id", "venue_id"},
    "project_members": {"project_id", "section_id", "specialty_id"},
    "tutors": {"specialty_id"},
    "evaluations": {"judge_id", "project_id", "project_member_id", "evaluation_type_id"},
    "rubric_criteria": {"evaluation_type_id", "rubric_section_id"},
    "judge_feedback": {"judge_id", "participation_id"},
}


CHECKS = {
    "proyectos sin categoría normalizada": "SELECT COUNT(*) FROM projects WHERE category_id IS NULL",
    "proyectos sin institución normalizada": "SELECT COUNT(*) FROM projects WHERE institution_id IS NULL",
    "tutores textuales sin tutor_id": "SELECT COUNT(*) FROM projects WHERE NULLIF(TRIM(advisor_identity),'') IS NOT NULL AND tutor_id IS NULL",
    "mentores textuales sin mentor_id": "SELECT COUNT(*) FROM projects WHERE NULLIF(TRIM(mentor_identity),'') IS NOT NULL AND mentor_id IS NULL",
    "integrantes con especialidad textual sin specialty_id": "SELECT COUNT(*) FROM project_members WHERE NULLIF(TRIM(specialty),'') IS NOT NULL AND specialty_id IS NULL",
    "integrantes con sección textual sin section_id": "SELECT COUNT(*) FROM project_members WHERE NULLIF(TRIM(section_name),'') IS NOT NULL AND section_id IS NULL",
    "evaluaciones identificadas sin evaluation_type_id": "SELECT COUNT(*) FROM evaluations WHERE NULLIF(TRIM(evaluation_type),'') IS NOT NULL AND evaluation_type_id IS NULL",
    "criterios con sección textual sin rubric_section_id": "SELECT COUNT(*) FROM rubric_criteria WHERE NULLIF(TRIM(section_name),'') IS NOT NULL AND rubric_section_id IS NULL",
    "puntajes sin evaluación": "SELECT COUNT(*) FROM evaluation_scores s LEFT JOIN evaluations e ON e.id=s.evaluation_id WHERE e.id IS NULL",
    "puntajes sin criterio": "SELECT COUNT(*) FROM evaluation_scores s LEFT JOIN rubric_criteria c ON c.id=s.rubric_criterion_id WHERE c.id IS NULL",
}


def main():
    app = create_app()
    failures = []
    with app.app_context():
        inspector = inspect(db.engine)
        print("VALIDACIÓN DE ESQUEMA NORMALIZADO")
        for label, statement in CHECKS.items():
            count = db.session.execute(text(statement)).scalar() or 0
            status = "OK" if count == 0 else "ERROR"
            print(f"[{status}] {label}: {count}")
            if count:
                failures.append(f"{label}: {count}")

        for table, required_columns in REQUIRED_FOREIGN_KEYS.items():
            if table not in inspector.get_table_names():
                failures.append(f"tabla ausente: {table}")
                continue
            actual = {
                column
                for item in inspector.get_foreign_keys(table)
                for column in (item.get("constrained_columns") or [])
            }
            missing = required_columns - actual
            print(f"[{'OK' if not missing else 'ERROR'}] FK {table}: faltan {sorted(missing)}")
            if missing:
                failures.append(f"FK {table}: {sorted(missing)}")

        counts = db.session.execute(text(
            "SELECT (SELECT COUNT(*) FROM projects),"
            "(SELECT COUNT(*) FROM project_members),"
            "(SELECT COUNT(*) FROM assignments),"
            "(SELECT COUNT(*) FROM evaluations),"
            "(SELECT COUNT(*) FROM evaluation_scores)"
        )).one()
        print(f"CONTEOS proyectos={counts[0]} integrantes={counts[1]} asignaciones={counts[2]} evaluaciones={counts[3]} puntajes={counts[4]}")

    if failures:
        print("\nMIGRACIÓN NO VÁLIDA")
        for failure in failures:
            print(f"- {failure}")
        return 1
    print("\nMIGRACIÓN VÁLIDA")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

from collections import defaultdict

from flask import abort, render_template
from sqlalchemy.orm import joinedload

from app.models.evaluation import Evaluation
from app.models.project import Project
from app.models.tutor import Tutor
from app.services.evaluation_service import get_project_evaluations_summary


def _evaluation_label(evaluation):
    evaluation_type = evaluation.evaluation_type_ref
    return evaluation_type.short_name if evaluation_type else evaluation.evaluation_type


def results(token):
    tutor = Tutor.query.filter_by(results_access_token=token).first()
    if not tutor or not tutor.is_active:
        abort(404)

    projects = (
        Project.query.options(
            joinedload(Project.members),
            joinedload(Project.evaluations).joinedload(Evaluation.evaluation_type_ref),
            joinedload(Project.evaluations).joinedload(Evaluation.project_member),
            joinedload(Project.evaluations).joinedload(Evaluation.scores),
        )
        .filter(Project.tutor_id == tutor.id, Project.is_active.is_(True))
        .order_by(Project.title.asc())
        .all()
    )

    project_rows = []
    for project in projects:
        grouped = defaultdict(list)
        for evaluation in sorted(project.evaluations, key=lambda item: (item.evaluation_type, item.created_at, item.id)):
            grouped[_evaluation_label(evaluation)].append(evaluation)

        evaluation_groups = []
        for label, evaluations in grouped.items():
            percentages = [item.percentage for item in evaluations if item.percentage is not None]
            records = []
            for index, evaluation in enumerate(evaluations, 1):
                observations = [
                    {"criterion": score.criterion.name, "text": score.observation.strip()}
                    for score in evaluation.scores
                    if score.observation and score.observation.strip()
                ]
                records.append(
                    {
                        "evaluator": f"Evaluador {index}",
                        "member": evaluation.project_member.full_name if evaluation.project_member else None,
                        "percentage": evaluation.percentage,
                        "comments": (evaluation.comments or "").strip(),
                        "recommendations": (evaluation.recommendations or "").strip(),
                        "observations": observations,
                    }
                )
            evaluation_groups.append(
                {
                    "label": label,
                    "average": round(sum(percentages) / len(percentages), 2) if percentages else None,
                    "count": len(evaluations),
                    "records": records,
                }
            )

        project_rows.append(
            {
                "project": project,
                "summary": get_project_evaluations_summary(project),
                "groups": evaluation_groups,
            }
        )

    return render_template("public/tutor_results.html", tutor=tutor, project_rows=project_rows)

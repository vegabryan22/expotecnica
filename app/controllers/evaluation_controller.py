from flask import abort, flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required

from app.extensions import db
from app.models.assignment import Assignment
from app.models.category import Category
from app.models.evaluation import Evaluation
from app.models.project import Project
from app.services.parameter_service import get_active_evaluation_types, get_active_rubrics_map


def _validate_score(raw_value, min_score: int, max_score: int):
    try:
        number = int(raw_value)
    except (ValueError, TypeError):
        return None
    return number if min_score <= number <= max_score else None


@login_required
def dashboard():
    assignments = (
        Assignment.query.filter_by(judge_id=current_user.id)
        .join(Project, Project.id == Assignment.project_id)
        .order_by(Project.created_at.desc())
        .all()
    )
    evaluation_types = get_active_evaluation_types()
    evaluation_map = {
        (e.project_id, e.evaluation_type): e
        for e in Evaluation.query.filter_by(judge_id=current_user.id).all()
    }
    category_map = {category.code: category.name for category in Category.query.all()}
    return render_template(
        "judge/dashboard.html",
        assignments=assignments,
        evaluation_map=evaluation_map,
        evaluation_types=evaluation_types,
        category_map=category_map,
    )


@login_required
def evaluate(project_id: int):
    eval_type = request.args.get("type", "").strip()
    evaluation_types = get_active_evaluation_types()
    eval_type_map = {item.code: item for item in evaluation_types}

    if eval_type not in eval_type_map:
        abort(400, "Tipo de evaluacion invalido.")

    rubric_map = get_active_rubrics_map()
    criteria = rubric_map.get(eval_type, [])
    if not criteria:
        abort(400, "No hay rubricas configuradas para este tipo de evaluacion.")

    assignment = Assignment.query.filter_by(judge_id=current_user.id, project_id=project_id).first()
    if not assignment:
        abort(403, "No tienes permiso para evaluar este proyecto.")

    project = Project.query.get_or_404(project_id)
    existing = Evaluation.query.filter_by(
        judge_id=current_user.id,
        project_id=project_id,
        evaluation_type=eval_type,
    ).first()

    if existing:
        flash("Ya registraste esta evaluacion.", "error")
        return redirect(url_for("judge.dashboard"))

    if request.method == "POST":
        scores = []
        for criterion in criteria:
            score = _validate_score(
                request.form.get(f"criterion_{criterion.id}"), criterion.min_score, criterion.max_score
            )
            if score is None:
                flash(
                    f"El criterio '{criterion.name}' debe estar entre {criterion.min_score} y {criterion.max_score}.",
                    "error",
                )
                return render_template(
                    "judge/evaluate.html",
                    project=project,
                    eval_type=eval_type,
                    eval_type_name=eval_type_map[eval_type].name,
                    criteria=criteria,
                )
            scores.append(score)

        comments = request.form.get("comments", "").strip()
        padded_scores = (scores + [None, None, None, None])[:4]

        evaluation = Evaluation(
            judge_id=current_user.id,
            project_id=project.id,
            evaluation_type=eval_type,
            criteria_1=padded_scores[0],
            criteria_2=padded_scores[1],
            criteria_3=padded_scores[2],
            criteria_4=padded_scores[3],
            comments=comments,
        )
        db.session.add(evaluation)
        db.session.commit()
        flash("Evaluacion registrada correctamente.", "success")
        return redirect(url_for("judge.dashboard"))

    return render_template(
        "judge/evaluate.html",
        project=project,
        eval_type=eval_type,
        eval_type_name=eval_type_map[eval_type].name,
        criteria=criteria,
    )

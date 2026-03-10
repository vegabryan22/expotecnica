from flask import abort, flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required

from app.extensions import db
from app.models.assignment import Assignment
from app.models.evaluation import Evaluation
from app.models.project import Project


def _validate_score(value: str):
    try:
        number = int(value)
    except (ValueError, TypeError):
        return None
    return number if 1 <= number <= 25 else None


@login_required
def dashboard():
    assignments = (
        Assignment.query.filter_by(judge_id=current_user.id)
        .join(Project, Project.id == Assignment.project_id)
        .order_by(Project.created_at.desc())
        .all()
    )
    evaluation_map = {
        (e.project_id, e.evaluation_type): e
        for e in Evaluation.query.filter_by(judge_id=current_user.id).all()
    }
    return render_template(
        "judge/dashboard.html",
        assignments=assignments,
        evaluation_map=evaluation_map,
    )


@login_required
def evaluate(project_id: int):
    eval_type = request.args.get("type", "").strip()
    if eval_type not in {"escrito", "exposicion"}:
        abort(400, "Tipo de evaluación inválido.")

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
        flash("Ya registraste esta evaluación.", "error")
        return redirect(url_for("judge.dashboard"))

    if request.method == "POST":
        c1 = _validate_score(request.form.get("criteria_1"))
        c2 = _validate_score(request.form.get("criteria_2"))
        c3 = _validate_score(request.form.get("criteria_3"))
        c4 = _validate_score(request.form.get("criteria_4"))
        comments = request.form.get("comments", "").strip()

        if None in {c1, c2, c3, c4}:
            flash("Cada criterio debe tener una puntuación entre 1 y 25.", "error")
            return render_template("judge/evaluate.html", project=project, eval_type=eval_type)

        evaluation = Evaluation(
            judge_id=current_user.id,
            project_id=project.id,
            evaluation_type=eval_type,
            criteria_1=c1,
            criteria_2=c2,
            criteria_3=c3,
            criteria_4=c4,
            comments=comments,
        )
        db.session.add(evaluation)
        db.session.commit()
        flash("Evaluación registrada correctamente.", "success")
        return redirect(url_for("judge.dashboard"))

    return render_template("judge/evaluate.html", project=project, eval_type=eval_type)


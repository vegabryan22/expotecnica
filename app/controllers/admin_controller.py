from functools import wraps

from flask import flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required

from app.extensions import db
from app.models.assignment import Assignment
from app.models.judge import Judge
from app.models.project import Project


def admin_required(view_func):
    @wraps(view_func)
    @login_required
    def wrapped(*args, **kwargs):
        if not current_user.is_admin:
            flash("Acceso denegado.", "error")
            return redirect(url_for("judge.dashboard"))
        return view_func(*args, **kwargs)

    wrapped.__name__ = view_func.__name__
    return wrapped


@admin_required
def dashboard():
    if request.method == "POST":
        judge_id = request.form.get("judge_id", type=int)
        project_id = request.form.get("project_id", type=int)

        judge = Judge.query.get(judge_id) if judge_id else None
        project = Project.query.get(project_id) if project_id else None
        if not judge or not project:
            flash("Juez o proyecto invalido.", "error")
            return redirect(url_for("admin.dashboard"))

        exists = Assignment.query.filter_by(judge_id=judge_id, project_id=project_id).first()
        if exists:
            flash("Esa asignacion ya existe.", "error")
            return redirect(url_for("admin.dashboard"))

        db.session.add(Assignment(judge_id=judge_id, project_id=project_id))
        db.session.commit()
        flash("Asignacion creada.", "success")
        return redirect(url_for("admin.dashboard"))

    judges = Judge.query.order_by(Judge.full_name.asc()).all()
    projects = Project.query.order_by(Project.created_at.desc()).all()
    assignments = (
        Assignment.query.join(Judge, Judge.id == Assignment.judge_id)
        .join(Project, Project.id == Assignment.project_id)
        .order_by(Project.created_at.desc())
        .all()
    )

    return render_template(
        "admin/dashboard.html",
        judges=judges,
        projects=projects,
        assignments=assignments,
    )

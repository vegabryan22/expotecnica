import os
import re
import secrets

from functools import wraps

from flask import flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required
from sqlalchemy.orm import joinedload

from app.extensions import db
from app.models.assignment import Assignment
from app.models.category import Category
from app.models.evaluation_type import EvaluationType
from app.models.judge import Judge
from app.models.project import Project
from app.models.rubric_criterion import RubricCriterion
from app.models.system_setting import SystemSetting
from app.services.mail_service import send_email, smtp_is_configured


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


def _normalize_code(raw_value: str):
    raw_value = (raw_value or "").strip().lower()
    raw_value = re.sub(r"\s+", "_", raw_value)
    raw_value = re.sub(r"[^a-z0-9_]", "", raw_value)
    return raw_value


def _str_to_bool(value: str):
    return str(value).strip().lower() in {"1", "true", "on", "yes"}


def _redirect_next():
    next_url = request.form.get("next", "").strip()
    if next_url and next_url.startswith("/admin/"):
        return redirect(next_url)
    return redirect(url_for("admin.overview"))


def _send_judge_credentials_email(judge: Judge, plain_password: str):
    if not smtp_is_configured():
        return

    subject = "Credenciales de acceso - ExpoTecnica"
    body = (
        f"Hola {judge.full_name},\n\n"
        "Se ha creado/actualizado tu acceso a ExpoTecnica.\n"
        f"Usuario: {judge.email}\n"
        f"Contrasena temporal: {plain_password}\n\n"
        "Por seguridad, cambia esta contrasena al ingresar.\n"
    )
    ok, error = send_email(judge.email, subject, body)
    if not ok:
        flash(f"No se pudo enviar correo de credenciales: {error}", "error")


def _send_assignment_email(judge: Judge, project: Project):
    if not smtp_is_configured():
        return

    subject = "Nuevo proyecto asignado - ExpoTecnica"
    body = (
        f"Hola {judge.full_name},\n\n"
        "Tienes un nuevo proyecto asignado para evaluacion:\n"
        f"Proyecto: {project.title}\n"
        f"Categoria: {project.category}\n"
        f"Equipo: {project.team_name}\n\n"
        "Ingresa al panel de juez para completar la evaluacion.\n"
    )
    ok, error = send_email(judge.email, subject, body)
    if not ok:
        flash(f"No se pudo enviar correo de asignacion: {error}", "error")


def _delete_project_member_photos(project: Project):
    from flask import current_app

    for member in project.members:
        if member.photo_url.startswith("http://") or member.photo_url.startswith("https://"):
            continue
        try:
            full_path = os.path.join(current_app.static_folder, member.photo_url.replace("/", os.sep))
            if os.path.exists(full_path):
                os.remove(full_path)
        except Exception:  # noqa: BLE001
            continue


def _handle_action(action: str):
    if action == "create_assignment":
        judge_id = request.form.get("judge_id", type=int)
        project_id = request.form.get("project_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        project = Project.query.get(project_id) if project_id else None

        if not judge or not project:
            flash("Juez o proyecto invalido.", "error")
        elif Assignment.query.filter_by(judge_id=judge_id, project_id=project_id).first():
            flash("Esa asignacion ya existe.", "error")
        else:
            db.session.add(Assignment(judge_id=judge_id, project_id=project_id))
            db.session.commit()
            flash("Asignacion creada.", "success")
            _send_assignment_email(judge, project)

    elif action == "delete_assignment":
        assignment_id = request.form.get("assignment_id", type=int)
        assignment = Assignment.query.get(assignment_id) if assignment_id else None
        if not assignment:
            flash("Asignacion no encontrada.", "error")
        else:
            db.session.delete(assignment)
            db.session.commit()
            flash("Asignacion eliminada.", "success")

    elif action == "create_judge":
        full_name = request.form.get("judge_full_name", "").strip()
        email = request.form.get("judge_email", "").strip().lower()
        is_admin = _str_to_bool(request.form.get("judge_is_admin"))

        if not full_name or not email:
            flash("Nombre y correo de juez son obligatorios.", "error")
        elif Judge.query.filter_by(email=email).first():
            flash("Ya existe un usuario con ese correo.", "error")
        else:
            temp_password = secrets.token_urlsafe(8)
            judge = Judge(full_name=full_name, email=email, is_admin=is_admin, is_active_user=True)
            judge.set_password(temp_password)
            db.session.add(judge)
            db.session.commit()
            flash("Juez creado correctamente.", "success")
            _send_judge_credentials_email(judge, temp_password)

    elif action == "reset_judge_password":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        if not judge:
            flash("Juez no encontrado.", "error")
        else:
            temp_password = secrets.token_urlsafe(8)
            judge.set_password(temp_password)
            db.session.commit()
            flash("Contrasena reiniciada.", "success")
            _send_judge_credentials_email(judge, temp_password)

    elif action == "toggle_judge_active":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        if not judge:
            flash("Juez no encontrado.", "error")
        elif judge.id == current_user.id:
            flash("No puedes desactivarte a ti mismo.", "error")
        else:
            judge.is_active_user = not judge.is_active_user
            db.session.commit()
            flash("Estado de juez actualizado.", "success")

    elif action == "toggle_judge_admin":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        if not judge:
            flash("Juez no encontrado.", "error")
        elif judge.id == current_user.id and judge.is_admin:
            flash("No puedes removerte el rol admin.", "error")
        else:
            judge.is_admin = not judge.is_admin
            db.session.commit()
            flash("Rol de juez actualizado.", "success")

    elif action == "delete_judge":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        if not judge:
            flash("Juez no encontrado.", "error")
        elif judge.id == current_user.id:
            flash("No puedes eliminar tu propio usuario.", "error")
        else:
            db.session.delete(judge)
            db.session.commit()
            flash("Juez eliminado.", "success")

    elif action == "update_project":
        project_id = request.form.get("project_id", type=int)
        project = Project.query.get(project_id) if project_id else None
        if not project:
            flash("Proyecto no encontrado.", "error")
        else:
            category = request.form.get("project_category", "").strip()
            category_exists = Category.query.filter_by(code=category).first() is not None
            if not category_exists:
                flash("Categoria invalida.", "error")
            else:
                project.title = request.form.get("project_title", "").strip()
                project.team_name = request.form.get("project_team_name", "").strip()
                project.representative_name = request.form.get("project_representative_name", "").strip()
                project.representative_email = request.form.get("project_representative_email", "").strip().lower()
                project.category = category
                project.description = request.form.get("project_description", "").strip()

                if not all([
                    project.title,
                    project.team_name,
                    project.representative_name,
                    project.representative_email,
                    project.category,
                    project.description,
                ]):
                    flash("Todos los campos del proyecto son obligatorios.", "error")
                else:
                    db.session.commit()
                    flash("Proyecto actualizado.", "success")

    elif action == "delete_project":
        project_id = request.form.get("project_id", type=int)
        project = Project.query.get(project_id) if project_id else None
        if not project:
            flash("Proyecto no encontrado.", "error")
        else:
            _delete_project_member_photos(project)
            db.session.delete(project)
            db.session.commit()
            flash("Proyecto eliminado.", "success")

    elif action == "create_category":
        code = _normalize_code(request.form.get("category_code", ""))
        name = request.form.get("category_name", "").strip()
        sort_order = request.form.get("category_sort_order", type=int) or 0
        if not code or not name:
            flash("Codigo y nombre de categoria son obligatorios.", "error")
        elif Category.query.filter_by(code=code).first():
            flash("El codigo de categoria ya existe.", "error")
        else:
            db.session.add(Category(code=code, name=name, sort_order=sort_order, is_active=True))
            db.session.commit()
            flash("Categoria creada.", "success")

    elif action == "update_category":
        category_id = request.form.get("category_id", type=int)
        category = Category.query.get(category_id) if category_id else None
        if not category:
            flash("Categoria no encontrada.", "error")
        else:
            code = _normalize_code(request.form.get("category_code", ""))
            name = request.form.get("category_name", "").strip()
            sort_order = request.form.get("category_sort_order", type=int) or 0
            is_active = _str_to_bool(request.form.get("category_is_active"))
            duplicate = Category.query.filter(Category.code == code, Category.id != category.id).first()
            if not code or not name:
                flash("Codigo y nombre de categoria son obligatorios.", "error")
            elif duplicate:
                flash("Codigo de categoria ya en uso.", "error")
            else:
                category.code = code
                category.name = name
                category.sort_order = sort_order
                category.is_active = is_active
                db.session.commit()
                flash("Categoria actualizada.", "success")

    elif action == "delete_category":
        category_id = request.form.get("category_id", type=int)
        category = Category.query.get(category_id) if category_id else None
        if not category:
            flash("Categoria no encontrada.", "error")
        elif Project.query.filter_by(category=category.code).count() > 0:
            flash("No puedes eliminar una categoria con proyectos asociados.", "error")
        else:
            db.session.delete(category)
            db.session.commit()
            flash("Categoria eliminada.", "success")

    elif action == "create_evaluation_type":
        code = _normalize_code(request.form.get("eval_type_code", ""))
        name = request.form.get("eval_type_name", "").strip()
        sort_order = request.form.get("eval_type_sort_order", type=int) or 0
        if not code or not name:
            flash("Codigo y nombre del tipo de evaluacion son obligatorios.", "error")
        elif EvaluationType.query.filter_by(code=code).first():
            flash("El codigo del tipo de evaluacion ya existe.", "error")
        else:
            db.session.add(EvaluationType(code=code, name=name, sort_order=sort_order, is_active=True))
            db.session.commit()
            flash("Tipo de evaluacion creado.", "success")

    elif action == "update_evaluation_type":
        eval_type_id = request.form.get("eval_type_id", type=int)
        eval_type = EvaluationType.query.get(eval_type_id) if eval_type_id else None
        if not eval_type:
            flash("Tipo de evaluacion no encontrado.", "error")
        else:
            code = _normalize_code(request.form.get("eval_type_code", ""))
            name = request.form.get("eval_type_name", "").strip()
            sort_order = request.form.get("eval_type_sort_order", type=int) or 0
            is_active = _str_to_bool(request.form.get("eval_type_is_active"))
            duplicate = EvaluationType.query.filter(EvaluationType.code == code, EvaluationType.id != eval_type.id).first()
            if not code or not name:
                flash("Codigo y nombre del tipo de evaluacion son obligatorios.", "error")
            elif duplicate:
                flash("Codigo del tipo de evaluacion ya en uso.", "error")
            else:
                eval_type.code = code
                eval_type.name = name
                eval_type.sort_order = sort_order
                eval_type.is_active = is_active
                db.session.commit()
                flash("Tipo de evaluacion actualizado.", "success")

    elif action == "delete_evaluation_type":
        eval_type_id = request.form.get("eval_type_id", type=int)
        eval_type = EvaluationType.query.get(eval_type_id) if eval_type_id else None
        if not eval_type:
            flash("Tipo de evaluacion no encontrado.", "error")
        elif RubricCriterion.query.filter_by(evaluation_type_id=eval_type.id).count() > 0:
            flash("Elimina primero las rubricas asociadas.", "error")
        else:
            db.session.delete(eval_type)
            db.session.commit()
            flash("Tipo de evaluacion eliminado.", "success")

    elif action == "create_rubric":
        evaluation_type_id = request.form.get("rubric_evaluation_type_id", type=int)
        eval_type = EvaluationType.query.get(evaluation_type_id) if evaluation_type_id else None
        if not eval_type:
            flash("Tipo de evaluacion invalido.", "error")
        else:
            name = request.form.get("rubric_name", "").strip()
            min_score = request.form.get("rubric_min_score", type=int)
            max_score = request.form.get("rubric_max_score", type=int)
            sort_order = request.form.get("rubric_sort_order", type=int) or 0
            if not name or min_score is None or max_score is None or min_score > max_score:
                flash("Datos invalidos para rubrica.", "error")
            else:
                db.session.add(
                    RubricCriterion(
                        evaluation_type_id=eval_type.id,
                        name=name,
                        min_score=min_score,
                        max_score=max_score,
                        sort_order=sort_order,
                        is_active=True,
                    )
                )
                db.session.commit()
                flash("Rubrica creada.", "success")

    elif action == "update_rubric":
        rubric_id = request.form.get("rubric_id", type=int)
        rubric = RubricCriterion.query.get(rubric_id) if rubric_id else None
        if not rubric:
            flash("Rubrica no encontrada.", "error")
        else:
            rubric.name = request.form.get("rubric_name", "").strip()
            rubric.min_score = request.form.get("rubric_min_score", type=int) or 0
            rubric.max_score = request.form.get("rubric_max_score", type=int) or 0
            rubric.sort_order = request.form.get("rubric_sort_order", type=int) or 0
            rubric.is_active = _str_to_bool(request.form.get("rubric_is_active"))
            if not rubric.name or rubric.min_score > rubric.max_score:
                flash("Datos invalidos para rubrica.", "error")
            else:
                db.session.commit()
                flash("Rubrica actualizada.", "success")

    elif action == "delete_rubric":
        rubric_id = request.form.get("rubric_id", type=int)
        rubric = RubricCriterion.query.get(rubric_id) if rubric_id else None
        if not rubric:
            flash("Rubrica no encontrada.", "error")
        else:
            db.session.delete(rubric)
            db.session.commit()
            flash("Rubrica eliminada.", "success")

    elif action == "save_smtp":
        SystemSetting.set_value("smtp_host", request.form.get("smtp_host", "").strip())
        SystemSetting.set_value("smtp_port", request.form.get("smtp_port", "587").strip() or "587")
        SystemSetting.set_value("smtp_username", request.form.get("smtp_username", "").strip())
        if request.form.get("smtp_password"):
            SystemSetting.set_value("smtp_password", request.form.get("smtp_password", ""))
        SystemSetting.set_value("smtp_from_email", request.form.get("smtp_from_email", "").strip())
        SystemSetting.set_value("smtp_use_tls", "1" if _str_to_bool(request.form.get("smtp_use_tls")) else "0")
        SystemSetting.set_value("smtp_use_ssl", "1" if _str_to_bool(request.form.get("smtp_use_ssl")) else "0")
        db.session.commit()
        flash("Configuracion SMTP actualizada.", "success")

    elif action == "test_smtp":
        target_email = request.form.get("smtp_test_email", "").strip()
        if not target_email:
            flash("Ingresa un correo destino para prueba SMTP.", "error")
        else:
            ok, error = send_email(
                target_email,
                "Prueba SMTP - ExpoTecnica",
                "Este es un correo de prueba del modulo SMTP de ExpoTecnica.",
            )
            if ok:
                flash("Correo de prueba enviado.", "success")
            else:
                flash(f"No se pudo enviar correo de prueba: {error}", "error")


def _base_context(active_page: str):
    judges = Judge.query.order_by(Judge.full_name.asc()).all()
    categories = Category.query.order_by(Category.sort_order.asc(), Category.name.asc()).all()
    projects = Project.query.order_by(Project.created_at.desc()).all()
    assignments = (
        Assignment.query.options(joinedload(Assignment.judge), joinedload(Assignment.project))
        .order_by(Assignment.id.desc())
        .all()
    )
    evaluation_types = (
        EvaluationType.query.options(joinedload(EvaluationType.rubric_criteria))
        .order_by(EvaluationType.sort_order.asc(), EvaluationType.name.asc())
        .all()
    )

    smtp_settings = {
        "host": SystemSetting.get_value("smtp_host", ""),
        "port": SystemSetting.get_value("smtp_port", "587"),
        "username": SystemSetting.get_value("smtp_username", ""),
        "from_email": SystemSetting.get_value("smtp_from_email", ""),
        "use_tls": SystemSetting.get_value("smtp_use_tls", "1") == "1",
        "use_ssl": SystemSetting.get_value("smtp_use_ssl", "0") == "1",
    }

    return {
        "active_page": active_page,
        "action_url": url_for("admin.perform_action"),
        "next_url": request.path,
        "judges": judges,
        "categories": categories,
        "category_map": {row.code: row.name for row in categories},
        "projects": projects,
        "assignments": assignments,
        "evaluation_types": evaluation_types,
        "smtp_settings": smtp_settings,
        "smtp_configured": smtp_is_configured(),
    }


def _render(page_template: str, active_page: str):
    context = _base_context(active_page)
    return render_template(page_template, **context)


@admin_required
def perform_action():
    action = request.form.get("action", "").strip()
    if action:
        _handle_action(action)
    return _redirect_next()


@admin_required
def overview():
    return _render("admin/overview.html", "overview")


@admin_required
def assignments_page():
    return _render("admin/assignments.html", "assignments")


@admin_required
def judges_page():
    return _render("admin/judges.html", "judges")


@admin_required
def categories_page():
    return _render("admin/categories.html", "categories")


@admin_required
def rubrics_page():
    return _render("admin/rubrics.html", "rubrics")


@admin_required
def projects_page():
    return _render("admin/projects.html", "projects")


@admin_required
def smtp_page():
    return _render("admin/smtp.html", "smtp")

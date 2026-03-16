import os
import re
import secrets
import uuid
from datetime import datetime

from functools import wraps

from flask import current_app, flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required
from sqlalchemy.orm import joinedload
from werkzeug.utils import secure_filename

from app.extensions import db
from app.models.assignment import Assignment
from app.models.campaign import Campaign
from app.models.category import Category
from app.models.evaluation import Evaluation
from app.models.evaluation_type import EvaluationType
from app.models.judge import Judge
from app.models.level import Level
from app.models.project import Project
from app.models.project_member_change import ProjectMemberChange
from app.models.project_member import ProjectMember
from app.models.rubric_criterion import RubricCriterion
from app.models.section import Section
from app.models.specialty import Specialty
from app.models.system_audit_log import SystemAuditLog
from app.models.system_setting import SystemSetting
from app.models.workshop import Workshop
from app.services.audit_service import log_event
from app.services.evaluation_service import ENGLISH_EVAL_TYPE_CODE, build_admin_evaluation_overview
from app.services.mail_service import send_email, smtp_is_configured

ALLOWED_IMAGE_EXTENSIONS = {"png", "jpg", "jpeg", "webp", "gif"}
LOGISTICS_STATUSES = [
    ("inscrito", "Inscrito"),
    ("revision_logistica", "En revision logistica"),
    ("completo", "Completo"),
    ("incompleto", "Incompleto"),
]
USER_DEPARTMENTS = [
    ("logistica", "Logistica"),
    ("datos", "Datos"),
    ("diseno", "Diseno"),
    ("qa", "QA"),
]


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


def _valid_department(value: str):
    department = (value or "").strip().lower()
    valid_departments = {code for code, _ in USER_DEPARTMENTS}
    return department if department in valid_departments else ""


def _parse_date(raw_value):
    try:
        return datetime.strptime((raw_value or "").strip(), "%Y-%m-%d").date()
    except ValueError:
        return None


def _redirect_next():
    next_url = request.form.get("next", "").strip()
    if next_url and next_url.startswith("/admin/"):
        return redirect(next_url)
    return redirect(url_for("admin.overview"))


def _get_extension(filename):
    return filename.rsplit(".", 1)[-1].lower() if "." in filename else ""


def _save_member_photo(photo_file):
    original_name = secure_filename(photo_file.filename or "")
    extension = _get_extension(original_name)
    if extension not in ALLOWED_IMAGE_EXTENSIONS:
        raise ValueError("Formato de imagen invalido. Usa PNG, JPG, JPEG, WEBP o GIF.")

    relative_dir = os.path.join("uploads", "members")
    absolute_dir = os.path.join(current_app.static_folder, relative_dir)
    os.makedirs(absolute_dir, exist_ok=True)

    unique_name = f"{uuid.uuid4().hex}.{extension}"
    absolute_path = os.path.join(absolute_dir, unique_name)
    photo_file.save(absolute_path)
    return f"{relative_dir}/{unique_name}".replace("\\", "/")


def _save_project_logo(photo_file):
    original_name = secure_filename(photo_file.filename or "")
    extension = _get_extension(original_name)
    if extension not in ALLOWED_IMAGE_EXTENSIONS:
        raise ValueError("Formato de logo invalido. Usa PNG, JPG, JPEG, WEBP o GIF.")

    relative_dir = os.path.join("uploads", "projects", "logos")
    absolute_dir = os.path.join(current_app.static_folder, relative_dir)
    os.makedirs(absolute_dir, exist_ok=True)

    unique_name = f"{uuid.uuid4().hex}.{extension}"
    absolute_path = os.path.join(absolute_dir, unique_name)
    photo_file.save(absolute_path)
    return f"{relative_dir}/{unique_name}".replace("\\", "/")


def _save_institution_logo(photo_file):
    original_name = secure_filename(photo_file.filename or "")
    extension = _get_extension(original_name)
    if extension not in ALLOWED_IMAGE_EXTENSIONS:
        raise ValueError("Formato de logo institucional invalido. Usa PNG, JPG, JPEG, WEBP o GIF.")

    relative_dir = os.path.join("uploads", "institution")
    absolute_dir = os.path.join(current_app.static_folder, relative_dir)
    os.makedirs(absolute_dir, exist_ok=True)

    unique_name = f"{uuid.uuid4().hex}.{extension}"
    absolute_path = os.path.join(absolute_dir, unique_name)
    photo_file.save(absolute_path)
    return f"{relative_dir}/{unique_name}".replace("\\", "/")


def _save_maintenance_image(photo_file):
    original_name = secure_filename(photo_file.filename or "")
    extension = _get_extension(original_name)
    if extension not in ALLOWED_IMAGE_EXTENSIONS:
        raise ValueError("Formato de imagen invalido. Usa PNG, JPG, JPEG, WEBP o GIF.")

    relative_dir = os.path.join("uploads", "maintenance")
    absolute_dir = os.path.join(current_app.static_folder, relative_dir)
    os.makedirs(absolute_dir, exist_ok=True)

    unique_name = f"{uuid.uuid4().hex}.{extension}"
    absolute_path = os.path.join(absolute_dir, unique_name)
    photo_file.save(absolute_path)
    return f"{relative_dir}/{unique_name}".replace("\\", "/")


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
    for member in project.members:
        if not member.photo_url:
            continue
        if member.photo_url.startswith("http://") or member.photo_url.startswith("https://"):
            continue
        try:
            full_path = os.path.join(current_app.static_folder, member.photo_url.replace("/", os.sep))
            if os.path.exists(full_path):
                os.remove(full_path)
        except Exception:  # noqa: BLE001
            continue

    if project.project_logo_path:
        try:
            logo_path = os.path.join(current_app.static_folder, project.project_logo_path.replace("/", os.sep))
            if os.path.exists(logo_path):
                os.remove(logo_path)
        except Exception:  # noqa: BLE001
            pass


def _delete_member_photo_file(member: ProjectMember):
    if not member.photo_url:
        return
    if member.photo_url.startswith("http://") or member.photo_url.startswith("https://"):
        return
    try:
        full_path = os.path.join(current_app.static_folder, member.photo_url.replace("/", os.sep))
        if os.path.exists(full_path):
            os.remove(full_path)
    except Exception:  # noqa: BLE001
        return


def _delete_project_logo_file(project: Project):
    if not project.project_logo_path:
        return
    if project.project_logo_path.startswith("http://") or project.project_logo_path.startswith("https://"):
        return
    try:
        full_path = os.path.join(current_app.static_folder, project.project_logo_path.replace("/", os.sep))
        if os.path.exists(full_path):
            os.remove(full_path)
    except Exception:  # noqa: BLE001
        return


def _delete_institution_logo_file(relative_path: str):
    if not relative_path:
        return
    if relative_path.startswith("http://") or relative_path.startswith("https://"):
        return
    try:
        full_path = os.path.join(current_app.static_folder, relative_path.replace("/", os.sep))
        if os.path.exists(full_path):
            os.remove(full_path)
    except Exception:  # noqa: BLE001
        return


def _add_member_change(project_id, member_id, action: str, details: str):
    db.session.add(
        ProjectMemberChange(
            project_id=project_id,
            member_id=member_id,
            action=action,
            details=details,
        )
    )


def _resolve_member_academic_fields(form_data):
    section = Section.query.options(joinedload(Section.level)).get(form_data.get("member_section_id", type=int))
    if not section:
        return None, None, "Debes seleccionar una seccion valida."

    level_code = (section.level.code or "").strip() if section.level else ""
    focus_name = ""
    if level_code in {"7", "8", "9"}:
        workshop = Workshop.query.get(form_data.get("member_workshop_id", type=int))
        if not workshop:
            return None, None, "Para niveles 7, 8 y 9 debes seleccionar un taller."
        focus_name = workshop.name
    elif level_code in {"10", "11", "12"}:
        specialty = Specialty.query.get(form_data.get("member_specialty_id", type=int))
        if not specialty:
            return None, None, "Para niveles 10, 11 y 12 debes seleccionar una especialidad."
        focus_name = specialty.name

    return section.name, focus_name, None


def _handle_action(action: str):
    if action == "create_campaign":
        name = request.form.get("campaign_name", "").strip()
        start_date = _parse_date(request.form.get("campaign_start_date"))
        end_date = _parse_date(request.form.get("campaign_end_date"))
        is_active = _str_to_bool(request.form.get("campaign_is_active"))
        notes = request.form.get("campaign_notes", "").strip()

        if not name or not start_date or not end_date:
            flash("Nombre y fechas de campana son obligatorios.", "error")
        elif start_date > end_date:
            flash("La fecha de inicio no puede ser mayor a la fecha final.", "error")
        elif Campaign.query.filter_by(name=name).first():
            flash("Ya existe una campana con ese nombre.", "error")
        else:
            if is_active:
                Campaign.query.update({"is_active": False})
            campaign = Campaign(name=name, start_date=start_date, end_date=end_date, is_active=is_active, notes=notes)
            db.session.add(campaign)
            log_event("admin.campaign.create", "campaign", detail=f"Campana creada: {name} ({start_date} a {end_date})")
            db.session.commit()
            flash("Campana creada.", "success")

    elif action == "update_campaign":
        campaign_id = request.form.get("campaign_id", type=int)
        campaign = Campaign.query.get(campaign_id) if campaign_id else None
        if not campaign:
            flash("Campana no encontrada.", "error")
        else:
            name = request.form.get("campaign_name", "").strip()
            start_date = _parse_date(request.form.get("campaign_start_date"))
            end_date = _parse_date(request.form.get("campaign_end_date"))
            is_active = _str_to_bool(request.form.get("campaign_is_active"))
            notes = request.form.get("campaign_notes", "").strip()
            duplicate = Campaign.query.filter(Campaign.name == name, Campaign.id != campaign.id).first()
            if not name or not start_date or not end_date:
                flash("Nombre y fechas de campana son obligatorios.", "error")
            elif start_date > end_date:
                flash("La fecha de inicio no puede ser mayor a la fecha final.", "error")
            elif duplicate:
                flash("El nombre de campana ya esta en uso.", "error")
            else:
                if is_active:
                    Campaign.query.update({"is_active": False})
                campaign.name = name
                campaign.start_date = start_date
                campaign.end_date = end_date
                campaign.is_active = is_active
                campaign.notes = notes
                log_event("admin.campaign.update", "campaign", entity_id=campaign.id, detail=f"Campana actualizada: {name}")
                db.session.commit()
                flash("Campana actualizada.", "success")

    elif action == "delete_campaign":
        campaign_id = request.form.get("campaign_id", type=int)
        campaign = Campaign.query.get(campaign_id) if campaign_id else None
        if not campaign:
            flash("Campana no encontrada.", "error")
        elif Project.query.filter_by(campaign_id=campaign.id).count() > 0:
            flash("No puedes eliminar una campana con proyectos asociados.", "error")
        else:
            log_event("admin.campaign.delete", "campaign", entity_id=campaign.id, detail=f"Campana eliminada: {campaign.name}")
            db.session.delete(campaign)
            db.session.commit()
            flash("Campana eliminada.", "success")

    elif action == "activate_campaign":
        campaign_id = request.form.get("campaign_id", type=int)
        campaign = Campaign.query.get(campaign_id) if campaign_id else None
        if not campaign:
            flash("Campana no encontrada.", "error")
        else:
            Campaign.query.update({"is_active": False})
            campaign.is_active = True
            log_event("admin.campaign.activate", "campaign", entity_id=campaign.id, detail=f"Campana activa: {campaign.name}")
            db.session.commit()
            flash("Campana activada.", "success")

    elif action == "deactivate_campaign":
        campaign_id = request.form.get("campaign_id", type=int)
        campaign = Campaign.query.get(campaign_id) if campaign_id else None
        if not campaign:
            flash("Campana no encontrada.", "error")
        else:
            campaign.is_active = False
            log_event("admin.campaign.deactivate", "campaign", entity_id=campaign.id, detail=f"Campana desactivada: {campaign.name}")
            db.session.commit()
            flash("Campana desactivada.", "success")

    elif action == "create_assignment":
        judge_id = request.form.get("judge_id", type=int)
        project_ids = request.form.getlist("project_ids")
        if not project_ids:
            single_project_id = request.form.get("project_id", type=int)
            if single_project_id:
                project_ids = [str(single_project_id)]

        judge = Judge.query.get(judge_id) if judge_id else None
        selected_project_ids = []
        for raw_id in project_ids:
            try:
                project_id = int(raw_id)
            except (TypeError, ValueError):
                continue
            if project_id not in selected_project_ids:
                selected_project_ids.append(project_id)

        projects = Project.query.filter(Project.id.in_(selected_project_ids)).all() if selected_project_ids else []
        project_map = {project.id: project for project in projects}

        if not judge or not selected_project_ids:
            flash("Debes seleccionar un juez y al menos un proyecto.", "error")
        elif len(project_map) != len(selected_project_ids):
            flash("Hay proyectos invalidos en la seleccion.", "error")
        else:
            created_projects = []
            skipped_projects = []
            for project_id in selected_project_ids:
                project = project_map[project_id]
                if Assignment.query.filter_by(judge_id=judge_id, project_id=project_id).first():
                    skipped_projects.append(project.title)
                    continue

                db.session.add(Assignment(judge_id=judge_id, project_id=project_id))
                created_projects.append(project)
                log_event(
                    "admin.assignment.create",
                    "assignment",
                    detail=(
                        f"Asignacion creada: juez={judge.full_name} <{judge.email}> "
                        f"=> proyecto=#{project.id} '{project.title}'"
                    ),
                )

            if created_projects:
                db.session.commit()
                for project in created_projects:
                    _send_assignment_email(judge, project)
                flash(f"Asignaciones creadas: {len(created_projects)}.", "success")
            elif skipped_projects:
                flash("Las asignaciones seleccionadas ya existian.", "error")

            if skipped_projects:
                flash(f"Se omitieron {len(skipped_projects)} proyectos ya asignados.", "error")

    elif action == "delete_assignment":
        assignment_id = request.form.get("assignment_id", type=int)
        assignment = Assignment.query.get(assignment_id) if assignment_id else None
        if not assignment:
            flash("Asignacion no encontrada.", "error")
        else:
            log_event(
                "admin.assignment.delete",
                "assignment",
                entity_id=assignment.id,
                detail=(
                    f"Asignacion eliminada: juez={assignment.judge.full_name} <{assignment.judge.email}> "
                    f"de proyecto=#{assignment.project.id} '{assignment.project.title}'"
                ),
            )
            db.session.delete(assignment)
            db.session.commit()
            flash("Asignacion eliminada.", "success")

    elif action == "create_judge":
        full_name = request.form.get("judge_full_name", "").strip()
        email = request.form.get("judge_email", "").strip().lower()
        department = _valid_department(request.form.get("judge_department"))
        job_title = request.form.get("judge_job_title", "").strip()
        phone = request.form.get("judge_phone", "").strip()
        is_admin = _str_to_bool(request.form.get("judge_is_admin"))
        manual_password = request.form.get("judge_password", "")
        if not full_name or not email or not department:
            flash("Nombre, correo y departamento son obligatorios.", "error")
        elif Judge.query.filter_by(email=email).first():
            flash("Ya existe un usuario con ese correo.", "error")
        elif manual_password and len(manual_password) < 8:
            flash("La contrasena manual debe tener al menos 8 caracteres.", "error")
        else:
            password_value = manual_password if manual_password else secrets.token_urlsafe(8)
            judge = Judge(
                full_name=full_name,
                email=email,
                department=department,
                job_title=job_title,
                phone=phone,
                is_admin=is_admin,
                is_active_user=True,
                must_change_password=not bool(manual_password),
            )
            judge.set_password(password_value)
            db.session.add(judge)
            log_event(
                "admin.user.create",
                "judge",
                detail=f"Nuevo usuario creado: {full_name} <{email}> departamento={department}",
            )
            db.session.commit()
            flash("Usuario creado correctamente.", "success")
            if not manual_password:
                _send_judge_credentials_email(judge, password_value)

    elif action == "update_judge":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        if not judge:
            flash("Usuario no encontrado.", "error")
        else:
            full_name = request.form.get("judge_full_name", "").strip()
            email = request.form.get("judge_email", "").strip().lower()
            department = _valid_department(request.form.get("judge_department"))
            job_title = request.form.get("judge_job_title", "").strip()
            phone = request.form.get("judge_phone", "").strip()
            is_admin = _str_to_bool(request.form.get("judge_is_admin"))
            is_active_user = _str_to_bool(request.form.get("judge_is_active_user", "1"))
            duplicate = Judge.query.filter(Judge.email == email, Judge.id != judge.id).first()
            if not full_name or not email or not department:
                flash("Nombre, correo y departamento son obligatorios.", "error")
            elif duplicate:
                flash("Ya existe otro usuario con ese correo.", "error")
            elif judge.id == current_user.id and not is_active_user:
                flash("No puedes desactivarte a ti mismo.", "error")
            elif judge.id == current_user.id and judge.is_admin and not is_admin:
                flash("No puedes removerte el rol admin.", "error")
            else:
                judge.full_name = full_name
                judge.email = email
                judge.department = department
                judge.job_title = job_title
                judge.phone = phone
                judge.is_admin = is_admin
                judge.is_active_user = is_active_user
                log_event(
                    "admin.user.update",
                    "judge",
                    entity_id=judge.id,
                    detail=f"Usuario actualizado: {judge.full_name} <{judge.email}> departamento={judge.department}",
                )
                db.session.commit()
                flash("Usuario actualizado.", "success")

    elif action == "reset_judge_password":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        if not judge:
            flash("Usuario no encontrado.", "error")
        else:
            temp_password = secrets.token_urlsafe(8)
            judge.set_password(temp_password)
            judge.must_change_password = True
            log_event(
                "admin.user.reset_password",
                "judge",
                entity_id=judge.id,
                detail=f"Contrasena reiniciada para usuario: {judge.full_name} <{judge.email}>",
            )
            db.session.commit()
            flash("Contrasena reiniciada con clave temporal.", "success")
            _send_judge_credentials_email(judge, temp_password)

    elif action == "set_judge_password":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        new_password = request.form.get("judge_new_password", "")
        confirm_password = request.form.get("judge_confirm_password", "")
        if not judge:
            flash("Usuario no encontrado.", "error")
        elif len(new_password) < 8:
            flash("La contrasena manual debe tener al menos 8 caracteres.", "error")
        elif new_password != confirm_password:
            flash("La confirmacion de la contrasena no coincide.", "error")
        else:
            judge.set_password(new_password)
            judge.must_change_password = False
            log_event(
                "admin.user.set_password",
                "judge",
                entity_id=judge.id,
                detail=f"Contrasena asignada manualmente a usuario: {judge.full_name} <{judge.email}>",
            )
            db.session.commit()
            flash("Contrasena actualizada manualmente.", "success")

    elif action == "toggle_judge_active":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        if not judge:
            flash("Usuario no encontrado.", "error")
        elif judge.id == current_user.id:
            flash("No puedes desactivarte a ti mismo.", "error")
        else:
            judge.is_active_user = not judge.is_active_user
            log_event(
                "admin.user.toggle_active",
                "judge",
                entity_id=judge.id,
                detail=f"Estado activo de usuario {judge.full_name} <{judge.email}> => {judge.is_active_user}",
            )
            db.session.commit()
            flash("Estado de usuario actualizado.", "success")

    elif action == "toggle_judge_admin":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        if not judge:
            flash("Usuario no encontrado.", "error")
        elif judge.id == current_user.id and judge.is_admin:
            flash("No puedes removerte el rol admin.", "error")
        else:
            judge.is_admin = not judge.is_admin
            log_event(
                "admin.user.toggle_admin",
                "judge",
                entity_id=judge.id,
                detail=f"Rol admin de usuario {judge.full_name} <{judge.email}> => {judge.is_admin}",
            )
            db.session.commit()
            flash("Rol de usuario actualizado.", "success")

    elif action == "delete_judge":
        judge_id = request.form.get("judge_id", type=int)
        judge = Judge.query.get(judge_id) if judge_id else None
        if not judge:
            flash("Usuario no encontrado.", "error")
        elif judge.id == current_user.id:
            flash("No puedes eliminar tu propio usuario.", "error")
        else:
            log_event("admin.user.delete", "judge", entity_id=judge.id, detail=f"Usuario eliminado: {judge.full_name} <{judge.email}>")
            db.session.delete(judge)
            db.session.commit()
            flash("Usuario eliminado.", "success")

    elif action == "update_project":
        project_id = request.form.get("project_id", type=int)
        project = Project.query.get(project_id) if project_id else None
        if not project:
            flash("Proyecto no encontrado.", "error")
        else:
            project.title = request.form.get("project_title", "").strip()
            project.team_name = request.form.get("project_team_name", "").strip()
            project.representative_name = request.form.get("project_representative_name", "").strip()
            project.representative_email = request.form.get("project_representative_email", "").strip().lower()
            project.description = request.form.get("project_description", "").strip()
            if not all([project.title, project.team_name, project.representative_name, project.representative_email]):
                flash("Campos obligatorios incompletos en proyecto.", "error")
            else:
                log_event(
                    "admin.project.update",
                    "project",
                    entity_id=project.id,
                    detail=f"Proyecto actualizado: #{project.id} '{project.title}' (equipo: {project.team_name})",
                )
                db.session.commit()
                flash("Proyecto actualizado.", "success")

    elif action == "update_project_logistics":
        project_id = request.form.get("project_id", type=int)
        project = Project.query.get(project_id) if project_id else None
        if not project:
            flash("Proyecto no encontrado.", "error")
        else:
            status = request.form.get("logistics_status", "").strip()
            valid_status = {code for code, _ in LOGISTICS_STATUSES}
            if status not in valid_status:
                flash("Estado logistico invalido.", "error")
            else:
                project.is_active = _str_to_bool(request.form.get("project_is_active", "1"))
                project.logistics_status = status
                project.logistics_document_ok = _str_to_bool(request.form.get("logistics_document_ok"))
                project.logistics_logo_ok = _str_to_bool(request.form.get("logistics_logo_ok"))
                project.logistics_photos_ok = _str_to_bool(request.form.get("logistics_photos_ok"))
                project.logistics_notes = request.form.get("logistics_notes", "").strip()
                log_event(
                    "admin.project.logistics_update",
                    "project",
                    entity_id=project.id,
                    detail=(
                        f"Proyecto #{project.id} '{project.title}' => activo={project.is_active}, status={project.logistics_status}, "
                        f"doc={project.logistics_document_ok}, logo={project.logistics_logo_ok}, "
                        f"fotos={project.logistics_photos_ok}"
                    ),
                )
                db.session.commit()
                flash("Control logistico actualizado.", "success")

    elif action == "upload_project_logo":
        project_id = request.form.get("project_id", type=int)
        project = Project.query.get(project_id) if project_id else None
        logo_file = request.files.get("project_logo")
        if not project:
            flash("Proyecto no encontrado.", "error")
        elif not logo_file or not logo_file.filename:
            flash("Debes seleccionar un archivo de logo.", "error")
        else:
            try:
                new_path = _save_project_logo(logo_file)
                _delete_project_logo_file(project)
                project.project_logo_path = new_path
                project.logistics_logo_ok = True
                log_event(
                    "admin.project.logo_upload",
                    "project",
                    entity_id=project.id,
                    detail=f"Logo actualizado para proyecto #{project.id} '{project.title}'",
                )
                db.session.commit()
                flash("Logo del proyecto actualizado.", "success")
            except ValueError as error:
                flash(str(error), "error")

    elif action == "delete_project":
        project_id = request.form.get("project_id", type=int)
        project = Project.query.get(project_id) if project_id else None
        if not project:
            flash("Proyecto no encontrado.", "error")
        else:
            _delete_project_member_photos(project)
            log_event("admin.project.delete", "project", entity_id=project.id, detail=f"Proyecto eliminado: {project.title}")
            db.session.delete(project)
            db.session.commit()
            flash("Proyecto eliminado.", "success")

    elif action == "upload_member_photo":
        member_id = request.form.get("member_id", type=int)
        member = ProjectMember.query.get(member_id) if member_id else None
        photo_file = request.files.get("member_photo")
        if not member:
            flash("Integrante no encontrado.", "error")
        elif not photo_file or not photo_file.filename:
            flash("Debes seleccionar una foto para cargar.", "error")
        else:
            try:
                new_path = _save_member_photo(photo_file)
                _delete_member_photo_file(member)
                member.photo_url = new_path
                log_event(
                    "admin.member.photo_upload",
                    "project_member",
                    entity_id=member.id,
                    detail=(
                        f"Foto actualizada de integrante #{member.student_number} '{member.full_name}' "
                        f"en proyecto #{member.project_id} '{member.project.title if member.project else 'N/D'}'"
                    ),
                )
                db.session.commit()
                flash("Foto del integrante actualizada.", "success")
            except ValueError as error:
                flash(str(error), "error")

    elif action == "create_project_member":
        project_id = request.form.get("project_id", type=int)
        project = Project.query.options(joinedload(Project.members)).get(project_id) if project_id else None
        if not project:
            flash("Proyecto no encontrado.", "error")
        else:
            full_name = request.form.get("member_full_name", "").strip()
            identity_number = request.form.get("member_identity_number", "").strip()
            birth_date = _parse_date(request.form.get("member_birth_date"))
            gender = request.form.get("member_gender", "").strip().lower()
            phone = request.form.get("member_phone", "").strip()
            email = request.form.get("member_email", "").strip().lower()
            has_dining_scholarship = _str_to_bool(request.form.get("member_has_dining_scholarship"))
            participates_in_english = _str_to_bool(request.form.get("member_participates_in_english"))
            photo_file = request.files.get("member_photo")
            section_name, specialty, academic_error = _resolve_member_academic_fields(request.form)

            if not full_name:
                flash("El nombre del integrante es obligatorio.", "error")
            elif gender not in {"masculino", "femenino"}:
                flash("Genero invalido. Usa Masculino o Femenino.", "error")
            elif academic_error:
                flash(academic_error, "error")
            elif len(project.members) >= 3:
                flash("Cada proyecto permite un maximo de 3 integrantes.", "error")
            else:
                used_numbers = {member.student_number for member in project.members}
                number = request.form.get("member_student_number", type=int)
                if not number:
                    for candidate in [1, 2, 3]:
                        if candidate not in used_numbers:
                            number = candidate
                            break
                if not number or number < 1 or number > 3:
                    flash("Numero de estudiante invalido. Usa 1, 2 o 3.", "error")
                elif number in used_numbers:
                    flash("Ese numero de estudiante ya esta asignado en el proyecto.", "error")
                else:
                    new_member = ProjectMember(
                        project_id=project.id,
                        student_number=number,
                        full_name=full_name,
                        identity_number=identity_number,
                        birth_date=birth_date,
                        gender=gender,
                        specialty=specialty,
                        section_name=section_name,
                        has_dining_scholarship=has_dining_scholarship,
                        participates_in_english=participates_in_english,
                        phone=phone,
                        email=email,
                    )
                    db.session.add(new_member)
                    db.session.flush()
                    if photo_file and photo_file.filename:
                        try:
                            new_member.photo_url = _save_member_photo(photo_file)
                        except ValueError as error:
                            db.session.rollback()
                            flash(str(error), "error")
                            return
                    _add_member_change(
                        project.id,
                        new_member.id,
                        "created",
                        f"Integrante agregado: #{number} {new_member.full_name}",
                    )
                    log_event(
                        "admin.member.create",
                        "project_member",
                        entity_id=new_member.id,
                        detail=(
                            f"Integrante agregado: #{new_member.student_number} '{new_member.full_name}' "
                            f"en proyecto #{project.id} '{project.title}'"
                        ),
                    )
                    db.session.commit()
                    flash("Integrante agregado.", "success")

    elif action == "update_project_member":
        member_id = request.form.get("member_id", type=int)
        member = ProjectMember.query.options(joinedload(ProjectMember.project).joinedload(Project.members)).get(member_id) if member_id else None
        if not member:
            flash("Integrante no encontrado.", "error")
        else:
            full_name = request.form.get("member_full_name", "").strip()
            number = request.form.get("member_student_number", type=int)
            gender = request.form.get("member_gender", "").strip().lower()
            photo_file = request.files.get("member_photo")
            section_name, specialty, academic_error = _resolve_member_academic_fields(request.form)
            if not full_name:
                flash("El nombre del integrante es obligatorio.", "error")
            elif gender not in {"masculino", "femenino"}:
                flash("Genero invalido. Usa Masculino o Femenino.", "error")
            elif academic_error:
                flash(academic_error, "error")
            elif not number or number < 1 or number > 3:
                flash("Numero de estudiante invalido. Usa 1, 2 o 3.", "error")
            else:
                duplicate = None
                if number != member.student_number:
                    duplicate = ProjectMember.query.filter(
                        ProjectMember.project_id == member.project_id,
                        ProjectMember.student_number == number,
                        ProjectMember.id != member.id,
                    ).first()
                if duplicate:
                    flash("Ese numero de estudiante ya esta en uso.", "error")
                else:
                    before = (
                        f"#{member.student_number} {member.full_name} / {member.section_name or 'N/D'} / "
                        f"{member.specialty or 'N/D'}"
                    )
                    member.student_number = number
                    member.full_name = full_name
                    member.identity_number = request.form.get("member_identity_number", "").strip()
                    member.birth_date = _parse_date(request.form.get("member_birth_date"))
                    member.gender = gender
                    member.specialty = specialty
                    member.section_name = section_name
                    member.has_dining_scholarship = _str_to_bool(request.form.get("member_has_dining_scholarship"))
                    if "member_participates_in_english" in request.form:
                        member.participates_in_english = _str_to_bool(request.form.get("member_participates_in_english"))
                    member.phone = request.form.get("member_phone", "").strip()
                    member.email = request.form.get("member_email", "").strip().lower()
                    if photo_file and photo_file.filename:
                        try:
                            new_path = _save_member_photo(photo_file)
                            _delete_member_photo_file(member)
                            member.photo_url = new_path
                        except ValueError as error:
                            flash(str(error), "error")
                            return
                    after = (
                        f"#{member.student_number} {member.full_name} / {member.section_name or 'N/D'} / "
                        f"{member.specialty or 'N/D'}"
                    )
                    _add_member_change(member.project_id, member.id, "updated", f"{before} => {after}")
                    log_event(
                        "admin.member.update",
                        "project_member",
                        entity_id=member.id,
                        detail=(
                            f"Integrante actualizado: #{member.student_number} '{member.full_name}' "
                            f"en proyecto #{member.project_id} '{member.project.title if member.project else 'N/D'}'"
                        ),
                    )
                    db.session.commit()
                    flash("Integrante actualizado.", "success")

    elif action == "delete_project_member":
        member_id = request.form.get("member_id", type=int)
        member = ProjectMember.query.get(member_id) if member_id else None
        if not member:
            flash("Integrante no encontrado.", "error")
        else:
            details = f"Integrante eliminado: #{member.student_number} {member.full_name}"
            _add_member_change(member.project_id, member.id, "deleted", details)
            _delete_member_photo_file(member)
            log_event(
                "admin.member.delete",
                "project_member",
                entity_id=member.id,
                detail=(
                    f"Integrante eliminado: #{member.student_number} '{member.full_name}' "
                    f"de proyecto #{member.project_id} '{member.project.title if member.project else 'N/D'}'"
                ),
            )
            db.session.delete(member)
            db.session.commit()
            flash("Integrante eliminado.", "success")

    elif action == "create_category":
        code = _normalize_code(request.form.get("category_code", ""))
        name = request.form.get("category_name", "").strip()
        sort_order = request.form.get("category_sort_order", type=int) or 0
        rubric_1_evaluation_type_id = request.form.get("category_rubric_1_evaluation_type_id", type=int)
        rubric_2_evaluation_type_id = request.form.get("category_rubric_2_evaluation_type_id", type=int)
        rubric_1_eval_type = EvaluationType.query.get(rubric_1_evaluation_type_id) if rubric_1_evaluation_type_id else None
        rubric_2_eval_type = EvaluationType.query.get(rubric_2_evaluation_type_id) if rubric_2_evaluation_type_id else None
        if not code or not name:
            flash("Codigo y nombre de categoria son obligatorios.", "error")
        elif Category.query.filter_by(code=code).first():
            flash("El codigo de categoria ya existe.", "error")
        elif any(
            item and item.code == ENGLISH_EVAL_TYPE_CODE
            for item in [rubric_1_eval_type, rubric_2_eval_type]
        ):
            flash("La rubrica de ingles se activa automaticamente por proyecto y no por categoria.", "error")
        else:
            db.session.add(
                Category(
                    code=code,
                    name=name,
                    sort_order=sort_order,
                    rubric_1_evaluation_type_id=rubric_1_eval_type.id if rubric_1_eval_type else None,
                    rubric_2_evaluation_type_id=rubric_2_eval_type.id if rubric_2_eval_type else None,
                    is_active=True,
                )
            )
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
            rubric_1_evaluation_type_id = request.form.get("category_rubric_1_evaluation_type_id", type=int)
            rubric_2_evaluation_type_id = request.form.get("category_rubric_2_evaluation_type_id", type=int)
            rubric_1_eval_type = EvaluationType.query.get(rubric_1_evaluation_type_id) if rubric_1_evaluation_type_id else None
            rubric_2_eval_type = EvaluationType.query.get(rubric_2_evaluation_type_id) if rubric_2_evaluation_type_id else None
            duplicate = Category.query.filter(Category.code == code, Category.id != category.id).first()
            if not code or not name:
                flash("Codigo y nombre de categoria son obligatorios.", "error")
            elif duplicate:
                flash("Codigo de categoria ya en uso.", "error")
            elif any(
                item and item.code == ENGLISH_EVAL_TYPE_CODE
                for item in [rubric_1_eval_type, rubric_2_eval_type]
            ):
                flash("La rubrica de ingles se activa automaticamente por proyecto y no por categoria.", "error")
            else:
                category.code = code
                category.name = name
                category.sort_order = sort_order
                category.is_active = is_active
                category.rubric_1_evaluation_type_id = rubric_1_eval_type.id if rubric_1_eval_type else None
                category.rubric_2_evaluation_type_id = rubric_2_eval_type.id if rubric_2_eval_type else None
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

    elif action == "create_level":
        code = _normalize_code(request.form.get("level_code", ""))
        name = request.form.get("level_name", "").strip()
        sort_order = request.form.get("level_sort_order", type=int) or 0
        if not code or not name:
            flash("Codigo y nombre de nivel son obligatorios.", "error")
        elif Level.query.filter_by(code=code).first():
            flash("Ese codigo de nivel ya existe.", "error")
        else:
            db.session.add(Level(code=code, name=name, sort_order=sort_order, is_active=True))
            db.session.commit()
            flash("Nivel creado.", "success")

    elif action == "update_level":
        level_id = request.form.get("level_id", type=int)
        level = Level.query.get(level_id) if level_id else None
        if not level:
            flash("Nivel no encontrado.", "error")
        else:
            code = _normalize_code(request.form.get("level_code", ""))
            name = request.form.get("level_name", "").strip()
            sort_order = request.form.get("level_sort_order", type=int) or 0
            is_active = _str_to_bool(request.form.get("level_is_active"))
            duplicate = Level.query.filter(Level.code == code, Level.id != level.id).first()
            if not code or not name:
                flash("Codigo y nombre de nivel son obligatorios.", "error")
            elif duplicate:
                flash("Codigo de nivel ya en uso.", "error")
            else:
                level.code = code
                level.name = name
                level.sort_order = sort_order
                level.is_active = is_active
                db.session.commit()
                flash("Nivel actualizado.", "success")

    elif action == "create_section":
        level_id = request.form.get("section_level_id", type=int)
        name = request.form.get("section_name", "").strip()
        sort_order = request.form.get("section_sort_order", type=int) or 0
        level = Level.query.get(level_id) if level_id else None
        if not level or not name:
            flash("Nivel y nombre de seccion son obligatorios.", "error")
        else:
            exists = Section.query.filter_by(level_id=level.id, name=name).first()
            if exists:
                flash("La seccion ya existe en ese nivel.", "error")
            else:
                db.session.add(Section(level_id=level.id, name=name, sort_order=sort_order, is_active=True))
                db.session.commit()
                flash("Seccion creada.", "success")

    elif action == "update_section":
        section_id = request.form.get("section_id", type=int)
        section = Section.query.get(section_id) if section_id else None
        if not section:
            flash("Seccion no encontrada.", "error")
        else:
            level_id = request.form.get("section_level_id", type=int)
            name = request.form.get("section_name", "").strip()
            sort_order = request.form.get("section_sort_order", type=int) or 0
            is_active = _str_to_bool(request.form.get("section_is_active"))
            level = Level.query.get(level_id) if level_id else None
            if not level or not name:
                flash("Nivel y nombre de seccion son obligatorios.", "error")
            else:
                section.level_id = level.id
                section.name = name
                section.sort_order = sort_order
                section.is_active = is_active
                db.session.commit()
                flash("Seccion actualizada.", "success")

    elif action == "delete_section":
        section_id = request.form.get("section_id", type=int)
        section = Section.query.get(section_id) if section_id else None
        if not section:
            flash("Seccion no encontrada.", "error")
        elif Project.query.filter_by(section_id=section.id).count() > 0:
            flash("No puedes eliminar una seccion con proyectos asociados.", "error")
        else:
            db.session.delete(section)
            db.session.commit()
            flash("Seccion eliminada.", "success")

    elif action == "create_specialty":
        name = request.form.get("specialty_name", "").strip()
        sort_order = request.form.get("specialty_sort_order", type=int) or 0
        if not name:
            flash("Nombre de especialidad obligatorio.", "error")
        elif Specialty.query.filter_by(name=name).first():
            flash("La especialidad ya existe.", "error")
        else:
            db.session.add(Specialty(name=name, sort_order=sort_order, is_active=True))
            db.session.commit()
            flash("Especialidad creada.", "success")

    elif action == "update_specialty":
        specialty_id = request.form.get("specialty_id", type=int)
        specialty = Specialty.query.get(specialty_id) if specialty_id else None
        if not specialty:
            flash("Especialidad no encontrada.", "error")
        else:
            specialty.name = request.form.get("specialty_name", "").strip()
            specialty.sort_order = request.form.get("specialty_sort_order", type=int) or 0
            specialty.is_active = _str_to_bool(request.form.get("specialty_is_active"))
            if not specialty.name:
                flash("Nombre de especialidad obligatorio.", "error")
            else:
                db.session.commit()
                flash("Especialidad actualizada.", "success")

    elif action == "delete_specialty":
        specialty_id = request.form.get("specialty_id", type=int)
        specialty = Specialty.query.get(specialty_id) if specialty_id else None
        if not specialty:
            flash("Especialidad no encontrada.", "error")
        elif Project.query.filter_by(specialty_id=specialty.id).count() > 0:
            flash("No puedes eliminar una especialidad con proyectos asociados.", "error")
        else:
            db.session.delete(specialty)
            db.session.commit()
            flash("Especialidad eliminada.", "success")

    elif action == "create_workshop":
        name = request.form.get("workshop_name", "").strip()
        sort_order = request.form.get("workshop_sort_order", type=int) or 0
        if not name:
            flash("Nombre de taller obligatorio.", "error")
        elif Workshop.query.filter_by(name=name).first():
            flash("El taller ya existe.", "error")
        else:
            db.session.add(Workshop(name=name, sort_order=sort_order, is_active=True))
            db.session.commit()
            flash("Taller creado.", "success")

    elif action == "update_workshop":
        workshop_id = request.form.get("workshop_id", type=int)
        workshop = Workshop.query.get(workshop_id) if workshop_id else None
        if not workshop:
            flash("Taller no encontrado.", "error")
        else:
            workshop.name = request.form.get("workshop_name", "").strip()
            workshop.sort_order = request.form.get("workshop_sort_order", type=int) or 0
            workshop.is_active = _str_to_bool(request.form.get("workshop_is_active"))
            if not workshop.name:
                flash("Nombre de taller obligatorio.", "error")
            else:
                db.session.commit()
                flash("Taller actualizado.", "success")

    elif action == "delete_workshop":
        workshop_id = request.form.get("workshop_id", type=int)
        workshop = Workshop.query.get(workshop_id) if workshop_id else None
        if not workshop:
            flash("Taller no encontrado.", "error")
        elif Project.query.filter_by(workshop_id=workshop.id).count() > 0:
            flash("No puedes eliminar un taller con proyectos asociados.", "error")
        else:
            db.session.delete(workshop)
            db.session.commit()
            flash("Taller eliminado.", "success")

    elif action == "create_evaluation_type":
        name = request.form.get("eval_type_name", "").strip()
        raw_code = request.form.get("eval_type_code", "").strip()
        code = _normalize_code(raw_code) if raw_code else _normalize_code(name)
        name = request.form.get("eval_type_name", "").strip()
        sort_order = request.form.get("eval_type_sort_order", type=int) or 0
        if not code or not name:
            flash("Nombre del tipo de evaluacion es obligatorio.", "error")
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
            raw_code = request.form.get("eval_type_code", "").strip()
            name = request.form.get("eval_type_name", "").strip()
            code = _normalize_code(raw_code) if raw_code else _normalize_code(name)
            sort_order = request.form.get("eval_type_sort_order", type=int) or 0
            is_active = _str_to_bool(request.form.get("eval_type_is_active"))
            duplicate = EvaluationType.query.filter(EvaluationType.code == code, EvaluationType.id != eval_type.id).first()
            if not code or not name:
                flash("Nombre del tipo de evaluacion es obligatorio.", "error")
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
            section_name = request.form.get("rubric_section_name", "").strip()
            section_sort_order = request.form.get("rubric_section_sort_order", type=int) or 0
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
                        section_name=section_name or None,
                        section_sort_order=section_sort_order,
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
            rubric.section_name = request.form.get("rubric_section_name", "").strip() or None
            rubric.section_sort_order = request.form.get("rubric_section_sort_order", type=int) or 0
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

    elif action == "delete_evaluation":
        evaluation_id = request.form.get("evaluation_id", type=int)
        evaluation = Evaluation.query.options(joinedload(Evaluation.judge), joinedload(Evaluation.project)).get(evaluation_id) if evaluation_id else None
        if not evaluation:
            flash("Evaluacion no encontrada.", "error")
        else:
            log_event(
                "admin.evaluation.delete",
                "evaluation",
                entity_id=evaluation.id,
                detail=(
                    f"Evaluacion eliminada: proyecto=#{evaluation.project_id} "
                    f"'{evaluation.project.title if evaluation.project else 'N/D'}', "
                    f"juez={evaluation.judge.full_name if evaluation.judge else 'N/D'}, "
                    f"tipo={evaluation.evaluation_type}"
                ),
            )
            db.session.delete(evaluation)
            db.session.commit()
            flash("Evaluacion eliminada.", "success")

    elif action == "save_smtp":
        SystemSetting.set_value("smtp_host", request.form.get("smtp_host", "").strip())
        SystemSetting.set_value("smtp_port", request.form.get("smtp_port", "587").strip() or "587")
        SystemSetting.set_value("smtp_username", request.form.get("smtp_username", "").strip())
        if request.form.get("smtp_password"):
            SystemSetting.set_value("smtp_password", request.form.get("smtp_password", ""))
        SystemSetting.set_value("smtp_from_email", request.form.get("smtp_from_email", "").strip())
        SystemSetting.set_value("smtp_use_tls", "1" if _str_to_bool(request.form.get("smtp_use_tls")) else "0")
        SystemSetting.set_value("smtp_use_ssl", "1" if _str_to_bool(request.form.get("smtp_use_ssl")) else "0")
        log_event("admin.smtp.save", "smtp", detail="Configuracion SMTP actualizada")
        db.session.commit()
        flash("Configuracion SMTP actualizada.", "success")

    elif action == "test_smtp":
        target_email = request.form.get("smtp_test_email", "").strip()
        if not target_email:
            flash("Ingresa un correo destino para prueba SMTP.", "error")
        else:
            ok, error = send_email(target_email, "Prueba SMTP - ExpoTecnica", "Este es un correo de prueba del modulo SMTP de ExpoTecnica.")
            if ok:
                log_event("admin.smtp.test", "smtp", detail=f"Prueba enviada a {target_email}")
                flash("Correo de prueba enviado.", "success")
            else:
                log_event("admin.smtp.test_failed", "smtp", detail=f"Error al enviar a {target_email}: {error}")
                flash(f"No se pudo enviar correo de prueba: {error}", "error")

    elif action == "save_institution":
        name = request.form.get("school_name", "").strip()
        address = request.form.get("school_address", "").strip()
        phone = request.form.get("school_phone", "").strip()
        email = request.form.get("school_email", "").strip()
        logo_file = request.files.get("school_logo")
        if not name or not email:
            flash("Nombre y correo institucional son obligatorios.", "error")
        else:
            SystemSetting.set_value("school_name", name)
            SystemSetting.set_value("school_address", address)
            SystemSetting.set_value("school_phone", phone)
            SystemSetting.set_value("school_email", email)
            if logo_file and logo_file.filename:
                try:
                    old_logo = SystemSetting.get_value("school_logo_path", "")
                    new_logo = _save_institution_logo(logo_file)
                    SystemSetting.set_value("school_logo_path", new_logo)
                    _delete_institution_logo_file(old_logo)
                except ValueError as error:
                    flash(str(error), "error")
                    return
            log_event("admin.institution.save", "institution", detail=f"Datos institucionales actualizados: {name}")
            db.session.commit()
            flash("Informacion institucional actualizada.", "success")

    elif action == "save_maintenance_settings":
        maintenance_enabled = "1" if _str_to_bool(request.form.get("maintenance_enabled")) else "0"
        maintenance_message = request.form.get("maintenance_message", "").strip()
        maintenance_image = request.files.get("maintenance_image")
        if not maintenance_message:
            maintenance_message = "Estamos cargando informacion de proyectos. Vuelve pronto."

        SystemSetting.set_value("maintenance_enabled", maintenance_enabled)
        SystemSetting.set_value("maintenance_message", maintenance_message)
        if maintenance_image and maintenance_image.filename:
            try:
                old_image = SystemSetting.get_value("maintenance_image_path", "")
                new_image = _save_maintenance_image(maintenance_image)
                SystemSetting.set_value("maintenance_image_path", new_image)
                _delete_institution_logo_file(old_image)
            except ValueError as error:
                flash(str(error), "error")
                return
        log_event(
            "admin.maintenance.save",
            "system_setting",
            detail=(
                "Mantenimiento actualizado: "
                f"maintenance_enabled={maintenance_enabled}"
            ),
        )
        db.session.commit()
        flash("Configuracion de mantenimiento actualizada.", "success")


def _base_context(active_page: str):
    judges = Judge.query.order_by(Judge.full_name.asc()).all()
    campaigns = Campaign.query.order_by(Campaign.start_date.desc(), Campaign.id.desc()).all()
    categories = Category.query.order_by(Category.sort_order.asc(), Category.name.asc()).all()
    levels = Level.query.order_by(Level.sort_order.asc()).all()
    sections = Section.query.options(joinedload(Section.level)).order_by(Section.sort_order.asc(), Section.name.asc()).all()
    specialties = Specialty.query.order_by(Specialty.sort_order.asc(), Specialty.name.asc()).all()
    workshops = Workshop.query.order_by(Workshop.sort_order.asc(), Workshop.name.asc()).all()
    projects = Project.query.options(
        joinedload(Project.members),
        joinedload(Project.section),
        joinedload(Project.specialty_ref),
        joinedload(Project.workshop_ref),
        joinedload(Project.member_changes),
    ).order_by(Project.created_at.desc()).all()
    assignments = Assignment.query.options(joinedload(Assignment.judge), joinedload(Assignment.project)).order_by(Assignment.id.desc()).all()
    evaluation_types = EvaluationType.query.options(joinedload(EvaluationType.rubric_criteria)).order_by(EvaluationType.sort_order.asc(), EvaluationType.name.asc()).all()

    smtp_settings = {
        "host": SystemSetting.get_value("smtp_host", ""),
        "port": SystemSetting.get_value("smtp_port", "587"),
        "username": SystemSetting.get_value("smtp_username", ""),
        "from_email": SystemSetting.get_value("smtp_from_email", ""),
        "use_tls": SystemSetting.get_value("smtp_use_tls", "1") == "1",
        "use_ssl": SystemSetting.get_value("smtp_use_ssl", "0") == "1",
    }
    institution_settings = {
        "name": SystemSetting.get_value("school_name", "CTP Roberto Gamboa Valverde"),
        "address": SystemSetting.get_value("school_address", ""),
        "phone": SystemSetting.get_value("school_phone", ""),
        "email": SystemSetting.get_value("school_email", ""),
        "logo_path": SystemSetting.get_value("school_logo_path", ""),
    }
    maintenance_settings = {
        "maintenance_enabled": SystemSetting.get_value("maintenance_enabled", "0") == "1",
        "maintenance_message": SystemSetting.get_value(
            "maintenance_message",
            "Estamos cargando informacion de proyectos. Vuelve pronto.",
        ),
        "maintenance_image_path": SystemSetting.get_value("maintenance_image_path", ""),
    }

    return {
        "active_page": active_page,
        "action_url": url_for("admin.perform_action"),
        "next_url": request.path,
        "judges": judges,
        "campaigns": campaigns,
        "categories": categories,
        "levels": levels,
        "sections": sections,
        "specialties": specialties,
        "workshops": workshops,
        "category_map": {row.code: row.name for row in categories},
        "projects": projects,
        "assignments": assignments,
        "evaluation_types": evaluation_types,
        "user_departments": USER_DEPARTMENTS,
        "smtp_settings": smtp_settings,
        "smtp_configured": smtp_is_configured(),
        "institution_settings": institution_settings,
        "maintenance_settings": maintenance_settings,
        "logistics_statuses": LOGISTICS_STATUSES,
        "logistics_status_map": {code: label for code, label in LOGISTICS_STATUSES},
    }


def _render(page_template: str, active_page: str):
    return render_template(page_template, **_base_context(active_page))


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
def academic_page():
    return _render("admin/academic.html", "academic")


@admin_required
def rubrics_page():
    return _render("admin/rubrics.html", "rubrics")


@admin_required
def projects_page():
    return _render("admin/projects.html", "projects")


@admin_required
def evaluations_page():
    context = _base_context("evaluations")
    context.update(build_admin_evaluation_overview())
    return render_template("admin/evaluations.html", **context)


@admin_required
def smtp_page():
    return _render("admin/smtp.html", "smtp")


@admin_required
def logs_page():
    q = (request.args.get("q", "") or "").strip()
    action = (request.args.get("action", "") or "").strip()
    entity = (request.args.get("entity", "") or "").strip()

    query = SystemAuditLog.query
    if q:
        like = f"%{q}%"
        query = query.filter(
            (SystemAuditLog.actor_name.ilike(like))
            | (SystemAuditLog.actor_email.ilike(like))
            | (SystemAuditLog.detail.ilike(like))
        )
    if action:
        query = query.filter(SystemAuditLog.action == action)
    if entity:
        query = query.filter(SystemAuditLog.entity == entity)

    logs = query.order_by(SystemAuditLog.created_at.desc()).limit(500).all()
    actions = [row[0] for row in db.session.query(SystemAuditLog.action).distinct().order_by(SystemAuditLog.action.asc()).all()]
    entities = [row[0] for row in db.session.query(SystemAuditLog.entity).distinct().order_by(SystemAuditLog.entity.asc()).all()]

    context = _base_context("logs")
    context.update(
        {
            "logs": logs,
            "audit_actions": actions,
            "audit_entities": entities,
            "filter_q": q,
            "filter_action": action,
            "filter_entity": entity,
        }
    )
    return render_template("admin/logs.html", **context)


@admin_required
def campaigns_page():
    return _render("admin/campaigns.html", "campaigns")


@admin_required
def institution_page():
    return _render("admin/institution.html", "institution")


@admin_required
def maintenance_page():
    return _render("admin/maintenance.html", "maintenance")

import os
import uuid

from flask import current_app, flash, redirect, render_template, request, url_for
from sqlalchemy.orm import joinedload
from werkzeug.utils import secure_filename

from app.extensions import db
from app.models.project import Project
from app.models.project_member import ProjectMember

ALLOWED_IMAGE_EXTENSIONS = {"png", "jpg", "jpeg", "webp", "gif"}


def _build_member_rows(form_data=None):
    if form_data is None:
        return [{"full_name": "", "role": ""} for _ in range(3)]

    names = form_data.getlist("member_name")
    roles = form_data.getlist("member_role")
    rows_count = max(len(names), len(roles), 3)
    rows = []
    for index in range(rows_count):
        rows.append(
            {
                "full_name": names[index].strip() if index < len(names) else "",
                "role": roles[index].strip() if index < len(roles) else "",
            }
        )
    return rows


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


def _normalize_members(member_rows, photo_files):
    normalized = []
    rows_count = max(len(member_rows), len(photo_files))

    for index in range(rows_count):
        row = member_rows[index] if index < len(member_rows) else {"full_name": "", "role": ""}
        photo = photo_files[index] if index < len(photo_files) else None

        full_name = row["full_name"].strip()
        role = row["role"].strip()
        has_photo = photo is not None and bool(photo.filename)

        if not full_name and not role and not has_photo:
            continue
        if not all([full_name, role, has_photo]):
            return None, "Cada integrante debe tener nombre, rol y foto."

        try:
            photo_path = _save_member_photo(photo)
        except ValueError as error:
            return None, str(error)

        normalized.append({"full_name": full_name, "role": role, "photo_url": photo_path})

    if not normalized:
        return None, "Debes registrar al menos un integrante con foto."
    return normalized, None


def list_projects():
    projects = (
        Project.query.options(joinedload(Project.members))
        .order_by(Project.category.asc(), Project.created_at.desc())
        .all()
    )
    projects_by_category = {"steam": [], "emprendimiento": []}
    for project in projects:
        projects_by_category.setdefault(project.category, []).append(project)

    return render_template("public/home_projects.html", projects_by_category=projects_by_category)


def register_project():
    if request.method == "POST":
        member_rows = _build_member_rows(request.form)
        members, members_error = _normalize_members(member_rows, request.files.getlist("member_photo"))

        project = Project(
            title=request.form.get("title", "").strip(),
            team_name=request.form.get("team_name", "").strip(),
            representative_name=request.form.get("representative_name", "").strip(),
            representative_email=request.form.get("representative_email", "").strip().lower(),
            category=request.form.get("category", "").strip(),
            description=request.form.get("description", "").strip(),
        )

        if not all(
            [
                project.title,
                project.team_name,
                project.representative_name,
                project.representative_email,
                project.category,
                project.description,
            ]
        ):
            flash("Todos los campos son obligatorios.", "error")
            return render_template(
                "public/register_project.html", form_data=request.form, member_rows=member_rows
            )

        if project.category not in {"steam", "emprendimiento"}:
            flash("Categoria invalida.", "error")
            return render_template(
                "public/register_project.html", form_data=request.form, member_rows=member_rows
            )

        if members_error:
            flash(members_error, "error")
            return render_template(
                "public/register_project.html", form_data=request.form, member_rows=member_rows
            )

        db.session.add(project)
        db.session.flush()

        for member in members:
            db.session.add(
                ProjectMember(
                    project_id=project.id,
                    full_name=member["full_name"],
                    role=member["role"],
                    photo_url=member["photo_url"],
                )
            )

        db.session.commit()
        flash("Proyecto inscrito correctamente.", "success")
        return redirect(url_for("public.register_project"))

    return render_template("public/register_project.html", form_data={}, member_rows=_build_member_rows())

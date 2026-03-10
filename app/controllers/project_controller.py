from flask import flash, redirect, render_template, request, url_for

from app.extensions import db
from app.models.project import Project


def register_project():
    if request.method == "POST":
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
            return render_template("public/register_project.html")

        if project.category not in {"steam", "emprendimiento"}:
            flash("Categoría inválida.", "error")
            return render_template("public/register_project.html")

        db.session.add(project)
        db.session.commit()
        flash("Proyecto inscrito correctamente.", "success")
        return redirect(url_for("public.register_project"))

    return render_template("public/register_project.html")


from datetime import datetime

from flask import flash, redirect, render_template, request, url_for
from sqlalchemy.orm import joinedload

from app.extensions import db
from app.models.project import Project
from app.models.project_member import ProjectMember
from app.services.parameter_service import get_active_categories

FORM_CATEGORIES = [
    ("contabilidad_finanzas_banca", "Contabilidad, Finanzas, banca"),
    ("disenos", "Disenos"),
    ("energias_renovables", "Energias renovables"),
    ("gestion_de_suministros", "Gestion de suministros"),
    ("hosteleria_turismo", "Hosteleria y servicios turisticos"),
    ("industria_alimenticia", "Industria alimenticia"),
    ("ingenieria_ambiental", "Ingenieria ambiental"),
    ("ingenieria_materiales", "Ingenieria de materiales"),
    ("ingenieria_mecanica", "Ingenieria mecanica"),
    ("mecatronica", "Mecatronica"),
    ("produccion_agricola_pecuaria", "Produccion agricola y pecuaria"),
    ("seguridad_proteccion_laboral", "Seguridad y proteccion laboral"),
    ("servicios_secretariales", "Servicios secretariales"),
    ("ti_informatica", "Tecnologias de la informacion aplicadas a la Informatica"),
]

FORM_REQUIREMENTS = ["corriente", "internet", "agua", "otros"]

FORM_SPECIALTIES = [
    "Administracion, Logistica y Distribucion",
    "Configuracion y Soporte a redes de Comunicacion y Sistemas Operativos",
    "Contabilidad y Finanzas",
    "Dibujo y Modelado de Edificaciones",
    "Ejecutivo Comercial y de Servicio al cliente",
    "Mantenimiento de Sistemas Electricos Industriales",
    "Talleres Exploratorios",
]


def _get_req_values(form_data):
    if hasattr(form_data, "getlist"):
        return form_data.getlist("requirements")
    value = form_data.get("requirements", [])
    if isinstance(value, list):
        return value
    return [value] if value else []


def _render_register_form(form_data):
    return render_template(
        "public/register_project.html",
        form_data=form_data,
        req_values=_get_req_values(form_data),
        form_categories=FORM_CATEGORIES,
        form_specialties=FORM_SPECIALTIES,
    )


def _category_map():
    mapping = {code: label for code, label in FORM_CATEGORIES}
    for category in get_active_categories():
        mapping.setdefault(category.code, category.name)
    return mapping


def _parse_date(raw_value):
    try:
        return datetime.strptime((raw_value or "").strip(), "%Y-%m-%d").date()
    except ValueError:
        return None


def _normalize_gender(prefix: str, form_data):
    base_gender = (form_data.get(f"{prefix}_gender") or "").strip().lower()
    if base_gender != "otros":
        return base_gender
    other = (form_data.get(f"{prefix}_gender_other") or "").strip()
    return other


def _build_student(index: int, form_data):
    prefix = f"student_{index}"
    return {
        "student_number": index,
        "full_name": (form_data.get(f"{prefix}_full_name") or "").strip(),
        "identity_number": (form_data.get(f"{prefix}_identity") or "").strip(),
        "birth_date": _parse_date(form_data.get(f"{prefix}_birth_date")),
        "gender": _normalize_gender(prefix, form_data),
        "specialty": (form_data.get(f"{prefix}_specialty") or "").strip(),
        "section_name": (form_data.get(f"{prefix}_section") or "").strip(),
        "has_dining_scholarship": (form_data.get(f"{prefix}_scholarship") or "").strip().lower() == "si",
        "phone": (form_data.get(f"{prefix}_phone") or "").strip(),
        "email": (form_data.get(f"{prefix}_email") or "").strip().lower(),
    }


def _required_student_numbers(form_data):
    required = [1]
    if (form_data.get("student_1_more") or "").strip().lower() == "si":
        required.append(2)
        if (form_data.get("student_2_more") or "").strip().lower() == "si":
            required.append(3)
    return required


def _validate_students(required_numbers, students):
    students_by_number = {student["student_number"]: student for student in students}

    for number in required_numbers:
        student = students_by_number[number]
        required_fields = [
            student["full_name"],
            student["identity_number"],
            student["birth_date"],
            student["gender"],
            student["specialty"],
            student["phone"],
            student["email"],
        ]
        if number in {1, 3}:
            required_fields.append(student["section_name"])
        if not all(required_fields):
            return f"Completa todos los datos obligatorios del estudiante N.{number}."
    return None


def list_projects():
    projects = (
        Project.query.options(joinedload(Project.members))
        .order_by(Project.created_at.desc())
        .all()
    )

    category_map = _category_map()
    projects_by_category = {code: [] for code, _ in FORM_CATEGORIES}

    for project in projects:
        projects_by_category.setdefault(project.category, []).append(project)
        category_map.setdefault(project.category, project.category)

    return render_template(
        "public/home_projects.html",
        projects_by_category=projects_by_category,
        category_map=category_map,
    )


def register_project():
    if request.method == "POST":
        registration_date = _parse_date(request.form.get("registration_date"))
        category = (request.form.get("category") or "").strip()
        category_codes = {code for code, _ in FORM_CATEGORIES}

        requirements = request.form.getlist("requirements")
        requirements = [item.strip().lower() for item in requirements if item.strip()]
        requirements_other = (request.form.get("requirements_other") or "").strip()

        required_students = _required_student_numbers(request.form)
        students = [_build_student(index, request.form) for index in [1, 2, 3]]

        project = Project(
            registration_date=registration_date,
            title=(request.form.get("title") or "").strip(),
            team_name=(request.form.get("team_name") or "").strip(),
            representative_name=(request.form.get("student_1_full_name") or "").strip(),
            representative_email=(request.form.get("student_1_email") or "").strip().lower(),
            representative_phone=(request.form.get("student_1_phone") or "").strip(),
            institution_name="CTP Roberto Gamboa Valverde",
            grade_level="",
            specialty=(request.form.get("student_1_specialty") or "").strip(),
            advisor_name=(request.form.get("advisor_name") or "").strip(),
            advisor_identity=(request.form.get("advisor_identity") or "").strip(),
            advisor_email=(request.form.get("advisor_email") or "").strip().lower(),
            advisor_phone="",
            category=category,
            description=(request.form.get("description") or "Proyecto registrado mediante ExpoTEC-1.").strip(),
            project_objective="",
            expected_impact="",
            required_resources=(request.form.get("required_resources") or "").strip(),
            requirements_summary=", ".join(requirements),
            requirements_other=requirements_other,
            consent_terms=(request.form.get("declaration") or "").strip().lower() == "si",
        )

        if not registration_date:
            flash("La fecha es obligatoria y debe estar en formato valido.", "error")
            return _render_register_form(request.form)

        if not project.title:
            flash("El nombre del proyecto es obligatorio.", "error")
            return _render_register_form(request.form)

        if category not in category_codes:
            flash("Selecciona una categoria valida.", "error")
            return _render_register_form(request.form)

        if not requirements:
            flash("Debes seleccionar al menos un requerimiento del proyecto.", "error")
            return _render_register_form(request.form)

        if "otros" in requirements and not requirements_other:
            flash("Debes especificar el campo 'Otros' en requerimientos.", "error")
            return _render_register_form(request.form)

        student_error = _validate_students(required_students, students)
        if student_error:
            flash(student_error, "error")
            return _render_register_form(request.form)

        if not all([project.advisor_name, project.advisor_identity, project.advisor_email]):
            flash("Completa los datos del docente tutor.", "error")
            return _render_register_form(request.form)

        if not project.consent_terms:
            flash("Debes aceptar la declaracion para finalizar la inscripcion.", "error")
            return _render_register_form(request.form)

        db.session.add(project)
        db.session.flush()

        for number in required_students:
            student = next(item for item in students if item["student_number"] == number)
            db.session.add(ProjectMember(project_id=project.id, **student))

        db.session.commit()
        flash("Proyecto inscrito correctamente con formato ExpoTEC-1.", "success")
        return redirect(url_for("public.register_project"))

    return _render_register_form({})

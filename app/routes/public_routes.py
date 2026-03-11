from flask import Blueprint

from app.controllers import project_controller

public_bp = Blueprint("public", __name__)


@public_bp.route("/")
def index():
    return project_controller.home_intro()


@public_bp.route("/proyectos")
def projects():
    return project_controller.list_projects()


public_bp.add_url_rule(
    "/inscripcion",
    view_func=project_controller.register_project,
    methods=["GET", "POST"],
)

public_bp.add_url_rule(
    "/proyecto/<int:project_id>/evaluar",
    view_func=project_controller.evaluate_project_entry,
    methods=["GET"],
)

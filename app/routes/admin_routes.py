from flask import Blueprint

from app.controllers import admin_controller

admin_bp = Blueprint("admin", __name__, url_prefix="/admin")

admin_bp.add_url_rule("/action", view_func=admin_controller.perform_action, methods=["POST"])
admin_bp.add_url_rule("/panel", view_func=admin_controller.overview, methods=["GET"])
admin_bp.add_url_rule("/asignaciones", view_func=admin_controller.assignments_page, methods=["GET"])
admin_bp.add_url_rule("/jueces", view_func=admin_controller.judges_page, methods=["GET"])
admin_bp.add_url_rule("/categorias", view_func=admin_controller.categories_page, methods=["GET"])
admin_bp.add_url_rule("/campanas", view_func=admin_controller.campaigns_page, methods=["GET"])
admin_bp.add_url_rule("/academico", view_func=admin_controller.academic_page, methods=["GET"])
admin_bp.add_url_rule("/rubricas", view_func=admin_controller.rubrics_page, methods=["GET"])
admin_bp.add_url_rule("/proyectos", view_func=admin_controller.projects_page, methods=["GET"])
admin_bp.add_url_rule("/smtp", view_func=admin_controller.smtp_page, methods=["GET"])
admin_bp.add_url_rule("/institucion", view_func=admin_controller.institution_page, methods=["GET"])
admin_bp.add_url_rule("/mantenimiento", view_func=admin_controller.maintenance_page, methods=["GET"])
admin_bp.add_url_rule("/bitacora", view_func=admin_controller.logs_page, methods=["GET"])

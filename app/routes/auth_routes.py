from flask import Blueprint

from app.controllers import auth_controller

auth_bp = Blueprint("auth", __name__, url_prefix="/auth")

auth_bp.add_url_rule("/login", view_func=auth_controller.login, methods=["GET", "POST"])
auth_bp.add_url_rule("/logout", view_func=auth_controller.logout, methods=["POST"])


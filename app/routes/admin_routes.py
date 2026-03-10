from flask import Blueprint

from app.controllers import admin_controller

admin_bp = Blueprint("admin", __name__, url_prefix="/admin")

admin_bp.add_url_rule("/panel", view_func=admin_controller.dashboard, methods=["GET", "POST"])


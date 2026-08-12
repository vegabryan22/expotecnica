from flask import abort, flash, redirect, render_template, request, session, url_for
from flask_login import current_user, login_required, login_user, logout_user

from app.extensions import db
from app.models.judge import Judge
from app.services.audit_service import log_event


def _safe_next_url():
    next_url = (request.args.get("next") or request.form.get("next") or "").strip()
    if next_url.startswith("/"):
        return next_url
    return ""


def _role_home(user):
    if user.effective_role == Judge.ROLE_USHER_LOGISTICS:
        return url_for("admin.usher_logistics_page")
    if user.has_admin_access:
        return url_for("admin.overview")
    if user.effective_role == Judge.ROLE_CERTIFICATE_OPERATOR:
        return url_for("certificates.dashboard")
    return url_for("judge.dashboard")


def login():
    if current_user.is_authenticated:
        next_url = _safe_next_url()
        if next_url:
            return redirect(next_url)
        return redirect(_role_home(current_user))

    if request.method == "POST":
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")

        judge = Judge.query.filter_by(email=email).first()
        if not judge or not judge.check_password(password):
            log_event("auth.login.failed", "auth", detail=f"Intento fallido para correo: {email}")
            db.session.commit()
            flash("Credenciales invalidas.", "error")
            return render_template("auth/login.html")
        if not judge.is_active_user:
            log_event("auth.login.blocked", "auth", entity_id=judge.id, detail="Intento de acceso con usuario inactivo")
            db.session.commit()
            flash("Tu usuario esta inactivo.", "error")
            return render_template("auth/login.html", next_url=_safe_next_url())

        login_user(judge)
        judge.mark_login()
        log_event("auth.login", "auth", entity_id=judge.id, detail="Inicio de sesion correcto")
        db.session.commit()
        if judge.must_change_password:
            flash("Debes cambiar tu contrasena antes de continuar.", "error")
            return redirect(url_for("auth.change_password"))
        next_url = _safe_next_url()
        if next_url:
            return redirect(next_url)
        return redirect(_role_home(judge))

    return render_template("auth/login.html", next_url=_safe_next_url())


@login_required
def change_password():
    if session.get("impersonator_user_id"):
        flash("No se puede cambiar la contraseña durante una sesión de soporte.", "error")
        return redirect(_role_home(current_user))
    if request.method == "POST":
        current_password = request.form.get("current_password", "")
        new_password = request.form.get("new_password", "")
        confirm_password = request.form.get("confirm_password", "")

        if not current_user.check_password(current_password):
            flash("La contrasena actual no es correcta.", "error")
        elif len(new_password) < 8:
            flash("La nueva contrasena debe tener al menos 8 caracteres.", "error")
        elif new_password != confirm_password:
            flash("La confirmacion de contrasena no coincide.", "error")
        else:
            current_user.set_password(new_password)
            current_user.must_change_password = False
            log_event("auth.password.change", "auth", entity_id=current_user.id, detail="Cambio manual de contrasena")
            db.session.commit()
            flash("Contrasena actualizada.", "success")
            return redirect(_role_home(current_user))

    return render_template("auth/change_password.html")


@login_required
def stop_impersonation():
    support_user_id = session.get("impersonator_user_id")
    target_user_id = session.get("impersonated_user_id") or current_user.id
    if not support_user_id:
        abort(404)

    support_user = Judge.query.get(support_user_id)
    if not support_user or not support_user.is_active_user or not support_user.is_superadmin:
        logout_user()
        session.clear()
        flash("La cuenta de soporte ya no está disponible. Inicia sesión nuevamente.", "error")
        return redirect(url_for("auth.login"))

    target_name = current_user.full_name or current_user.email
    login_user(support_user, remember=False, fresh=True)
    for key in (
        "impersonator_user_id",
        "impersonator_name",
        "impersonator_email",
        "impersonated_user_id",
        "impersonation_started_at",
    ):
        session.pop(key, None)
    log_event(
        "admin.user.impersonation.stop",
        "judge",
        entity_id=target_user_id,
        detail=f"Modo soporte finalizado para {target_name}",
    )
    db.session.commit()
    flash("Regresaste a tu cuenta de superadministrador.", "success")
    return redirect(url_for("admin.judges_page"))


def logout():
    if current_user.is_authenticated:
        log_event("auth.logout", "auth", entity_id=current_user.id, detail="Cierre de sesion")
        db.session.commit()
    logout_user()
    for key in (
        "impersonator_user_id",
        "impersonator_name",
        "impersonator_email",
        "impersonated_user_id",
        "impersonation_started_at",
    ):
        session.pop(key, None)
    flash("Sesion cerrada.", "success")
    return redirect(url_for("auth.login"))

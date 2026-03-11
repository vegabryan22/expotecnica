from flask import flash, redirect, render_template, request, url_for
from flask_login import current_user, login_user, logout_user

from app.extensions import db
from app.models.judge import Judge
from app.services.audit_service import log_event


def _safe_next_url():
    next_url = (request.args.get("next") or request.form.get("next") or "").strip()
    if next_url.startswith("/"):
        return next_url
    return ""


def login():
    if current_user.is_authenticated:
        next_url = _safe_next_url()
        if next_url:
            return redirect(next_url)
        if current_user.is_admin:
            return redirect(url_for("admin.overview"))
        return redirect(url_for("judge.dashboard"))

    if request.method == "POST":
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")

        judge = Judge.query.filter_by(email=email).first()
        if not judge or not judge.check_password(password):
            log_event("auth.login_failed", "auth", detail=f"Intento fallido para correo: {email}")
            db.session.commit()
            flash("Credenciales invalidas.", "error")
            return render_template("auth/login.html")

        login_user(judge)
        log_event("auth.login", "auth", entity_id=judge.id, detail="Inicio de sesion correcto")
        db.session.commit()
        next_url = _safe_next_url()
        if next_url:
            return redirect(next_url)
        if judge.is_admin:
            return redirect(url_for("admin.overview"))
        return redirect(url_for("judge.dashboard"))

    return render_template("auth/login.html", next_url=_safe_next_url())


def logout():
    if current_user.is_authenticated:
        log_event("auth.logout", "auth", entity_id=current_user.id, detail="Cierre de sesion")
        db.session.commit()
    logout_user()
    flash("Sesion cerrada.", "success")
    return redirect(url_for("auth.login"))

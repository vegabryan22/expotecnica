from flask import flash, redirect, render_template, request, url_for
from flask_login import current_user, login_user, logout_user

from app.models.judge import Judge


def login():
    if current_user.is_authenticated:
        if current_user.is_admin:
            return redirect(url_for("admin.overview"))
        return redirect(url_for("judge.dashboard"))

    if request.method == "POST":
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")

        judge = Judge.query.filter_by(email=email).first()
        if not judge or not judge.check_password(password):
            flash("Credenciales inválidas.", "error")
            return render_template("auth/login.html")

        login_user(judge)
        if judge.is_admin:
            return redirect(url_for("admin.overview"))
        return redirect(url_for("judge.dashboard"))

    return render_template("auth/login.html")


def logout():
    logout_user()
    flash("Sesión cerrada.", "success")
    return redirect(url_for("auth.login"))

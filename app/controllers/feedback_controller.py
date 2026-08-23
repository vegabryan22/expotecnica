from flask import abort, flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required
from sqlalchemy import func

from app.extensions import db
from app.models.judge import Judge
from app.models.judge_feedback import JudgeFeedback
from app.models.normalized_schema import JudgeEventParticipation


QUESTIONS = (
    ("organization_score", "Organización previa", "Claridad de la información, convocatoria y coordinación antes del evento."),
    ("attention_score", "Atención recibida", "Trato, orientación y respuesta del personal organizador."),
    ("ushers_score", "Apoyo de edecanes", "Acompañamiento, ubicación y disponibilidad durante la Expo."),
    ("projects_score", "Proyectos presentados", "Calidad, preparación, diversidad e innovación de los proyectos."),
    ("overall_score", "Experiencia general", "Valoración integral de su participación como juez."),
)


def _judge_from_token(token):
    if not token:
        return None
    return Judge.query.filter_by(attendance_token=token, role=Judge.ROLE_JUDGE).first()


def _participation_from_token(token):
    if not token:
        return None
    return JudgeEventParticipation.query.filter_by(attendance_token=token).first()


def public_feedback(token=None):
    participation = _participation_from_token(token)
    judge = Judge.query.get(participation.judge_id) if participation else _judge_from_token(token)
    if not token:
        if current_user.is_authenticated and current_user.effective_role == Judge.ROLE_JUDGE:
            judge = current_user
        else:
            flash("Ingrese con su cuenta de juez o utilice su enlace personal para responder.", "error")
            return redirect(url_for("auth.login", next=request.path))
    if token and not judge:
        abort(404)
    existing = (
        JudgeFeedback.query.filter_by(participation_id=participation.id).first()
        if participation else (JudgeFeedback.query.filter_by(judge_id=judge.id).first() if judge else None)
    )
    if existing and not existing.is_open_for_edit:
        return render_template("public/judge_feedback_thanks.html", already_sent=True)

    if request.method == "POST":
        scores = {}
        errors = []
        for field, label, _description in QUESTIONS:
            try:
                score = int(request.form.get(field, ""))
            except (TypeError, ValueError):
                score = 0
            if score not in range(1, 6):
                errors.append(label)
            scores[field] = score
        had_breakfast = request.form.get("had_breakfast") == "1"
        stayed_for_lunch = request.form.get("stayed_for_lunch") == "1"
        try:
            breakfast_score = int(request.form.get("breakfast_score", "")) if had_breakfast else None
        except (TypeError, ValueError):
            breakfast_score = None
        try:
            lunch_score = int(request.form.get("lunch_score", "")) if stayed_for_lunch else None
        except (TypeError, ValueError):
            lunch_score = None
        if had_breakfast and breakfast_score not in range(1, 6):
            errors.append("Calificación del desayuno")
        if stayed_for_lunch and lunch_score not in range(1, 6):
            errors.append("Calificación del almuerzo")
        if errors:
            flash("Califique todos los aspectos antes de enviar.", "error")
        else:
            feedback = existing or JudgeFeedback(judge_id=judge.id, participation_id=participation.id if participation else None)
            feedback.respondent_name = judge.full_name
            feedback.best_aspect = request.form.get("best_aspect", "").strip()[:4000] or None
            feedback.improvement_opportunity = request.form.get("improvement_opportunity", "").strip()[:4000] or None
            feedback.additional_comments = request.form.get("additional_comments", "").strip()[:4000] or None
            feedback.would_participate_again = request.form.get("would_participate_again") == "1"
            feedback.had_breakfast = had_breakfast
            feedback.breakfast_score = breakfast_score
            feedback.breakfast_opinion = (request.form.get("breakfast_opinion", "").strip()[:4000] or None) if had_breakfast else None
            feedback.stayed_for_lunch = stayed_for_lunch
            feedback.lunch_score = lunch_score
            feedback.lunch_opinion = (request.form.get("lunch_opinion", "").strip()[:4000] or None) if stayed_for_lunch else None
            feedback.food_score = round(sum(score for score in (breakfast_score, lunch_score) if score) / max(1, sum(1 for score in (breakfast_score, lunch_score) if score)))
            feedback.is_open_for_edit = False
            for field, score in scores.items():
                setattr(feedback, field, score)
            if not existing:
                db.session.add(feedback)
            db.session.commit()
            return redirect(url_for("public.judge_feedback_thanks"))

    return render_template("public/judge_feedback.html", questions=QUESTIONS, judge=judge, existing=existing)


def feedback_thanks():
    return render_template("public/judge_feedback_thanks.html", already_sent=False)


@login_required
def feedback_report():
    if not current_user.has_admin_access:
        abort(403)
    responses = JudgeFeedback.query.order_by(JudgeFeedback.created_at.desc()).all()
    score_definitions = list(QUESTIONS) + [
        ("breakfast_score", "Desayuno", "Calidad del desayuno entre quienes utilizaron el servicio."),
        ("lunch_score", "Almuerzo", "Calidad del almuerzo entre quienes permanecieron al servicio."),
    ]
    score_statistics = []
    averages = {}
    for field, label, description in score_definitions:
        values = [getattr(item, field) for item in responses if getattr(item, field) is not None]
        average = round(sum(values) / len(values), 2) if values else 0
        averages[field] = average
        distribution = []
        for score in range(1, 6):
            count = values.count(score)
            distribution.append({
                "score": score,
                "count": count,
                "percentage": round((count / len(values)) * 100, 1) if values else 0,
            })
        score_statistics.append({
            "field": field,
            "label": label,
            "description": description,
            "average": average,
            "percentage": round(average * 20, 1),
            "responses": len(values),
            "distribution": distribution,
        })
    willing_count = sum(1 for item in responses if item.would_participate_again)
    unwilling_count = len(responses) - willing_count
    response_count = len(responses)
    breakfast_count = sum(1 for item in responses if item.had_breakfast)
    lunch_count = sum(1 for item in responses if item.stayed_for_lunch)
    return render_template(
        "admin/judge_feedback.html",
        responses=responses,
        averages=averages,
        score_statistics=score_statistics,
        questions=QUESTIONS,
        willing_count=willing_count,
        unwilling_count=unwilling_count,
        willing_percentage=round((willing_count / len(responses)) * 100, 1) if responses else 0,
        breakfast_count=breakfast_count,
        breakfast_percentage=round((breakfast_count / response_count) * 100, 1) if response_count else 0,
        lunch_count=lunch_count,
        lunch_percentage=round((lunch_count / response_count) * 100, 1) if response_count else 0,
    )


@login_required
def reopen_feedback(feedback_id):
    if not current_user.has_admin_access:
        abort(403)
    feedback = db.session.get(JudgeFeedback, feedback_id)
    if not feedback or not feedback.judge:
        abort(404)
    feedback.is_open_for_edit = True
    db.session.commit()
    flash(f"Encuesta de {feedback.judge.full_name} reabierta. Puede reenviar su enlace personal.", "success")
    return redirect(url_for("admin.feedback_report"))

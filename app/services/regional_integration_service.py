import json
import os
from datetime import datetime
from urllib.parse import urlparse

import requests
from flask import current_app

from app.extensions import db
from app.models.regional_submission import RegionalSubmission
from app.models.system_setting import SystemSetting


class RegionalIntegrationError(RuntimeError):
    pass


def integration_settings():
    return {
        "base_url": (SystemSetting.get_value("regional_api_base_url", "http://127.0.0.1:5001/api/v1") or "").strip().rstrip("/"),
        "token": (SystemSetting.get_value("regional_api_token", "") or "").strip(),
        "institution_code": (SystemSetting.get_value("regional_institution_code", "") or "").strip().upper(),
    }


def validate_settings(settings: dict):
    parsed = urlparse(settings["base_url"])
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        raise RegionalIntegrationError("La URL de la API regional no es válida.")
    if not settings["token"]:
        raise RegionalIntegrationError("Falta la credencial API regional.")
    if not settings["institution_code"]:
        raise RegionalIntegrationError("Falta el código regional del colegio.")


def _submission_for(project, institution_code: str):
    submission = RegionalSubmission.query.filter_by(project_id=project.id).first()
    if submission is None:
        submission = RegionalSubmission(
            project_id=project.id,
            external_project_id=f"{institution_code}-{project.id:06d}",
            status="pending",
        )
        db.session.add(submission)
        db.session.flush()
    return submission


def _project_payload(project, submission):
    return {
        "external_project_id": submission.external_project_id,
        "external_source": "ExpoTécnica institucional",
        "payload_version": "1.0",
        "title": project.title,
        "team_name": project.team_name,
        "category_code": project.category,
        "description": project.description,
        "tutor": {
            "name": project.advisor_name,
            "email": project.advisor_email,
            "phone": project.advisor_phone,
        },
        "students": [
            {
                "name": member.full_name,
                "identity_number": member.identity_number,
                "email": member.email,
                "phone": member.phone,
                "section": member.section_name,
                "specialty": member.specialty,
            }
            for member in sorted(project.members, key=lambda row: row.student_number)
        ],
        "institutional_result": {"winner": True, "selected_at": datetime.utcnow().isoformat() + "Z"},
    }


def _headers(token: str, external_id: str):
    return {"Authorization": f"Bearer {token}", "Idempotency-Key": external_id, "Accept": "application/json"}


def send_project_to_regional(project):
    settings = integration_settings()
    validate_settings(settings)
    submission = _submission_for(project, settings["institution_code"])
    submission.attempts += 1
    submission.last_attempt_at = datetime.utcnow()
    try:
        response = requests.post(
            f"{settings['base_url']}/regional-projects",
            json=_project_payload(project, submission),
            headers=_headers(settings["token"], submission.external_project_id),
            timeout=20,
        )
        submission.last_http_status = response.status_code
        response_payload = response.json()
        submission.last_response_json = json.dumps(response_payload, ensure_ascii=False)
        if response.status_code not in {200, 201} or not response_payload.get("ok"):
            message = response_payload.get("error", {}).get("message") or f"Respuesta HTTP {response.status_code}"
            raise RegionalIntegrationError(message)

        submission.regional_project_id = response_payload.get("regional_project_id")
        submission.regional_status = response_payload.get("regional_status")
        submission.status = "sent"
        submission.sent_at = datetime.utcnow()
        submission.last_error = None
        _send_files(project, submission, settings)
        db.session.commit()
        return submission
    except (requests.RequestException, ValueError, RegionalIntegrationError) as error:
        submission.status = "error"
        submission.last_error = str(error)[:2000]
        db.session.commit()
        raise RegionalIntegrationError(str(error)) from error


def _send_files(project, submission, settings):
    candidates = {
        "project_document": project.project_document_path,
        "project_logo": project.project_logo_path if project.has_real_logo else None,
    }
    open_files = []
    files = {}
    try:
        for field, relative_path in candidates.items():
            if not relative_path or relative_path.startswith(("http://", "https://")):
                continue
            absolute_path = os.path.join(current_app.static_folder, relative_path.replace("/", os.sep))
            if not os.path.isfile(absolute_path):
                continue
            handle = open(absolute_path, "rb")
            open_files.append(handle)
            files[field] = (os.path.basename(absolute_path), handle)
        if not files:
            return
        response = requests.post(
            f"{settings['base_url']}/regional-projects/{submission.external_project_id}/files",
            files=files,
            headers=_headers(settings["token"], f"{submission.external_project_id}-files"),
            timeout=60,
        )
        if response.status_code != 200:
            try:
                message = response.json().get("error", {}).get("message")
            except ValueError:
                message = None
            raise RegionalIntegrationError(message or f"Los datos llegaron, pero falló el envío de archivos (HTTP {response.status_code}).")
    finally:
        for handle in open_files:
            handle.close()


def refresh_regional_status(submission):
    settings = integration_settings()
    validate_settings(settings)
    response = requests.get(
        f"{settings['base_url']}/regional-projects/{submission.external_project_id}/status",
        headers=_headers(settings["token"], f"{submission.external_project_id}-status"),
        timeout=20,
    )
    payload = response.json()
    if response.status_code != 200 or not payload.get("ok"):
        raise RegionalIntegrationError(payload.get("error", {}).get("message") or f"Respuesta HTTP {response.status_code}")
    submission.regional_status = payload.get("regional_status")
    submission.last_response_json = json.dumps(payload, ensure_ascii=False)
    submission.last_http_status = response.status_code
    submission.last_error = None
    db.session.commit()
    return submission

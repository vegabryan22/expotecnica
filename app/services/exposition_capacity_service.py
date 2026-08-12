from collections import Counter

from sqlalchemy.orm import joinedload

from app.extensions import db
from app.models.assignment import Assignment
from app.models.judge import Judge
from app.models.project import Project
from app.services.evaluation_service import (
    ENGLISH_EVAL_TYPE_CODE,
    get_assignment_evaluation_entries,
    infer_evaluation_type_kind,
)


EXPOSITIONS_PER_JUDGE = 3


def _can_receive(judge: Judge, project: Project) -> bool:
    return bool(
        judge
        and judge.is_active_user
        and judge.effective_role == Judge.ROLE_JUDGE
        and judge.can_evaluate_exposition
        and judge.attendance_confirmed is not False
        and judge.can_evaluate_category(project.category)
    )


def _data():
    assignments = (
        Assignment.query.options(joinedload(Assignment.judge), joinedload(Assignment.project))
        .join(Project, Project.id == Assignment.project_id)
        .filter(
            Project.is_active.is_(True),
            Assignment.status == Assignment.STATUS_CONFIRMED,
            Assignment.can_evaluate_exposition.is_(True),
        )
        .order_by(Project.title.asc(), Assignment.id.asc())
        .all()
    )
    judges = (
        Judge.query.filter(
            Judge.role == Judge.ROLE_JUDGE,
            Judge.is_active_user.is_(True),
            Judge.can_evaluate_exposition.is_(True),
            Judge.attendance_confirmed.is_not(False),
        )
        .order_by(Judge.full_name.asc())
        .all()
    )
    loads = Counter(assignment.judge_id for assignment in assignments)
    return assignments, judges, loads


def build_exposition_capacity_plan(selected_ids=None, limit=None, requested_incoming=None):
    assignments, judges, current_loads = _data()
    project_count = Project.query.filter(Project.is_active.is_(True)).count()
    limit = project_count
    judges_by_id = {judge.id: judge for judge in judges}
    assigned_ids = {assignment.judge_id for assignment in assignments}

    ranked = sorted(
        judges,
        key=lambda judge: (
            0 if judge.attendance_confirmed is True else 1,
            0 if judge.id in assigned_ids else 1,
            0 if not judge.can_evaluate_documentation else 1,
            current_loads[judge.id],
            judge.full_name.lower(),
        ),
    )
    if selected_ids is None:
        selected = {judge.id for judge in ranked[:limit]}
    else:
        selected = {int(value) for value in selected_ids if str(value).isdigit() and int(value) in judges_by_id}
    requested_incoming = {}
    projected = Counter(current_loads)
    moves = []
    unresolved = []
    existing_expo = {(assignment.judge_id, assignment.project_id) for assignment in assignments}
    sources = sorted(
        assignments,
        key=lambda assignment: (
            0 if assignment.judge_id not in selected else 1,
            -current_loads[assignment.judge_id],
            assignment.project.title.lower(),
        ),
    )
    for assignment in sources:
        if assignment.judge_id in selected and projected[assignment.judge_id] <= EXPOSITIONS_PER_JUDGE:
            continue
        eligible = [
            judge for judge in judges
            if judge.id in selected
            and projected[judge.id] < EXPOSITIONS_PER_JUDGE
            and (judge.id, assignment.project_id) not in existing_expo
            and _can_receive(judge, assignment.project)
        ]
        eligible.sort(
            key=lambda judge: (
                projected[judge.id],
                0 if not judge.can_evaluate_documentation else 1,
                judge.full_name.lower(),
            )
        )
        if not eligible:
            unresolved.append({
                "assignment_id": assignment.id,
                "project": assignment.project.title,
                "source": assignment.judge.full_name,
                "reason": "No hay un juez presencial compatible que no evalúe ya este proyecto.",
            })
            continue
        target = eligible[0]
        moves.append({
            "assignment_id": assignment.id,
            "project_id": assignment.project_id,
            "project": assignment.project.title,
            "source_id": assignment.judge_id,
            "source": assignment.judge.full_name,
            "target_id": target.id,
            "targets": [
                {"id": judge.id, "name": judge.full_name, "load": projected[judge.id]}
                for judge in eligible
            ],
        })
        projected[assignment.judge_id] -= 1
        projected[target.id] += 1
        existing_expo.add((target.id, assignment.project_id))

    expected_slots = project_count * EXPOSITIONS_PER_JUDGE
    project_loads = Counter(assignment.project_id for assignment in assignments)
    if len(assignments) != expected_slots:
        unresolved.append({
            "assignment_id": None,
            "project": "Cobertura general",
            "source": "Asignaciones regulares",
            "reason": f"Deben existir {expected_slots} asignaciones (3 por cada uno de los {project_count} proyectos) y actualmente hay {len(assignments)}.",
        })
    for project in Project.query.filter(Project.is_active.is_(True)).order_by(Project.title.asc()).all():
        if project_loads[project.id] != EXPOSITIONS_PER_JUDGE:
            unresolved.append({
                "assignment_id": None,
                "project": project.title,
                "source": "Cobertura del proyecto",
                "reason": f"Tiene {project_loads[project.id]} jueces regulares; debe tener exactamente 3.",
            })
    for judge_id in selected:
        if projected[judge_id] != EXPOSITIONS_PER_JUDGE:
            unresolved.append({
                "assignment_id": None,
                "project": judges_by_id[judge_id].full_name,
                "source": "Carga proyectada",
                "reason": f"Queda con {projected[judge_id]} exposiciones regulares; debe quedar exactamente con 3.",
            })
    moves_required = len(moves)

    all_assignments = (
        Assignment.query.options(
            joinedload(Assignment.project).joinedload(Project.members),
            joinedload(Assignment.project).joinedload(Project.evaluations),
        )
        .join(Project, Project.id == Assignment.project_id)
        .filter(Project.is_active.is_(True), Assignment.status == Assignment.STATUS_CONFIRMED)
        .order_by(Project.title.asc())
        .all()
    )
    assignments_by_judge = {}
    for assignment in all_assignments:
        assignments_by_judge.setdefault(assignment.judge_id, []).append(assignment)

    incoming_by_judge = {}
    outgoing_by_judge = {}
    for move in moves:
        incoming_by_judge.setdefault(move["target_id"], []).append(move["project"])
        outgoing_by_judge.setdefault(move["source_id"], []).append(move["project"])

    judge_rows = []
    for judge in judges:
        assignment_rows = []
        total_expected = 0
        total_completed = 0
        for assignment in assignments_by_judge.get(judge.id, []):
            entries = get_assignment_evaluation_entries(assignment)
            statuses = []
            for entry in entries:
                completed = any(
                    evaluation.judge_id == judge.id
                    and evaluation.evaluation_type == entry["code"]
                    and (evaluation.project_member_id or None) == (entry.get("project_member_id") or None)
                    and evaluation.percentage is not None
                    for evaluation in assignment.project.evaluations
                )
                if entry["code"] == ENGLISH_EVAL_TYPE_CODE:
                    kind = "Inglés"
                else:
                    inferred = infer_evaluation_type_kind(entry.get("type"))
                    kind = "Documento" if inferred == "documentacion" else ("Exposición" if inferred == "exposicion" else entry["short_name"])
                statuses.append({"label": entry["label"], "kind": kind, "completed": completed})
                total_expected += 1
                total_completed += int(completed)
            assignment_rows.append({
                "project": assignment.project.title,
                "category": assignment.project.category,
                "requires_english": assignment.project.requires_english_evaluation,
                "scope": assignment.scope_label,
                "document": assignment.can_evaluate_documentation,
                "exposition": assignment.can_evaluate_exposition,
                "statuses": statuses,
                "pending": sum(not item["completed"] for item in statuses),
                "completed": sum(item["completed"] for item in statuses),
            })
        pending_total = total_expected - total_completed
        judge_rows.append({
            "id": judge.id,
            "name": judge.full_name,
            "attendance": judge.attendance_status_label,
            "attendance_tag": judge.attendance_status_tag,
            "scope": judge.evaluation_scope_label,
            "can_documentation": judge.can_evaluate_documentation,
            "can_exposition": judge.can_evaluate_exposition,
            "can_english": judge.can_evaluate_english,
            "category_scope": judge.category_scope_label,
            "expo_only": not judge.can_evaluate_documentation,
            "current_load": current_loads[judge.id],
            "projected_load": projected[judge.id] if judge.id in selected else 0,
            "selected": judge.id in selected,
            "currently_assigned": judge.id in assigned_ids,
            "assignments": assignment_rows,
            "expected_total": total_expected,
            "completed_total": total_completed,
            "pending_total": pending_total,
            "incoming": incoming_by_judge.get(judge.id, []),
            "requested_incoming": requested_incoming.get(judge.id, len(incoming_by_judge.get(judge.id, []))),
            "outgoing": outgoing_by_judge.get(judge.id, []),
        })
    judge_rows.sort(key=lambda row: (not row["selected"], row["projected_load"], row["name"].lower()))
    return {
        "limit": limit,
        "project_count": project_count,
        "expositions_per_judge": EXPOSITIONS_PER_JUDGE,
        "expected_regular_slots": expected_slots,
        "current_regular_slots": len(assignments),
        "current_judges": len(assigned_ids),
        "selected_ids": selected,
        "selected_count": len(selected),
        "judges": judge_rows,
        "moves": moves,
        "unresolved": unresolved,
        "current_loads": current_loads,
        "projected_loads": projected,
        "requested_incoming": requested_incoming,
        "moves_required": moves_required,
    }


def apply_exposition_capacity_plan(selected_ids, target_by_assignment, limit=None, requested_incoming=None):
    plan = build_exposition_capacity_plan(selected_ids)
    limit = plan["limit"]
    if plan["selected_count"] != limit:
        raise ValueError(f"Debe seleccionar exactamente {limit} jueces presenciales.")
    if plan["unresolved"]:
        raise ValueError("El borrador tiene exposiciones sin reasignar.")

    moves_by_id = {move["assignment_id"]: move for move in plan["moves"]}
    final_loads = Counter(plan["current_loads"])
    chosen_targets = {}
    for assignment_id, move in moves_by_id.items():
        target_id = int(target_by_assignment.get(assignment_id, move["target_id"]))
        eligible_ids = {target["id"] for target in move["targets"]}
        if target_id not in eligible_ids:
            raise ValueError(f"El destino elegido para {move['project']} ya no es válido.")
        chosen_targets[assignment_id] = target_id
        final_loads[move["source_id"]] -= 1
        final_loads[target_id] += 1
    if any(final_loads[judge_id] != EXPOSITIONS_PER_JUDGE for judge_id in plan["selected_ids"]):
        raise ValueError("La selección manual de destinos debe dejar exactamente 3 exposiciones regulares por juez.")

    applied = []
    for assignment_id, move in moves_by_id.items():
        target_id = chosen_targets[assignment_id]
        eligible_ids = {target["id"] for target in move["targets"]}
        if target_id not in eligible_ids:
            raise ValueError(f"El destino elegido para {move['project']} ya no es válido.")
        source = db.session.get(Assignment, assignment_id)
        if not source or not source.can_evaluate_exposition or source.judge_id in plan["selected_ids"]:
            raise ValueError("Las asignaciones cambiaron; regenere el borrador antes de aplicarlo.")
        target = Assignment.query.filter_by(judge_id=target_id, project_id=source.project_id).first()
        if target:
            if target.can_evaluate_exposition:
                raise ValueError(f"El juez de destino ya evalúa la exposición de {move['project']}.")
            target.can_evaluate_exposition = True
            target.status = Assignment.STATUS_CONFIRMED
            target.notification_sent_at = None
            target.notification_error = None
        else:
            target = Assignment(
                judge_id=target_id,
                project_id=source.project_id,
                can_evaluate_documentation=False,
                can_evaluate_exposition=True,
                status=Assignment.STATUS_CONFIRMED,
            )
            db.session.add(target)
        source.can_evaluate_exposition = False
        source.notification_sent_at = None
        source.notification_error = None
        if not source.can_evaluate_documentation:
            db.session.delete(source)
        target_name = next(item["name"] for item in move["targets"] if item["id"] == target_id)
        applied.append((move["source"], target_name, move["project"]))
    return applied

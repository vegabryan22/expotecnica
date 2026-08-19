from io import BytesIO
from pathlib import Path
from copy import deepcopy
from math import ceil
import re
from xml.etree import ElementTree as ET
from zipfile import ZIP_DEFLATED, ZipFile

from flask import current_app
from sqlalchemy.orm import joinedload

from app.models.project import Project
from app.models.specialty import Specialty
from app.models.system_setting import SystemSetting
from app.services.specialty_service import canonical_specialty_name


TEMPLATE_FILENAME = "matriz_registro_expotecnica_institucional.xlsx"
TARGET_SHEET_NAME = "Datos fase institucional"
FIRST_PROJECT_ROW = 13
LAST_TEMPLATE_PROJECT_ROW = 42
PROJECT_COLUMN_CAPACITIES = (42, 33, 30, 27, 45, 17, 35, 36, 35, 18)
STUDENT_NAME_COLUMN_WIDTH = 50
BIRTH_DATE_COLUMN_WIDTH = 20

MAIN_NS = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
DOC_REL_NS = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
PKG_REL_NS = "http://schemas.openxmlformats.org/package/2006/relationships"
XML_NS = "http://www.w3.org/XML/1998/namespace"
NS = {"m": MAIN_NS, "r": DOC_REL_NS, "pr": PKG_REL_NS}
ET.register_namespace("", MAIN_NS)
ET.register_namespace("r", DOC_REL_NS)
ET.register_namespace("mc", "http://schemas.openxmlformats.org/markup-compatibility/2006")
ET.register_namespace("x14ac", "http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac")
ET.register_namespace("xr", "http://schemas.microsoft.com/office/spreadsheetml/2014/revision")
ET.register_namespace("xr2", "http://schemas.microsoft.com/office/spreadsheetml/2015/revision2")
ET.register_namespace("xr3", "http://schemas.microsoft.com/office/spreadsheetml/2016/revision3")
ET.register_namespace("x14", "http://schemas.microsoft.com/office/spreadsheetml/2009/9/main")
ET.register_namespace("xm", "http://schemas.microsoft.com/office/excel/2006/main")


def _template_path() -> Path:
    return Path(current_app.static_folder) / "templates" / TEMPLATE_FILENAME


def _sheet_xml_path(archive: ZipFile, sheet_name: str) -> str:
    workbook = ET.fromstring(archive.read("xl/workbook.xml"))
    sheet = next((item for item in workbook.findall("m:sheets/m:sheet", NS) if item.get("name") == sheet_name), None)
    if sheet is None:
        raise ValueError(f"La plantilla no contiene la hoja '{sheet_name}'.")
    relationship_id = sheet.get(f"{{{DOC_REL_NS}}}id")
    relationships = ET.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
    relationship = next((item for item in relationships.findall("pr:Relationship", NS) if item.get("Id") == relationship_id), None)
    if relationship is None:
        raise ValueError("No se pudo localizar la hoja de datos en la plantilla.")
    target = relationship.get("Target", "")
    return target.lstrip("/") if target.startswith("xl/") else f"xl/{target.lstrip('/')}"


def _column_number(reference: str) -> int:
    letters = re.match(r"[A-Z]+", reference or "")
    value = 0
    for letter in letters.group(0) if letters else "":
        value = value * 26 + ord(letter) - 64
    return value


def _set_inline_text(sheet_root, reference: str, value: str):
    row_number = int(re.search(r"\d+", reference).group(0))
    sheet_data = sheet_root.find("m:sheetData", NS)
    row = next((item for item in sheet_data.findall("m:row", NS) if int(item.get("r")) == row_number), None)
    if row is None:
        row = ET.SubElement(sheet_data, f"{{{MAIN_NS}}}row", {"r": str(row_number)})
    cell = next((item for item in row.findall("m:c", NS) if item.get("r") == reference), None)
    if cell is None:
        cell = ET.Element(f"{{{MAIN_NS}}}c", {"r": reference})
        target_column = _column_number(reference)
        inserted = False
        for index, existing in enumerate(row.findall("m:c", NS)):
            if _column_number(existing.get("r")) > target_column:
                row.insert(index, cell)
                inserted = True
                break
        if not inserted:
            row.append(cell)
    for child in list(cell):
        if child.tag in {f"{{{MAIN_NS}}}v", f"{{{MAIN_NS}}}f", f"{{{MAIN_NS}}}is"}:
            cell.remove(child)
    cell.set("t", "inlineStr")
    inline = ET.SubElement(cell, f"{{{MAIN_NS}}}is")
    text = ET.SubElement(inline, f"{{{MAIN_NS}}}t")
    text.set(f"{{{XML_NS}}}space", "preserve")
    text.text = str(value or "")


def _extend_project_rows(sheet_root, last_row: int):
    """Amplía la tabla copiando íntegramente el formato uniforme de una fila base."""
    if last_row <= LAST_TEMPLATE_PROJECT_ROW:
        return
    sheet_data = sheet_root.find("m:sheetData", NS)
    template_row = next(item for item in sheet_data.findall("m:row", NS) if int(item.get("r")) == 14)
    for row_number in range(LAST_TEMPLATE_PROJECT_ROW + 1, last_row + 1):
        row = deepcopy(template_row)
        row.set("r", str(row_number))
        for cell in row.findall("m:c", NS):
            column = re.match(r"[A-Z]+", cell.get("r", "")).group(0)
            cell.set("r", f"{column}{row_number}")
        sheet_data.append(row)

    dimension = sheet_root.find("m:dimension", NS)
    if dimension is not None:
        dimension.set("ref", f"A1:I{last_row}")

    for validation in sheet_root.findall(".//m:dataValidation", NS):
        sqref = validation.get("sqref", "")
        validation.set("sqref", re.sub(r":([A-Z]+)42\b", rf":\g<1>{last_row}", sqref))

    # Las validaciones modernas guardan sus rangos como texto en xm:sqref.
    xm_namespace = "http://schemas.microsoft.com/office/excel/2006/main"
    for sqref in sheet_root.findall(f".//{{{xm_namespace}}}sqref"):
        sqref.text = re.sub(r":([A-Z]+)42\b", rf":\g<1>{last_row}", sqref.text or "")


def _normalize_project_row_styles(sheet_root, last_row: int):
    """Elimina las variaciones accidentales de formato de las filas 39–42."""
    sheet_data = sheet_root.find("m:sheetData", NS)
    base_row = next(item for item in sheet_data.findall("m:row", NS) if int(item.get("r")) == 14)
    base_styles = {
        re.match(r"[A-Z]+", cell.get("r", "")).group(0): cell.get("s") for cell in base_row.findall("m:c", NS)
    }
    # Tutor y carrera del tutor deben comportarse como las demás columnas
    # descriptivas: centradas verticalmente, en negrita y con ajuste de texto.
    base_styles["H"] = base_styles["G"]
    base_styles["I"] = base_styles["G"]
    for row in sheet_data.findall("m:row", NS):
        row_number = int(row.get("r"))
        if not FIRST_PROJECT_ROW <= row_number <= last_row:
            continue
        for cell in row.findall("m:c", NS):
            column = re.match(r"[A-Z]+", cell.get("r", "")).group(0)
            if column in base_styles:
                cell.set("s", base_styles[column])


def _set_student_name_column_width(sheet_root):
    columns = sheet_root.find("m:cols", NS)
    if columns is None:
        return
    student_name_column = next(
        (column for column in columns.findall("m:col", NS) if column.get("min") == "5" and column.get("max") == "5"),
        None,
    )
    if student_name_column is not None:
        student_name_column.set("width", str(STUDENT_NAME_COLUMN_WIDTH))
        student_name_column.set("customWidth", "1")


def _ensure_birth_date_column(sheet_root, last_row: int):
    """Agrega la columna J conservando el formato oficial de la matriz."""
    columns = sheet_root.find("m:cols", NS)
    if columns is not None:
        trailing_column = next(
            (
                column
                for column in columns.findall("m:col", NS)
                if int(column.get("min", "0")) <= 10 <= int(column.get("max", "0"))
            ),
            None,
        )
        if trailing_column is not None and trailing_column.get("min") == "10":
            trailing_column.set("min", "11")
        birth_column = ET.Element(
            f"{{{MAIN_NS}}}col",
            {
                "min": "10",
                "max": "10",
                "width": str(BIRTH_DATE_COLUMN_WIDTH),
                "style": "3",
                "customWidth": "1",
            },
        )
        insertion_index = list(columns).index(trailing_column) if trailing_column is not None else len(columns)
        columns.insert(insertion_index, birth_column)

    sheet_data = sheet_root.find("m:sheetData", NS)
    for row_number in range(12, last_row + 1):
        row = sheet_data.find(f"m:row[@r='{row_number}']", NS)
        if row is None or row.find(f"m:c[@r='J{row_number}']", NS) is not None:
            continue
        source_cell = row.find(f"m:c[@r='F{row_number}']", NS)
        if source_cell is None:
            continue
        cell = deepcopy(source_cell)
        cell.set("r", f"J{row_number}")
        for child in list(cell):
            if child.tag in {f"{{{MAIN_NS}}}v", f"{{{MAIN_NS}}}f", f"{{{MAIN_NS}}}is"}:
                cell.remove(child)
        row.append(cell)
        row.set("spans", "1:10")

    for merged_cell in sheet_root.findall("m:mergeCells/m:mergeCell", NS):
        reference = merged_cell.get("ref", "")
        if reference in {"A3:I3", "A4:I4", "A5:I5", "A10:I10"}:
            merged_cell.set("ref", reference.replace(":I", ":J"))

    dimension = sheet_root.find("m:dimension", NS)
    if dimension is not None:
        dimension.set("ref", f"A1:J{last_row}")

    _set_inline_text(sheet_root, "J12", "Fecha de nacimiento de la persona estudiante")


def _project_row_height(values: list[str]) -> float:
    """Calcula una altura estable según las líneas reales y el texto envuelto."""
    required_lines = 1
    for value, capacity in zip(values, PROJECT_COLUMN_CAPACITIES):
        visual_lines = sum(max(1, ceil(len(part) / capacity)) for part in str(value or "").split("\n"))
        required_lines = max(required_lines, visual_lines)
    return max(34.0, required_lines * 18.5 + 10.0)


def _set_project_row_height(sheet_root, row_number: int, values: list[str]):
    row = sheet_root.find(f"m:sheetData/m:row[@r='{row_number}']", NS)
    if row is None:
        return
    height = _project_row_height(values)
    row.set("ht", f"{height:g}")
    row.set("customHeight", "1")


def _section_label(project) -> str:
    values = [project.grade_level or "", project.section.name if project.section else ""]
    values.extend(member.section_name or "" for member in project.members)
    normalized = " ".join(values).casefold()
    return "Sección técnica nocturna" if "nocturn" in normalized else "Sección diurna"


def _category_label(project) -> str:
    category = (project.category or "").strip().casefold()
    return "Desafío STEAM" if "steam" in category else "Emprendimiento e innovación"


def _member_specialty(member, project) -> str:
    if member.specialty_ref:
        return member.specialty_ref.name
    return member.specialty or (project.specialty_ref.name if project.specialty_ref else project.specialty) or ""


def _student_row(project, member, specialty_names=None) -> list[str]:
    tutor_name = project.tutor.full_name if project.tutor else project.advisor_name or ""
    tutor_specialty = project.tutor.specialty if project.tutor and project.tutor.specialty else project.advisor_specialty or ""
    tutor_specialty = canonical_specialty_name(tutor_specialty, specialty_names or [])
    return [
        project.title or "",
        _section_label(project),
        _category_label(project),
        project.thematic_axis.name if project.thematic_axis else "",
        member.full_name if member else "",
        member.identity_number if member else "",
        _member_specialty(member, project) if member else "",
        tutor_name,
        tutor_specialty,
        member.birth_date.strftime("%d/%m/%Y") if member and member.birth_date else "",
    ]


def build_institutional_matrix() -> tuple[BytesIO, int]:
    template_path = _template_path()
    if not template_path.exists():
        raise FileNotFoundError("No se encontró la plantilla oficial de la matriz institucional.")
    projects = (
        Project.query.options(
            joinedload(Project.members),
            joinedload(Project.tutor),
            joinedload(Project.thematic_axis),
            joinedload(Project.specialty_ref),
            joinedload(Project.section),
        )
        .filter(Project.is_active.is_(True))
        .order_by(Project.title.asc(), Project.id.asc())
        .all()
    )
    specialty_names = [item.name for item in Specialty.query.filter_by(is_active=True).order_by(Specialty.sort_order.asc()).all()]
    export_rows = []
    for project in projects:
        members = sorted(project.members, key=lambda item: (item.student_number, item.id))
        if members:
            export_rows.extend(_student_row(project, member, specialty_names) for member in members)
        else:
            export_rows.append(_student_row(project, None, specialty_names))
    output = BytesIO()
    with ZipFile(template_path, "r") as source:
        sheet_path = _sheet_xml_path(source, TARGET_SHEET_NAME)
        sheet_root = ET.fromstring(source.read(sheet_path))
        last_project_row = max(LAST_TEMPLATE_PROJECT_ROW, FIRST_PROJECT_ROW + len(export_rows) - 1)
        _extend_project_rows(sheet_root, last_project_row)
        _normalize_project_row_styles(sheet_root, last_project_row)
        _set_student_name_column_width(sheet_root)
        _ensure_birth_date_column(sheet_root, last_project_row)
        school_name = SystemSetting.get_value("school_name", "") or ""
        school_year = SystemSetting.get_value("expotec_school_year", "2026") or "2026"
        _set_inline_text(sheet_root, "B8", school_name)
        _set_inline_text(sheet_root, "A5", f"Curso lectivo {school_year}")
        _set_inline_text(
            sheet_root,
            "A10",
            f"Instrucciones:  Complete la siguiente tabla con los datos de los proyectos seleccionados para participar en la fase institucional de la ExpoTÉCNICA {school_year}. Registre una persona estudiante por fila y asegúrese de completar todos los campos solicitados. ",
        )
        for row_number in range(FIRST_PROJECT_ROW, last_project_row + 1):
            export_index = row_number - FIRST_PROJECT_ROW
            values = export_rows[export_index] if export_index < len(export_rows) else [""] * 10
            for column, value in zip("ABCDEFGHIJ", values):
                _set_inline_text(sheet_root, f"{column}{row_number}", value)
            _set_project_row_height(sheet_root, row_number, values)
        sheet_bytes = ET.tostring(sheet_root, encoding="utf-8", xml_declaration=True)
        # ElementTree omite declaraciones de espacios de nombres que solo aparecen
        # en mc:Ignorable. Excel exige que todos esos prefijos sigan declarados.
        namespace_anchor = b'<worksheet '
        missing_namespaces = (
            b'xmlns:xr2="http://schemas.microsoft.com/office/spreadsheetml/2015/revision2" '
            b'xmlns:xr3="http://schemas.microsoft.com/office/spreadsheetml/2016/revision3" '
        )
        if namespace_anchor in sheet_bytes and b"xmlns:xr2=" not in sheet_bytes:
            sheet_bytes = sheet_bytes.replace(namespace_anchor, namespace_anchor + missing_namespaces, 1)
        with ZipFile(output, "w", ZIP_DEFLATED) as destination:
            for item in source.infolist():
                destination.writestr(item, sheet_bytes if item.filename == sheet_path else source.read(item.filename))
    output.seek(0)
    return output, len(projects)

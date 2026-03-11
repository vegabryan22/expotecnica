from flask import Flask
from sqlalchemy import inspect, text

from config import Config
from app.extensions import db, login_manager
from app.services.parameter_service import bootstrap_defaults


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    login_manager.init_app(app)

    from app.routes.admin_routes import admin_bp
    from app.routes.auth_routes import auth_bp
    from app.routes.judge_routes import judge_bp
    from app.routes.public_routes import public_bp

    app.register_blueprint(public_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(judge_bp)
    app.register_blueprint(admin_bp)

    with app.app_context():
        from app import models  # noqa: F401

        db.create_all()
        ensure_schema_updates()
        bootstrap_defaults(db)

    register_cli(app)
    return app


def register_cli(app):
    @app.cli.command("create-judge")
    def create_judge():
        from getpass import getpass

        from app.models.judge import Judge

        full_name = input("Nombre completo: ").strip()
        email = input("Correo: ").strip().lower()
        password = getpass("Contraseña: ")

        if Judge.query.filter_by(email=email).first():
            print("Ya existe un juez con ese correo.")
            return

        judge = Judge(full_name=full_name, email=email)
        judge.set_password(password)
        db.session.add(judge)
        db.session.commit()
        print("Juez creado correctamente.")

    @app.cli.command("assign-project")
    def assign_project():
        from app.models.assignment import Assignment
        from app.models.judge import Judge
        from app.models.project import Project

        try:
            judge_id = int(input("ID juez: ").strip())
            project_id = int(input("ID proyecto: ").strip())
        except ValueError:
            print("IDs inválidos.")
            return

        judge = Judge.query.get(judge_id)
        project = Project.query.get(project_id)
        if not judge or not project:
            print("Juez o proyecto no encontrado.")
            return

        exists = Assignment.query.filter_by(judge_id=judge_id, project_id=project_id).first()
        if exists:
            print("La asignación ya existe.")
            return

        db.session.add(Assignment(judge_id=judge_id, project_id=project_id))
        db.session.commit()
        print("Asignación creada.")

    @app.cli.command("create-admin")
    def create_admin():
        from getpass import getpass

        from app.models.judge import Judge

        full_name = input("Nombre completo: ").strip()
        email = input("Correo: ").strip().lower()
        password = getpass("Contraseña: ")

        if Judge.query.filter_by(email=email).first():
            print("Ya existe un usuario con ese correo.")
            return

        admin = Judge(full_name=full_name, email=email, is_admin=True)
        admin.set_password(password)
        db.session.add(admin)
        db.session.commit()
        print("Admin creado correctamente.")


def ensure_schema_updates():
    inspector = inspect(db.engine)
    with db.engine.begin() as connection:
        judge_columns = {column["name"] for column in inspector.get_columns("judges")}
        if "is_admin" not in judge_columns:
            connection.execute(text("ALTER TABLE judges ADD COLUMN is_admin BOOLEAN NOT NULL DEFAULT 0"))

        project_columns = {column["name"] for column in inspector.get_columns("projects")}
        category_column = next((column for column in inspector.get_columns("projects") if column["name"] == "category"), None)
        if category_column and "enum" in str(category_column["type"]).lower():
            connection.execute(text("ALTER TABLE projects MODIFY COLUMN category VARCHAR(60) NOT NULL"))
        if "category" in project_columns:
            connection.execute(text("UPDATE projects SET category='emprendimiento' WHERE category=''"))
        if "representative_phone" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN representative_phone VARCHAR(40) NULL"))
        if "institution_name" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN institution_name VARCHAR(180) NULL"))
        if "grade_level" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN grade_level VARCHAR(60) NULL"))
        if "specialty" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN specialty VARCHAR(120) NULL"))
        if "advisor_name" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN advisor_name VARCHAR(120) NULL"))
        if "advisor_email" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN advisor_email VARCHAR(120) NULL"))
        if "advisor_phone" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN advisor_phone VARCHAR(40) NULL"))
        if "project_objective" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN project_objective TEXT NULL"))
        if "expected_impact" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN expected_impact TEXT NULL"))
        if "required_resources" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN required_resources TEXT NULL"))
        if "consent_terms" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN consent_terms BOOLEAN NOT NULL DEFAULT 0"))
        if "registration_date" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN registration_date DATE NULL"))
        if "advisor_identity" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN advisor_identity VARCHAR(40) NULL"))
        if "requirements_summary" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN requirements_summary TEXT NULL"))
        if "requirements_other" not in project_columns:
            connection.execute(text("ALTER TABLE projects ADD COLUMN requirements_other VARCHAR(255) NULL"))

        evaluation_columns = {column["name"] for column in inspector.get_columns("evaluations")}
        evaluation_type_column = next(
            (column for column in inspector.get_columns("evaluations") if column["name"] == "evaluation_type"),
            None,
        )
        if evaluation_type_column and "enum" in str(evaluation_type_column["type"]).lower():
            connection.execute(text("ALTER TABLE evaluations MODIFY COLUMN evaluation_type VARCHAR(60) NOT NULL"))

        for criteria_name in ["criteria_1", "criteria_2", "criteria_3", "criteria_4"]:
            if criteria_name in evaluation_columns:
                connection.execute(text(f"ALTER TABLE evaluations MODIFY COLUMN {criteria_name} INT NULL"))

        if "project_members" in inspector.get_table_names():
            member_columns = {column["name"] for column in inspector.get_columns("project_members")}
            if "student_number" not in member_columns:
                connection.execute(text("ALTER TABLE project_members ADD COLUMN student_number INT NOT NULL DEFAULT 1"))
            if "identity_number" not in member_columns:
                connection.execute(text("ALTER TABLE project_members ADD COLUMN identity_number VARCHAR(40) NULL"))
            if "birth_date" not in member_columns:
                connection.execute(text("ALTER TABLE project_members ADD COLUMN birth_date DATE NULL"))
            if "gender" not in member_columns:
                connection.execute(text("ALTER TABLE project_members ADD COLUMN gender VARCHAR(20) NULL"))
            if "specialty" not in member_columns:
                connection.execute(text("ALTER TABLE project_members ADD COLUMN specialty VARCHAR(140) NULL"))
            if "section_name" not in member_columns:
                connection.execute(text("ALTER TABLE project_members ADD COLUMN section_name VARCHAR(30) NULL"))
            if "has_dining_scholarship" not in member_columns:
                connection.execute(
                    text("ALTER TABLE project_members ADD COLUMN has_dining_scholarship BOOLEAN NOT NULL DEFAULT 0")
                )
            if "phone" not in member_columns:
                connection.execute(text("ALTER TABLE project_members ADD COLUMN phone VARCHAR(40) NULL"))
            if "email" not in member_columns:
                connection.execute(text("ALTER TABLE project_members ADD COLUMN email VARCHAR(120) NULL"))
            if "role" in member_columns:
                connection.execute(text("ALTER TABLE project_members MODIFY COLUMN role VARCHAR(120) NULL"))
            if "photo_url" in member_columns:
                connection.execute(text("ALTER TABLE project_members MODIFY COLUMN photo_url VARCHAR(300) NULL"))

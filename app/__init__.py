from flask import Flask
from sqlalchemy import inspect, text

from config import Config
from app.extensions import db, login_manager


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
    columns = {column["name"] for column in inspector.get_columns("judges")}
    if "is_admin" in columns:
        return

    with db.engine.begin() as connection:
        connection.execute(
            text("ALTER TABLE judges ADD COLUMN is_admin BOOLEAN NOT NULL DEFAULT 0")
        )

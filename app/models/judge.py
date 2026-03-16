from datetime import datetime

from flask_login import UserMixin
from werkzeug.security import check_password_hash, generate_password_hash

from app.extensions import db, login_manager


class Judge(UserMixin, db.Model):
    __tablename__ = "judges"

    id = db.Column(db.Integer, primary_key=True)
    full_name = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    department = db.Column(db.String(40), nullable=True, index=True)
    job_title = db.Column(db.String(120), nullable=True)
    phone = db.Column(db.String(40), nullable=True)
    password_hash = db.Column(db.String(255), nullable=False)
    is_active_user = db.Column(db.Boolean, default=True, nullable=False)
    is_admin = db.Column(db.Boolean, default=False, nullable=False)
    must_change_password = db.Column(db.Boolean, default=False, nullable=False)
    last_login_at = db.Column(db.DateTime, nullable=True)

    assignments = db.relationship("Assignment", back_populates="judge", cascade="all, delete-orphan")
    evaluations = db.relationship("Evaluation", back_populates="judge", cascade="all, delete-orphan")

    def set_password(self, password: str) -> None:
        self.password_hash = generate_password_hash(password)

    def check_password(self, password: str) -> bool:
        return check_password_hash(self.password_hash, password)

    @property
    def is_active(self) -> bool:
        return self.is_active_user

    @property
    def department_label(self) -> str:
        labels = {
            "logistica": "Logistica",
            "datos": "Datos",
            "diseno": "Diseno",
            "qa": "QA",
        }
        return labels.get((self.department or "").strip().lower(), "Sin departamento")

    def mark_login(self) -> None:
        self.last_login_at = datetime.utcnow()


@login_manager.user_loader
def load_user(user_id: str):
    return Judge.query.get(int(user_id))

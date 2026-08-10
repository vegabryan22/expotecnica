from datetime import datetime

from app.extensions import db


class Venue(db.Model):
    __tablename__ = "venues"

    TYPES = {"aula", "taller", "jueces", "edecanes", "otro"}

    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(40), nullable=False, unique=True, index=True)
    name = db.Column(db.String(120), nullable=False)
    venue_type = db.Column(db.String(30), nullable=False, default="aula")
    description = db.Column(db.String(255), nullable=True)
    map_x = db.Column(db.Float, nullable=True)
    map_y = db.Column(db.Float, nullable=True)
    sort_order = db.Column(db.Integer, nullable=False, default=0)
    is_active = db.Column(db.Boolean, nullable=False, default=True, index=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    projects = db.relationship("Project", back_populates="venue")

    @property
    def type_label(self):
        return {"aula": "Aula", "taller": "Taller", "jueces": "Jueces", "edecanes": "Edecanes", "otro": "Otro"}.get(self.venue_type, self.venue_type)

    @property
    def is_meeting_point(self):
        return self.venue_type in {"jueces", "edecanes"}

    @property
    def accepts_projects(self):
        return not self.is_meeting_point

    @property
    def operational_label(self):
        return "Punto de reunión" if self.is_meeting_point else "Recinto de proyectos"

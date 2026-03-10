# ExpoTécnica (Flask + MySQL, MVC)

App web para feria científica con:
- inscripción de proyectos (`STEAM` y `Emprendimiento`)
- login de jueces y admin
- evaluación por rúbrica en dos tipos: `escrito` y `exposicion`
- control para no duplicar evaluación del mismo tipo por juez/proyecto
- panel admin para asignar proyectos a jueces

## 1) Requisitos
- Python 3.11+
- MySQL Server

## 2) Crear base de datos y usuario en MySQL
Con tu root local (`root` / `123456`):

```sql
SOURCE sql/setup.sql;
```

O ejecuta manualmente:

```sql
CREATE DATABASE IF NOT EXISTS expotecnica_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'expotecnica_user'@'localhost' IDENTIFIED BY 'expotecnica123';
GRANT ALL PRIVILEGES ON expotecnica_db.* TO 'expotecnica_user'@'localhost';
FLUSH PRIVILEGES;
```

## 3) Instalar dependencias
```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

## 4) Configuración
La app usa por defecto:

```text
mysql+pymysql://root:123456@localhost/expotecnica_db?charset=utf8mb4
```

Si prefieres el usuario creado para la app:

```text
set DATABASE_URL=mysql+pymysql://expotecnica_user:expotecnica123@localhost/expotecnica_db?charset=utf8mb4
```

## 5) Ejecutar
```bash
python run.py
```

## 6) Crear usuarios y asignaciones
Crear juez:
```bash
flask --app run.py create-judge
```

Crear admin:
```bash
flask --app run.py create-admin
```

Asignar proyecto a juez:
```bash
flask --app run.py assign-project
```

Tambien puedes asignar desde la web en `/admin/panel`.

## Arquitectura MVC
- Modelo: `app/models/*`
- Controlador: `app/controllers/*`
- Vista: `app/templates/*`
- Rutas: `app/routes/*`

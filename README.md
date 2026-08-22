# ExpoTécnica CTP Roberto Gamboa Valverde

Sistema web para administrar la feria institucional de innovación y emprendimiento: inscripción, proyectos, tutores, jueces, asignaciones, evaluación, logística, resultados, actas, certificados, reportes e integración con la etapa regional.

El proyecto comenzó el 10 de marzo de 2026 y acumula 456 commits auditados hasta el 19 de agosto de 2026. La evolución completa se resume en [Historial de desarrollo](docs/HISTORIAL_DESARROLLO.md) y el estado funcional vigente en [Referencia funcional](docs/REFERENCIA_FUNCIONAL.md).

## Capacidades principales

- Inscripción pública de proyectos por campaña, con uno a tres estudiantes y expediente ExpoTEC.
- Catálogos académicos configurables: categorías, niveles, secciones, especialidades, talleres, ejes y tipos de proyecto.
- Gestión de proyectos, integrantes, fotografías, documento escrito, consentimientos, cédulas, logo, recinto y requerimientos.
- Registro y administración de jueces, perfiles de evaluación, disponibilidad, asistencia, parqueo y reconfirmación.
- Asignación manual, rápida, masiva y automática de jueces; control de cobertura documental, exposición e inglés.
- Evaluación con rúbricas parametrizadas, descripciones por nivel, escalas numéricas y textuales.
- Recordatorios por correo y WhatsApp normal, con seguimiento de envíos.
- Panel administrativo organizado por flujo de trabajo y permisos por rol/departamento.
- Centro de reportes Excel y PDF, matriz institucional, reportes de jueces, tutores, edecanes y pendientes.
- Portal personal de resultados para tutores, con promedios y retroalimentación detallada de sus propios proyectos.
- Campañas de cierre para jueces con vista previa, destinatarios filtrados, encuesta personalizada y confirmación explícita antes del envío.
- Actas, acta oficial de ganadores, certificados y resultados acumulados.
- Recintos, mapa institucional interactivo y mapa PDF para operación del evento.
- Envío idempotente de ganadores y fotografías a una plataforma regional independiente.
- Respaldos, restauración, auditoría, mantenimiento, dependencias y despliegue GitOps.
- Diagnóstico interno en `/health` para validar aplicación, base de datos y versión durante los despliegues.

## Usuarios y áreas

| Perfil | Uso principal |
| --- | --- |
| Visitante | Consultar proyectos activos e ingresar a una campaña de inscripción. |
| Tutor/estudiante | Registrar proyectos y atender solicitudes o recordatorios documentales. |
| Juez | Consultar asignaciones y registrar evaluaciones autorizadas. |
| Administración | Operar los módulos habilitados para su departamento. |
| Edecanes/logística | Consultar recintos, proyectos, integrantes y operación del evento. |
| Superadministración | Configuración completa, permisos, mantenimiento y soporte. |

## Tecnología

- Python 3.11 o superior.
- Flask 3.1, Flask-SQLAlchemy y Flask-Login.
- MySQL con PyMySQL y codificación `utf8mb4`.
- Jinja2, HTML, CSS y JavaScript sin framework de interfaz.
- ReportLab para PDF y OpenPyXL para Excel.
- Requests para la integración regional.

## Instalación local

### 1. Clonar y preparar el entorno

```powershell
git clone https://github.com/vegabryan22/expotecnica.git
cd expotecnica
python -m venv .venv
.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

### 2. Crear la base de datos

Desde MySQL:

```sql
SOURCE sql/setup.sql;
```

La conexión predeterminada de desarrollo es:

```text
mysql+pymysql://expotecnica_user:expotecnica123@localhost/expotecnica_db?charset=utf8mb4
```

Para usar otra conexión, cree un archivo `.env` local o defina:

```powershell
$env:DATABASE_URL='mysql+pymysql://usuario:clave@localhost/expotecnica_db?charset=utf8mb4'
$env:SECRET_KEY='una-clave-segura-y-distinta'
```

No utilice las credenciales predeterminadas ni versionadas en producción.

### 3. Ejecutar

```powershell
python run.py
```

La aplicación local queda disponible en `http://127.0.0.1:5000`.

## Comandos administrativos

```powershell
flask --app run.py create-admin
flask --app run.py create-judge
flask --app run.py assign-project
```

## Pruebas y calidad

Ejecute antes de publicar:

```powershell
python -m pytest -q
python scripts/check_text_encoding.py
```

El verificador de codificación evita publicar texto con mojibake o archivos incompatibles con UTF-8.

## Arquitectura

```text
app/
├── controllers/   Lógica HTTP y coordinación de casos de uso
├── models/        Entidades SQLAlchemy
├── routes/        Registro de rutas por área
├── services/      Evaluación, asignación, correo, auditoría e integraciones
├── static/        CSS, JavaScript, imágenes, uploads y documentos
└── templates/     Vistas públicas, autenticación, jueces y administración
```

La aplicación es un monolito Flask con separación MVC y servicios transversales. La referencia detallada está en [Arquitectura de módulos](docs/ARQUITECTURA_MODULOS.md).

## Base de datos y archivos

- El esquema base se encuentra en `sql/setup.sql`.
- Los respaldos del repositorio están en `sql/backups/`.
- Los parches manuales excepcionales están en `sql/` y deben aplicarse solo después de revisar su alcance.
- Los documentos y fotografías cargados se guardan bajo `app/static/uploads/`.
- Los cambios actuales de interfaz no requieren migración de base de datos salvo que el commit correspondiente lo indique expresamente.

## Despliegue y GitOps

Consulte [Guía para otra máquina](docs/GUIA_OTRA_MAQUINA.md). El repositorio incluye hooks opcionales en `.githooks`:

- `pre-commit`: genera respaldo SQL.
- `post-merge` y `post-checkout`: sincronizan dependencias cuando cambia `requirements.txt`.

Activación por clon:

```powershell
git config core.hooksPath .githooks
```

En producción deben configurarse de forma externa la conexión MySQL, la clave secreta, SMTP, permisos de archivos y el servicio WSGI.

El panel GitOps comprueba el proceso, la identidad de la aplicación, la conexión de base de datos, la versión desplegada y el tiempo de respuesta mediante `GET /health`. Un HTTP exitoso de otra página no se interpreta como evidencia de que el servicio completo esté operativo.

## Documentación

- [Referencia funcional actual](docs/REFERENCIA_FUNCIONAL.md)
- [Historial de los 456 commits](docs/HISTORIAL_DESARROLLO.md)
- [Arquitectura de módulos](docs/ARQUITECTURA_MODULOS.md)
- [Modelo y estrategia de QA](docs/MODELO_PRUEBAS_QA.md)
- [Integración regional](docs/INTEGRACION_REGIONAL.md)
- [Guía para otra máquina](docs/GUIA_OTRA_MAQUINA.md)
- [Changelog por versiones](CHANGELOG.md)
- [Evidencia de sprints](docs/sprints/)

## Versionamiento

La versión visible está en `VERSION`. Los tags históricos cubren las versiones `v0.1.0` a `v0.25.3`; el changelog continúa documentando versiones posteriores. Antes de crear un release, alinee `VERSION`, `CHANGELOG.md`, documentación, pruebas y tag.

## Estado de la documentación

Esta documentación fue reconstruida el 19 de agosto de 2026 a partir del historial completo de Git, la estructura vigente y los documentos existentes. Los commits se agrupan por capacidad y etapa; Git continúa siendo la fuente exacta para cambios línea por línea.

# Changelog

## [0.6.0] - 2026-03-11
### Added
- Campañas de inscripción y disponibilidad pública del formulario con validación por fechas activas.
- Mantenimiento de institución (nombre, dirección, teléfono, correo y logo) para reutilizar datos institucionales.
- Bitácora/auditoría de acciones administrativas relevantes con vista dedicada.
- Configuración de mantenimiento de proyectos con mensaje e imagen para visitantes.

### Changed
- Unificación visual de vistas administrativas en formato dashboard con tarjetas, modales y estilos consistentes.
- Ajustes de inscripción y proyectos para flujos de logística, enlaces de documentación y navegación de evaluación.
- Acciones de tablas con botones de ícono y botones de formularios con ícono + texto.

### Fixed
- Correcciones de codificación UTF-8 (acentos y caracteres especiales) en vistas y textos.
- Arreglo del script de respaldo SQL para serializar correctamente campos date/	ime.
## [0.5.0] - 2026-03-11
### Added
- Mantenimiento academico normalizado con tablas de `niveles`, `secciones`, `especialidades` y `talleres`.
- Carga de documentacion de proyecto en inscripcion y mantenimiento logistico de fotos de integrantes.
- CRUD de integrantes en panel admin (agregar, editar, eliminar y actualizar foto).
- Vista publica de proyectos e inscripcion alineadas al flujo ExpoTEC-1 con validaciones STEAM/Emprendimiento.

### Changed
- Rediseño global del panel admin a formato tabla + acciones por modal para todos los mantenimientos.
- Rubricas mejoradas: listado principal por `ID` y gestion por modal de tipo de evaluacion.
- Parametrizacion ampliada para evitar datos quemados en codigo en modulos administrativos.

### Fixed
- Correcciones de experiencia de edicion en mantenimientos para reducir saturacion visual.
- Ajustes de consistencia entre backend y vistas de administracion y proyectos.
## [0.4.0] - 2026-03-11
### Added
- Panel de administracion modular con menu lateral y rutas separadas por modulo.
- Parametrizacion completa de categorias, tipos de evaluacion, rubricas y configuracion SMTP.
- Servicio SMTP con prueba de envio y notificaciones automáticas para credenciales/asignaciones.
- Formulario ExpoTEC-1 en 6 secciones con validaciones condicionales para 1-3 estudiantes.
- Campos extendidos para estudiantes, tutor y requerimientos del proyecto.
- Soporte de versionado del sprint mediante archivos `VERSION` y notas en `docs/sprints/`.

### Changed
- Rediseño visual institucional del sitio (header, cards, botones, dashboard y footer).
- Home publica organizada por categorias con informacion ampliada de proyectos.
- Modelo de evaluacion desacoplado de valores quemados y conectado a parametros de BD.

### Fixed
- Limpieza de referencias de mantenimiento y normalizacion de rutas de panel admin.
- Correcciones de render en formulario de inscripcion con datos multivalor.

## [0.3.0] - 2026-03-11
### Added
- Respaldo automatico de base de datos en cada commit usando hook `pre-commit`.
- Script de exportacion SQL versionado en `scripts/backup_db.py`.
- Respaldo de referencia en `sql/backups/expotecnica_latest.sql`.

### Changed
- Documentacion del flujo de respaldo en README.

## [0.2.0] - 2026-03-11
### Added
- Portada publica con proyectos por categoria.
- Carga de fotos de integrantes al servidor y visualizacion en home.
- Modelo inicial de integrantes de proyecto (`ProjectMember`).

### Changed
- Ruta principal `/` migrada de landing simple a portada de proyectos.
- Estilos globales modernizados para vistas publicas.

## [0.1.0] - 2026-03-11
### Added
- Base de la aplicacion Flask con arquitectura MVC.
- Modulos de autenticacion, panel de jueces y panel administrativo.
- Registro de proyectos y flujo de evaluacion por rubrica.
- Estructura inicial de base de datos MySQL y comandos CLI operativos.



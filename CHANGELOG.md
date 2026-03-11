# Changelog

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

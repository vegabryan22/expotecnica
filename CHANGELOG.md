# Changelog

## [0.8.0] - 2026-03-20
### Added
- Actas de evaluacion en PDF por proyecto y consolidado general, con vista previa HTML y opcion de descarga/visualizacion directa.
- Nuevas rutas admin para reportes de actas y botones de acceso rapido desde el modulo de evaluaciones.
- Menu hamburguesa en movil para navegacion superior.

### Changed
- UI del panel de juez: acciones de evaluacion mas claras, botones compactos y mejor adaptacion responsive en movil.
- Textos visibles en vistas normalizados con acentos y caracteres en espanol.
- Selector de estado de campana simplificado (activa/inactiva) para evitar confusiones del checkbox.

### Fixed
- Alineacion del boton `Cerrar sesion` en la barra superior.
- Correcciones de codificacion y labels mal renderizados en mantenimiento academico y menu lateral admin.
- Consistencia de etiquetas cortas de tipos de evaluacion para evitar textos largos en celdas.

## [0.7.0] - 2026-03-17
### Added
- Logo propio de ExpoTecnica separado del logo institucional y reutilizado en home, formulario y login.
- Placeholders visuales para estudiantes sin foto y logo generico para proyectos sin logo real.
- Centro de operaciones en el panel admin con indicadores de logistica, jueces y evaluaciones pendientes.
- Documentacion funcional para QA: arquitectura de modulos y modelo de pruebas con resultados esperados.

### Changed
- Reorganizacion operativa del modulo de asignaciones con mantenimiento rapido por proyecto y modales de gestion.
- Panel de permisos por departamento rediseñado a tarjetas con interruptores por modulo.
- Mantenimientos de rubricas, proyectos, campañas, evaluaciones y usuarios con mejoras de lectura y consistencia visual.
- Branding y paleta del sitio alineados a ExpoTecnica, incluyendo login y cabeceras publicas.
- Tipos de evaluacion con nombre corto y descripcion larga para usar textos entendibles en UI.

### Fixed
- Validacion de categorias para obligar una rubrica de Exposicion y una de Documentacion.
- Identificacion correcta de rubricas de Exposicion y Documentacion en calculo y dashboard de evaluaciones.
- Reglas de usuarios: jueces sin departamento y un solo usuario generico por departamento.
- Contadores y reportes restringidos a proyectos activos cuando corresponde.
- Tipos de evaluacion eliminados manualmente ya no se recrean automaticamente.

## [0.6.0] - 2026-03-11
### Added
- Campañas de inscripción y disponibilidad pública del formulario con validación por fechas activas.
- Mantenimiento de institución (nombre, dirección, teléfono, correo y logo) para reutilizar datos institucionales.
- Bitácora y auditoría de acciones administrativas relevantes con vista dedicada.
- Configuración de mantenimiento de proyectos con mensaje e imagen para visitantes.

### Changed
- Unificación visual de vistas administrativas en formato dashboard con tarjetas, modales y estilos consistentes.
- Ajustes de inscripción y proyectos para flujos de logística, enlaces de documentación y navegación de evaluación.
- Acciones de tablas con botones de ícono y botones de formularios con ícono y texto.

### Fixed
- Correcciones de codificación UTF-8 en vistas y textos.
- Arreglo del script de respaldo SQL para serializar correctamente campos `date` y `time`.

## [0.5.0] - 2026-03-11
### Added
- Mantenimiento academico normalizado con tablas de `niveles`, `secciones`, `especialidades` y `talleres`.
- Carga de documentacion de proyecto en inscripcion y mantenimiento logistico de fotos de integrantes.
- CRUD de integrantes en panel admin: agregar, editar, eliminar y actualizar foto.
- Vista publica de proyectos e inscripcion alineadas al flujo ExpoTEC-1 con validaciones STEAM y Emprendimiento.

### Changed
- Rediseño global del panel admin a formato tabla con acciones por modal para todos los mantenimientos.
- Rubricas mejoradas con listado principal por `ID` y gestion por modal de tipo de evaluacion.
- Parametrizacion ampliada para evitar datos quemados en codigo en modulos administrativos.

### Fixed
- Correcciones de experiencia de edicion en mantenimientos para reducir saturacion visual.
- Ajustes de consistencia entre backend y vistas de administracion y proyectos.

## [0.4.0] - 2026-03-11
### Added
- Panel de administracion modular con menu lateral y rutas separadas por modulo.
- Parametrizacion completa de categorias, tipos de evaluacion, rubricas y configuracion SMTP.
- Servicio SMTP con prueba de envio y notificaciones automaticas para credenciales y asignaciones.
- Formulario ExpoTEC-1 en 6 secciones con validaciones condicionales para 1 a 3 estudiantes.
- Campos extendidos para estudiantes, tutor y requerimientos del proyecto.
- Soporte de versionado del sprint mediante archivos `VERSION` y notas en `docs/sprints/`.

### Changed
- Rediseño visual institucional del sitio: header, cards, botones, dashboard y footer.
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

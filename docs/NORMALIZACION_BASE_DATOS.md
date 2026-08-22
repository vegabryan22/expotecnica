# Auditoría y plan de normalización de la base de datos

Fecha de revisión: 2026-08-22

## Alcance revisado

- Modelos SQLAlchemy actuales.
- Esquema MySQL local.
- Respaldo definitivo `expotecnica_db_20260822_005421_manual.sql`.
- Relaciones, restricciones únicas, datos maestros duplicados y atributos multivalor.

## Diagnóstico

La base tiene buenas relaciones en asignaciones, evaluaciones, puntajes, integrantes y revisiones, pero no está completamente normalizada. `projects` funciona actualmente como una tabla agregada que conserva datos maestros, copias históricas y estados operativos en la misma fila.

### Duplicaciones críticas

| Origen | Datos repetidos | Relación normalizada requerida |
|---|---|---|
| `projects.category` | Nombre/código de una categoría existente | `projects.category_id -> categories.id` |
| `projects.specialty` | Nombre de `specialties` | Conservar únicamente `specialty_id` |
| `projects.grade_level` | Nivel derivable desde la sección | Derivar mediante `section_id -> sections.level_id` |
| `projects.advisor_*` | Copia completa del tutor | Conservar `tutor_id`; historial en una tabla de instantáneas si es necesario |
| `projects.mentor_*` | Persona repetida por proyecto | `mentors` y `projects.mentor_id` |
| `projects.institution_name` | Institución repetida | `institutions` y `projects.institution_id` |
| `projects.representative_*` | Datos que pueden pertenecer a un integrante | `representative_member_id -> project_members.id` o contacto separado |
| `project_members.specialty` | Nombre de `specialties` | Conservar únicamente `specialty_id` |
| `project_members.section_name` | Nombre de `sections` | Agregar `section_id -> sections.id` |
| `tutors.specialty` | Nombre de `specialties` | Agregar `specialty_id -> specialties.id` |
| `evaluations.evaluation_type` | Código de `evaluation_types` | `evaluation_type_id -> evaluation_types.id` |
| `evaluations.criteria_1..4` | Puntajes duplicados | Usar únicamente `evaluation_scores` |
| `categories.rubric_1_*` / `rubric_2_*` | Grupo fijo y repetido | Tabla puente `category_evaluation_types` |
| `evaluation_types.scale_labels` | Mapa JSON | Tabla `evaluation_scale_options` |
| `rubric_criteria.score_descriptions` | Mapa JSON por criterio | Tabla `rubric_score_descriptions` |
| `rubric_criteria.section_name` | Sección repetida en cada criterio | Tabla `rubric_sections` |
| `projects.requirements_items_json` | Filas almacenadas en JSON | `project_requirement_items` |
| Banderas `requirements_*` | Lista fija dentro de `projects` | Catálogo y tabla `project_requirement_checks` |
| Banderas `logistics_*` | Lista fija dentro de `projects` | Catálogo y tabla `project_logistics_checks` |

### Datos del evento ubicados en la entidad equivocada

La asistencia, parqueo, invitaciones y reconfirmaciones están dentro de `judges`. Esos valores pertenecen a la participación del juez en una edición concreta, no a su identidad permanente.

Modelo objetivo:

```text
judges
  └── judge_event_participations
        ├── campaign_id -> campaigns.id
        ├── judge_id -> judges.id
        ├── asistencia y parqueo
        ├── invitaciones y respuestas
        └── judge_feedback
```

Esto evita sobrescribir la asistencia de 2026 cuando se abra la Expo 2027.

## Llaves foráneas faltantes o incompletas

El respaldo del 20 de agosto solo contiene llaves foráneas de `projects` hacia `tutors` y `venues`, aunque existen columnas para sección, especialidad, eje, tipo, taller y campaña. El esquema local ya incorporó parte de ellas, pero todavía faltan relaciones efectivas en:

- `projects.thematic_axis_id -> thematic_axes.id`
- `projects.project_type_id -> project_types.id`
- `project_members.specialty_id -> specialties.id`
- La futura `evaluations.evaluation_type_id -> evaluation_types.id`

También deben uniformarse las reglas `ON DELETE`: `RESTRICT` para catálogos usados, `CASCADE` para componentes exclusivos del proyecto y `SET NULL` para conservar evidencia histórica cuando se elimina una cuenta.

## Restricciones únicas recomendadas

- `sections(level_id, name)`
- `project_members(project_id, student_number)`
- `category_evaluation_types(category_id, evaluation_type_id)`
- `evaluation_scale_options(evaluation_type_id, score)`
- `rubric_sections(evaluation_type_id, sort_order)`
- `rubric_score_descriptions(rubric_criterion_id, score)`
- `judge_event_participations(judge_id, campaign_id)`
- `project_requirement_items(project_id, sort_order)`
- Identidades normalizadas de jueces, tutores, mentores y estudiantes cuando no sean nulas.

## Resultado del respaldo de producción del 22 de agosto

Integridad del archivo:

- Tamaño: 3 011 513 bytes.
- Finalización declarada por `mysqldump`: 2026-08-22 00:54:21.
- SHA-256: `ECA8746D7D7EE205E67F2EB26F5CAC66D5021AA330710507C7C01B989C11A1C4`.

Conteos preservables para comprobar la migración:

| Entidad | Registros |
|---|---:|
| Proyectos | 31 |
| Integrantes | 78 |
| Jueces/usuarios | 68 |
| Asignaciones | 153 |
| Evaluaciones | 815 |
| Puntajes por criterio | 18 382 |

Resultados de integridad y duplicación:

- No hay cédulas estudiantiles duplicadas.
- No hay cédulas duplicadas entre jueces.
- No hay referencias huérfanas en sección, especialidad, eje, tipo, taller, campaña o tutor.
- No hay puntajes que apunten a evaluaciones o criterios inexistentes.
- No hay diferencias entre el texto de especialidad y `specialty_id`.
- No hay diferencias entre la identidad copiada del asesor y `tutor_id`.
- Los 31 proyectos repiten `CTP Roberto Gamboa Valverde` en `institution_name`.
- Los 31 proyectos guardan la categoría como texto: 17 `emprendimiento` y 14 `steam`.
- Siete tutores están duplicados en las columnas `advisor_*` de entre 2 y 8 proyectos; los valores son consistentes, por lo que pueden consolidarse de forma determinista mediante `tutor_id`.
- No se encontraron mentores repetidos por identidad.
- Existen evaluaciones históricas con referencias `NULL` debido a las reglas `ON DELETE SET NULL`. Sus 18 382 puntajes siguen íntegros; la migración debe preservar estas evaluaciones como evidencia histórica.

## Resultado del diagnóstico de datos local

- No se encontraron referencias huérfanas en sección, especialidad, eje, tipo, taller o campaña.
- No se encontraron cédulas duplicadas entre jueces.
- Existe una cédula estudiantil repetida en los datos locales de demostración.
- Los dos proyectos locales repiten la misma institución y el mismo tutor en columnas textuales.
- No existen diferencias entre `projects.specialty` y la especialidad referenciada actualmente.
- No existen diferencias entre `projects.advisor_identity` y el tutor referenciado actualmente.

Los resultados del respaldo de producción sustituyen la muestra local como línea base para la migración.

## Estrategia segura de migración

### Fase 1: relaciones aditivas

1. Crear tablas maestras y columnas `*_id` nuevas, inicialmente nulas.
2. Poblarlas desde los valores textuales normalizados.
3. Emitir un reporte de valores sin correspondencia y duplicados ambiguos.
4. Agregar índices y llaves foráneas únicamente después de resolver huérfanos.
5. Mantener lectura compatible con las columnas antiguas durante una versión.

### Fase 2: escritura normalizada

1. Cambiar formularios y servicios para escribir solo relaciones.
2. Mantener columnas antiguas como copia de compatibilidad temporal.
3. Comparar resultados de reportes, actas, certificados y evaluaciones entre ambos modelos.

### Fase 3: eliminación de redundancia

1. Crear un respaldo completo verificado.
2. Detener escrituras durante la ventana de migración.
3. Eliminar columnas antiguas únicamente cuando no exista código que las consulte.
4. Ejecutar integridad referencial, conteos y pruebas funcionales.

## Criterio de aceptación

La normalización se considerará terminada cuando:

- Toda columna `*_id` tenga una llave foránea real.
- No existan nombres de catálogos duplicados junto a su `*_id`.
- No haya listas operativas guardadas en JSON o columnas numeradas.
- Cada dato dependa de la llave de su tabla, de toda la llave y de nada más que la llave.
- La migración conserve los totales de proyectos, integrantes, asignaciones, evaluaciones y puntajes.
- Actas, certificados, resultados, matriz institucional y reportes produzcan los mismos resultados antes y después.

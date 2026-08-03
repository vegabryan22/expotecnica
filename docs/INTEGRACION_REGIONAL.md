# Envío de ganadores a ExpoTécnica Regional

## Configuración inicial

La coordinación regional registra el colegio y genera una credencial API. En esta plataforma, un administrador abre **Administración > Integración regional** y configura:

- URL base: en local `http://127.0.0.1:5001/api/v1`; en producción debe ser HTTPS.
- Código del colegio: exactamente el acordado con la coordinación regional.
- Token: el valor entregado una sola vez por la regional.

El token es un secreto. No debe guardarse en Git, documentos, capturas ni mensajes. Para rotarlo, se configura y prueba el token nuevo antes de que la regional revoque el anterior.

## Flujo operativo

1. La institución completa la inscripción y evaluación interna.
2. Un administrador selecciona el proyecto ganador en **Integración regional**.
3. **Enviar ganador** transmite datos, tutor, estudiantes y después los archivos existentes.
4. El módulo conserva el resultado, cantidad de intentos y estado regional.
5. **Consultar estado** actualiza el avance y las observaciones de la coordinación regional.

El identificador se genera como `{CODIGO}-{ID}` y permanece estable. Reintentar no duplica el proyecto regional: mientras esté recibido o devuelto, reemplaza su copia con la versión institucional más reciente. Una vez que la regional lo adelanta a revisión/evaluación, la API impide reemplazarlo.

## Fallos y recuperación

- `401`: revisar o rotar el token.
- `403`: solicitar que habiliten el colegio.
- `409`: el proyecto ya avanzó; coordinar una devolución antes de corregirlo.
- `422`: corregir categoría, estudiantes, campos o archivos indicados.
- Error de conexión: confirmar que la URL regional responde y usar **Reintentar**.

La regional recibe una copia mínima; nunca accede directamente a `expotecnica_db`. La institución tampoco accede a la base `exporegional`.

# Diagnóstico de conexión: Failed to fetch

## Lo que ya sabemos

En GitHub Actions, el deploy 42868965443 creó 10 recursos y GET /health devolvió JSON con ok:true. Esto confirma la ruta Lambda/API Gateway desde el runner, pero **no demuestra** que cualquier navegador pueda ejecutar fetch: CORS, una URL mal construida o restricciones del navegador pueden impedirlo.

**API base de este laboratorio:** https://zgpedsbrl0.execute-api.us-east-1.amazonaws.com

**GET de salud:** https://zgpedsbrl0.execute-api.us-east-1.amazonaws.com/health

La ruta raíz / no fue creada y puede devolver 404. No pegues en el campo API una dirección con ?utm_source=chatgpt.com o /health; el frontend ahora elimina estos sufijos automáticamente.

## Pasos rápidos

1. Abrí Chrome o Safari **fuera del navegador integrado de ChatGPT**.
2. Comprobá la URL /health anterior. Debería devolver JSON con ok:true.
3. Desde la Mac: git pull --ff-only origin main.
4. En la raíz del repo: python3 -m http.server 8000.
5. Abrí http://localhost:8000/#18 en ese navegador.
6. Elegí AWS REAL, pegá la URL base y presioná GET /health.

## Comprobación HTTP de CORS

```bash
BASE="https://zgpedsbrl0.execute-api.us-east-1.amazonaws.com"
curl -i -H 'Origin: http://localhost:8000' "$BASE/health"

curl -i -X OPTIONS "$BASE/registrations" \
  -H 'Origin: http://localhost:8000' \
  -H 'Access-Control-Request-Method: POST' \
  -H 'Access-Control-Request-Headers: content-type'
```

En la PoC pública se espera Access-Control-Allow-Origin: * en respuestas con Origin. Para OPTIONS también se esperan los métodos y headers permitidos. CORS no es autenticación.

## Si persiste el error

Abrí DevTools → Network y Console. Identificá la solicitud /health y examiná los errores:

- blocked by CORS policy: revisar encabezados y preflight.
- ERR_NAME_NOT_RESOLVED o ERR_CONNECTION: revisar DNS, red, URL y proxies.
- ERR_BLOCKED_BY_CLIENT o Content Security Policy: puede haber restricciones del navegador integrado; usar Chrome o Safari externo.
- 404: la ruta correcta es /health. La raíz / no está implementada.
- 403: revisar gateway y autorizaciones del lab.
- Failed to fetch genérico: compartir el mensaje de consola y la URL solicitada, **nunca credenciales**.

El workflow Terraform ahora verificará CORS y escribirá la URL del servicio en el resumen del job sin intentar ejecutar la URL como un comando.

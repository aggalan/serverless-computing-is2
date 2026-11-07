# Validación técnica de la entrega

- Presentación: 19 diapositivas, marco fijo 1920×1080, estética Cloud / Impulse, teoría vendor-neutral 1–11, vendors 12, AWS 13–14, demo 15–19.
- Guion: total 600 s teoría + 300 s demo = 900 s.
- Modo SIM probado en Chromium (mediante inyección de HTML por restricciones del sandbox): GET health HTTP 200, POST inicial HTTP 201, POST repetido HTTP 200 duplicate=true, ráfaga 12/12, 0 errores de JavaScript.
- Backend: 6/6 tests locales pasaron con FakeTable (sin credenciales AWS).
- YAML: estructura sintáctica parseada; contiene API Gateway HTTP API con CORS y límites, Lambda con IAM acotado, DynamoDB on-demand.
- **No desplegado en AWS**. La validación integrada con API Gateway real requiere que el grupo ejecute `sam deploy` en su cuenta. No se atribuyen cifras de rendimiento o logs reales sin esa ejecución.
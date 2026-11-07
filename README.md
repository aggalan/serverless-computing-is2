# Serverless Computing — Ingeniería de Software II · ITBA

Trabajo práctico del segundo cuatrimestre de 2026. Presentación HTML **interactiva** de 19 diapositivas para una exposición de **15 minutos**: 10 minutos de fundamentos y decisiones arquitectónicas, más 5 minutos de prueba de concepto. La explicación empieza **sin vendor**, compara alternativas y luego utiliza AWS como caso concreto.

## Contenido

| Archivo | Descripción |
| --- | --- |
| [index.html](index.html) | Presentación 16:9, theme Cloud / Impulse, con botones de demo |
| [aws-demo/template.yaml](aws-demo/template.yaml) | AWS SAM: HTTP API Gateway, Lambda, DynamoDB e IAM |
| [aws-demo/src/app.py](aws-demo/src/app.py) | Backend Python de inscripciones con idempotencia |
| [aws-demo/tests/test_app.py](aws-demo/tests/test_app.py) | Seis pruebas unitarias |
| [docs/GUIA_AWS.md](docs/GUIA_AWS.md) | Despliegue, conexión, observabilidad y limpieza |
| [docs/GUION.md](docs/GUION.md) | Guion y tiempos de exposición |
| [docs/FUENTES.md](docs/FUENTES.md) | Bibliografía |
| [docs/VALIDACION.md](docs/VALIDACION.md) | Pruebas realizadas y limitaciones |

## Abrir la presentación

Clonar el repositorio y ejecutar un servidor HTTP local:

```bash
git clone https://github.com/aggalan/serverless-computing-is2.git
cd serverless-computing-is2
python3 -m http.server 8000
```

Abrir **http://localhost:8000**. Navegar con flechas o espacio. Las diapositivas 15–19 contienen la demo interactiva.

## Demo: dos modos

- **SIMULACIÓN**: funciona directamente en el navegador, sin AWS. Permite registrar participantes ficticios, listar, repetir un identificador para mostrar idempotencia, provocar un conflicto 409 y ejecutar una ráfaga controlada.
- **AWS REAL**: los mismos botones invocan una API desplegada con API Gateway y Lambda, que persiste datos en DynamoDB. En la diapositiva 15 seleccionar AWS REAL y pegar el `ApiUrl` devuelto por el despliegue.

Los resultados de la simulación **no son métricas de AWS**, y una prueba breve de 12 solicitudes no prueba escalabilidad ilimitada.

## Desplegar en AWS

Requisitos: cuenta con permisos apropiados, AWS CLI configurada y AWS SAM CLI.

```bash
aws sts get-caller-identity
cd aws-demo
sam build
sam deploy --guided
```

Elegir un stack como `itba-serverless-demo` y la región `us-east-1`. Revisar los recursos y permisos antes de confirmar. En CloudFormation → Outputs, copiar `ApiUrl` y pegarla en la presentación.

Seguir [la guía paso a paso](docs/GUIA_AWS.md).

## Tests

```bash
python3 -m pip install -r requirements-dev.txt
bash scripts/check.sh
```

## Seguridad y limpieza

La API es **pública y deliberadamente sin autenticación** para una demostración educativa breve. No cargar datos personales ni utilizarla en producción. CORS **no es autenticación**. Se pueden generar cargos por los servicios AWS; eliminar el stack al terminar:

```bash
sam delete --stack-name itba-serverless-demo --region us-east-1
```

## Alcance

El repo contiene todos los archivos de texto necesarios para la presentación web y el backend AWS. El PDF y las imágenes de respaldo pueden obtenerse por separado del paquete ZIP original compartido en el chat.

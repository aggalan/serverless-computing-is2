# Cómo conectar la demo interactiva con AWS

## Qué se va a crear

```text
Presentación HTML (botones GET y POST)
               |
               | HTTPS / JSON
               v
       Amazon API Gateway (HTTP API)
               |
               v
         AWS Lambda (Python 3.12)
               |
               v
        DynamoDB (on-demand)

CloudWatch: logs, invocaciones, duración, errores.
AWS SAM + CloudFormation: crean todos estos recursos.
```

**La presentación no utiliza claves AWS**, sólo la URL pública de API Gateway. **La API estará abierta durante la demo**: no enviar datos privados, mantener la PoC temporal y eliminarla al terminar. CORS permite la llamada desde el navegador, pero no proporciona autenticación.

## 1. Preparar la computadora y la cuenta

Necesitás una cuenta AWS con permisos para crear stacks de CloudFormation, funciones Lambda, tablas DynamoDB, APIs de API Gateway y roles/políticas IAM.

Instalá y configurá:

- AWS CLI v2: <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>
- AWS SAM CLI: <https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html>
- Python 3.12 local. Si no lo tenés, podés usar `sam build --use-container` con Docker funcionando.

Verificar en terminal:

```bash
aws --version
sam --version
aws sts get-caller-identity
```

Para configurar tus credenciales AWS si todavía no lo hiciste: `aws configure`, o utilizá AWS IAM Identity Center/SSO si corresponde a tu cuenta u organización. No pongas credenciales ni tokens en el HTML.

## 2. Desplegar con AWS SAM

Abrí una terminal **en la carpeta `aws-demo/` de este proyecto**:

```bash
cd aws-demo
sam build
sam deploy --guided
```

En el asistente elegí:

- Stack Name: `itba-serverless-demo`
- AWS Region: `us-east-1` (pueden elegir otra si la cuenta lo permite)
- Confirm changes before deploy: `Y`
- Allow SAM CLI IAM role creation: `Y`
- Disable rollback: `N`
- Save arguments to samconfig.toml: `Y`

Revisá los recursos que crea el stack y confirmá el despliegue. SAM necesita autorización para crear recursos facturables y políticas IAM.

Cuando termine, buscá en **CloudFormation → Stacks → itba-serverless-demo → Outputs**:

- `ApiUrl`: la URL HTTPS para pegar en las diapositivas.
- `LambdaFunction`: nombre de la función para abrir CloudWatch.
- `DynamoTable`: nombre de la tabla para revisar los registros.

También podés obtenerlos por CLI:

```bash
aws cloudformation describe-stacks \
  --stack-name itba-serverless-demo \
  --region us-east-1 \
  --query 'Stacks[0].Outputs' --output table
```

El stack provisiona automáticamente lo necesario. No hace falta crear manualmente API Gateway, Lambda, DynamoDB, los eventos HTTP, permisos IAM o CORS.

## 3. Probar antes de abrir la presentación

Reemplazá el valor de `API_URL` con el output exacto `ApiUrl`, sin barra final.

```bash
API_URL='https://REEMPLAZAR.execute-api.us-east-1.amazonaws.com'

curl -i "$API_URL/health"

curl -i -X POST "$API_URL/registrations" \
  -H 'content-type: application/json' \
  -d '{"request_id":"prueba-00000001","name":"Ada Lovelace"}'

# Repetir el POST exactamente igual: se espera HTTP 200 + duplicate:true.
curl -i -X POST "$API_URL/registrations" \
  -H 'content-type: application/json' \
  -d '{"request_id":"prueba-00000001","name":"Ada Lovelace"}'

curl -i "$API_URL/registrations"
```

Resultados esperados (con el mismo request ID): `GET /health` → 200; primer POST → 201; segundo POST → 200 y `duplicate:true`; GET listado → 200 con registros. Si usás otra vez la misma clave con un nombre distinto, se espera 409. Los tiempos reales dependen de la red y la cuenta; no hay métricas preinventadas.

## 4. Conectar los botones HTML

1. Abrí `index.html` en Chrome. Recomendado: desde la carpeta del proyecto ejecutá `python3 -m http.server 8000`, y abrí <http://localhost:8000/index.html#15>. También podés abrir el archivo local, aunque usar HTTP local es más predecible.
2. En la **diapositiva 15** elegí `AWS REAL — API Gateway + Lambda`.
3. Pegá la URL completa `ApiUrl` y pulsá **GET /health**. Debería aparecer una respuesta con `"mode":"aws"`.
4. Avanzá a la 16: **POST registrar**, **GET listado**.
5. En la 17: **POST repetir ID**; debe devolver `duplicate:true`. El botón **Forzar 409** muestra una clave reaprovechada con datos distintos.
6. En la 18: **Ejecutar ráfaga** (12 requests, lotes de cuatro); se muestran HTTP y round-trip del navegador. No es un benchmark.
7. En la 19: **Abrir CloudWatch**, buscar el grupo `/aws/lambda/<LambdaFunction>` y ver invocaciones y logs. Las métricas agregadas pueden aparecer con retraso.

Si falla la conexión, seleccioná `SIMULACIÓN — sin AWS`: se ejecuta la misma lógica en la memoria del navegador y queda claramente identificada, **pero no genera logs ni consume AWS**.

## 5. Qué recursos observar en AWS

- **API Gateway → APIs**: las rutas `GET /health`, `GET /registrations`, `POST /registrations`. CORS habilitado para la demo.
- **Lambda → Functions**: la función con handler `app.lambda_handler`, entorno Python 3.12 y un límite de concurrencia reservada de 8.
- **DynamoDB → Tables**: tabla on-demand con partition key `registration_id`. El `PutItem` condicional asegura que no se sobrescriba un ID existente.
- **CloudWatch → Log groups**: logs de Lambda. En sus métricas: `Invocations`, `Duration`, `Errors`, `Throttles` cuando corresponda.
- **CloudFormation → Stacks**: recursos declarados y outputs de AWS SAM.

## 6. Advertencias operativas y seguridad

- **NO es una API de producción**: no tiene autenticación ni cuotas de uso por identidad. El frontend no lleva credenciales y cualquiera que conozca la URL puede invocarla durante el despliegue.
- Se establecieron límites básicos: **15 solicitudes/s** y burst **30** para la API; **8 ejecuciones concurrentes** de Lambda. Estos límites reducen abuso accidental, pero no sustituyen un mecanismo de seguridad.
- **CORS `*` no es un mecanismo de control de acceso**. Sólo facilita la demo desde distintos orígenes locales.
- DynamoDB es on-demand y la Lambda se factura por uso; API Gateway, CloudWatch y otros servicios también pueden generar costos. Revisar [AWS Pricing Calculator](https://calculator.aws/), configurar AWS Budgets si corresponde y no dejar el stack expuesto indefinidamente.
- `GET /registrations` usa `Scan` limitado a 50 elementos: es suficiente para la PoC, pero no sería el diseño de consulta recomendado para producción.
- La gráfica de 12 requests mide la experiencia de llamada desde el navegador (**RTT**), no la latencia p95/p99 de Lambda ni escalabilidad sostenida.

## 7. Eliminar recursos al finalizar

Después de exponer y cuando ya no necesiten los registros de prueba:

```bash
cd aws-demo
sam delete --stack-name itba-serverless-demo --region us-east-1
```

Confirmá la eliminación en **CloudFormation**. El borrado destruye la tabla y elimina sus registros; no se puede recuperar la demo desde ese stack. Revisá también que no queden recursos asociados o archivos temporales en S3 creados durante el despliegue.

## Si hay problemas

- **Network/CORS desde HTML**: confirmá que pegaste `ApiUrl` y no el ARN ni la consola de Lambda. Probá `/health` primero con `curl`; verificá en API Gateway la configuración CORS y el stage `$default`.
- **HTTP 403/404**: verificá región, ruta, despliegue y URL. No agregues `/Prod` ni otro stage a la URL `$default`.
- **HTTP 503**: revisar los logs de la función y permisos IAM sobre DynamoDB.
- **HTTP 429**: throttling de API Gateway o Lambda. Reducí la carga y volvé a probar.
- **SAM no encuentra Python 3.12**: instalalo o ejecutá `sam build --use-container` con Docker en marcha.
- **Para volver a deployar**: `sam build && sam deploy` desde `aws-demo/` (si guardaste la configuración).

Fuentes oficiales: [API Gateway CORS](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-cors.html), [SAM HTTP API](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-httpapi.html), [DynamoDB conditional expressions](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ConditionExpressions.html).

## Opción adicional para AWS Academy: Terraform (sin crear roles IAM)

La alternativa SAM descrita arriba puede fallar en AWS Academy Learner Lab porque intenta crear un rol IAM. Para ese entorno se agregó un módulo Terraform que **reutiliza el rol existente `LabRole`**, además de un pipeline GitHub Actions opcional y un diagrama editable.

Ver [guía de despliegue con Terraform en AWS Academy](DESPLIEGUE_TERRAFORM_ACADEMY.md) y [diagrama draw.io](arquitectura-aws.drawio). No aplicar SAM y Terraform sobre los mismos recursos, y eliminar lo desplegado al terminar.

# Desplegar la demo en AWS Academy con Terraform

> Estado: infraestructura preparada como código, **no desplegada** en una cuenta AWS. Validar los permisos de tu Learner Lab: varían según curso, región y docente.

## Qué se despliega

![Arquitectura AWS](arquitectura-aws.svg)

Abrí y editá el archivo [arquitectura-aws.drawio](arquitectura-aws.drawio) en [diagrams.net](https://app.diagrams.net/).

- Presentación HTML local: envía GET y POST.
- API Gateway HTTP API: recibe `GET /health`, `POST /registrations` y `GET /registrations`.
- AWS Lambda Python 3.12: procesa solicitudes e implementa idempotencia.
- DynamoDB on-demand: guarda inscripciones por `registration_id`.
- CloudWatch Logs: contiene los logs de Lambda, con retención de 3 días.
- IAM: Terraform referencia un rol **existente**, por defecto `LabRole`; no crea roles ni políticas.

El endpoint es **público y sin autenticación**, únicamente para demo con datos ficticios. CORS `*` permite la llamada desde el navegador, pero no protege la API. Revisar costos y eliminar los recursos al terminar.

## Opción A: AWS Academy Learner Lab, recomendada (despliegue desde Mac)

### 1. Iniciar sesión de AWS Academy

En el portal de AWS Academy Learner Lab:

1. `Start Lab` y verificar que el laboratorio esté activo.
2. En `AWS Details → AWS CLI → Show`, copiar las **tres credenciales temporales**.
3. En la Mac, guardarlas en `~/.aws/credentials` con perfil `itba-academy`. **Nunca** en el repositorio, issues, chat, capturas, workflows ni scripts.

Ejemplo de estructura (reemplazar los valores con las credenciales del lab, sin publicarlas):

```ini
[itba-academy]
aws_access_key_id = TU_ID_TEMPORAL
aws_secret_access_key = TU_CLAVE_TEMPORAL
aws_session_token = TU_TOKEN_TEMPORAL
```

```bash
chmod 600 ~/.aws/credentials
export AWS_PROFILE=itba-academy
export AWS_REGION=us-east-1
aws sts get-caller-identity
```

Si expiran, obtené nuevas credenciales desde Academy; **no son permanentes**. Verificá las regiones habilitadas en el Readme del lab.

### 2. Instalar herramientas

- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform CLI >=1.10](https://developer.hashicorp.com/terraform/install)
- `python3` y `curl`, normalmente disponibles en macOS.

### 3. Clonar y validar el código

```bash
git clone https://github.com/aggalan/serverless-computing-is2.git
cd serverless-computing-is2
python3 -m pip install -r requirements-dev.txt
python3 -m unittest discover -s aws-demo/tests -v
```

### 4. Provisionar recursos

```bash
export AWS_PROFILE=itba-academy
export AWS_REGION=us-east-1
bash aws-demo/scripts/deploy-academy.sh
```

El script hace `aws sts get-caller-identity`, `terraform init`, `terraform plan`, `terraform apply`, muestra `api_url` y consulta `GET /health`. No guarda secretos.

También podés hacerlo manualmente:

```bash
cd aws-demo/terraform
terraform init
terraform plan
terraform apply
terraform output -raw api_url
```

Terraform genera `lambda.zip` desde `aws-demo/src/app.py`. No hace falta hacer `pip install boto3` dentro del ZIP porque la runtime AWS Python lo incluye en esta PoC.

**Atención a IAM:** el módulo utiliza `arn:aws:iam::<account-id>:role/LabRole`, calculado automáticamente con el ID de la cuenta activa. Si tu entorno tiene otro rol, cambialo con `-var="lambda_role_name=OTRO"` o `lambda_execution_role_arn`. El rol debe permitir el acceso requerido a DynamoDB y CloudWatch. El usuario del lab debe poder crear Lambda, DynamoDB, API Gateway, CloudWatch y ejecutar `iam:PassRole` sobre el rol seleccionado. Algunos Learner Labs prohíben parte de estas acciones: **si falla por permisos, no se resuelve modificando el código**; habrá que usar un rol autorizado o pedirlo al docente.

No apliques el stack SAM y Terraform sobre los mismos nombres/recursos: son **dos alternativas de despliegue**. Este módulo usa `-tf` en el nombre para evitar colisiones.

### 5. Conectar la presentación

```bash
python3 -m http.server 8000
```

Abrí <http://localhost:8000> y andá a la **diapositiva 18**. Elegí `AWS REAL`, pegá exactamente el `api_url` de Terraform, y presioná `GET /health`. Luego probá registrar, listar, repetir el mismo ID y la ráfaga.

Otra prueba por terminal:

```bash
cd aws-demo/terraform
URL=$(terraform output -raw api_url)
curl -fsS "$URL/health"
curl -fsS -X POST "$URL/registrations" -H 'Content-Type: application/json' \
  -d '{"request_id":"demo-test-00001","name":"Ada"}'
curl -fsS "$URL/registrations"
```

Para observabilidad, abrí CloudWatch → Logs → Log groups → `/aws/lambda/itba-serverless-demo-tf-api`. Las métricas agregadas pueden demorar en aparecer.

### 6. Eliminar recursos

Después de la exposición, y antes de que venzan las credenciales:

```bash
cd aws-demo/terraform
terraform destroy
```

La tabla DynamoDB también se elimina (se perderán las inscripciones ficticias). Si la sesión ya venció, renová credenciales y ejecutá `destroy`. **No borres el archivo de estado local antes de destruir**.

## Opción B: pipeline GitHub Actions (preparado; activar explícitamente)

Hay dos workflows:

- `.github/workflows/ci.yml`: corre automáticamente en push/PR, ejecuta tests y `terraform validate`, **sin recursos AWS**.
- `.github/workflows/deploy-aws.yml`: permite `plan`, `apply` y `destroy` desde Actions; por defecto sólo corre manualmente desde `Actions → Terraform deploy (explicit opt-in) → Run workflow`. Para habilitar deploy en cada push a `main`, configurar la variable `AUTO_DEPLOY=true`; **no hacerlo en Learner Lab sin comprender expiración de credenciales y costos**.

### Requisito previo importante: estado remoto

GitHub-hosted runners son efímeros. Sin estado remoto, cada ejecución perdería el Terraform state y el próximo apply intentaría crear recursos que ya existen. Por eso el workflow **requiere** un bucket S3 privado preexistente y usa un estado cifrado en S3 con bloqueo nativo (`use_lockfile=true`). El bucket no lo crea el propio Terraform porque debe existir antes de inicializar el backend.

En la cuenta AWS adecuada, crear el bucket una sola vez. Para `us-east-1`:

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET="itba-serverless-tfstate-$ACCOUNT_ID"
aws s3api create-bucket --bucket "$BUCKET" --region us-east-1
aws s3api put-public-access-block --bucket "$BUCKET" \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

Habilitar versioning en el bucket si el lab lo permite. Si tu región no es `us-east-1`, crearlo con el LocationConstraint correcto. Confirmar que hay permisos S3 de lectura/escritura/borrado del lockfile. No compartas este bucket con datos públicos.

### Configuración en GitHub

En el repo privado → Settings → Secrets and variables → Actions:

**Variables (Repository variables):**

- `AWS_REGION`: por ejemplo `us-east-1`.
- `TF_STATE_BUCKET`: nombre del bucket S3 privado de estado.
- `LAMBDA_ROLE_NAME`: `LabRole` para Learner Lab (valor por defecto).
- `AUTO_DEPLOY`: inicialmente `false`.
- `AWS_DEPLOY_ROLE_ARN`: opcional para una cuenta AWS estándar con OIDC.
- `LAMBDA_EXECUTION_ROLE_ARN`: opcional para otra cuenta sin LabRole.

**Secrets (Repository o Environment secrets, nunca en el código):**

Para Learner Lab, **sólo si necesitás probar el workflow durante una sesión activa**, cargar `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` y `AWS_SESSION_TOKEN` del lab. Estos secretos contienen una **sesión temporal**; caducan, hay que renovarlos antes de cada despliegue, y no permiten automatización persistente. Evitá darles acceso a workflows de forks o branches no confiables.

**Mejor para una cuenta AWS estándar:** crear un Identity Provider OIDC de GitHub y un IAM deploy role acotado al repositorio y branch `main`, con permisos mínimos para los recursos y el bucket S3. Configurar `AWS_DEPLOY_ROLE_ARN` y no guardar claves. En Learner Lab suele no ser posible crear ese proveedor/rol por las restricciones IAM.

En el workflow manual elegir `plan` para revisar recursos; después `apply` para crearlos; al terminar, `destroy`. El workflow muestra `api_url` en el resumen del job.

### No mezclar Terraform local y workflow sin migrar state

Si ya aplicaste con estado local, el workflow con estado S3 **no reconoce** esos recursos y puede fallar por duplicados. Migrar el estado primero o destruir localmente antes de usar GitHub Actions. Para migrar:

1. Crear bucket S3.
2. Copiar `aws-demo/terraform/backend.s3.tf.example` a `aws-demo/terraform/backend.tf` (está en gitignore).
3. Ejecutar `terraform init -migrate-state` con el mismo bucket, región, key `serverless-computing-is2/demo/terraform.tfstate`, cifrado y `use_lockfile=true`.
4. Verificar `terraform plan` sin cambios antes de usar el workflow.

**Nunca subas archivos `*.tfstate` a GitHub**, pueden contener datos sensibles.

## Problemas frecuentes

| Síntoma | Causa probable | Qué hacer |
| --- | --- | --- |
| `ExpiredToken` o `InvalidClientTokenId` | Sesión AWS Academy vencida | Renovar las 3 credenciales de CLI |
| `iam:PassRole` o `AccessDenied` | Restricciones Learner Lab / rol incorrecto | Revisar rol y permisos del laboratorio |
| `ResourceNotFoundException` DynamoDB | LabRole no tiene acceso o tabla equivocada | Verificar variables Lambda y permisos DynamoDB |
| CORS bloqueado en navegador | URL incorrecta o configuración preflight | Pegar `api_url` sin rutas, revisar HTTP API |
| `terraform init` no encuentra state bucket | No existe, región incorrecta o permisos S3 | Verificar bucket y acceso AWS |
| `AlreadyExists` en Terraform | SAM previo o state local/remoto mezclado | Identificar recurso; no borrar state a ciegas |
| GitHub Actions falla tras varias horas | Credenciales de Academy temporales | Actualizar secrets o usar despliegue local |

## Fuentes técnicas

- [AWS Academy Learner Lab: restricciones y LabRole (AWS Builder Center)](https://builder.aws.com/content/32E1EQtdsojEIqMZ4haf7CYLBuE/teaching-ai-agent-to-work-inside-aws-academy-learner-lab)
- [Terraform + API Gateway + Lambda (HashiCorp)](https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway)
- [Backend S3 con bloqueo nativo (HashiCorp)](https://developer.hashicorp.com/terraform/language/backend/s3)
- [GitHub Actions OIDC con AWS](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws)
- [Credenciales temporales AWS (IAM)](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_use-resources.html)

# Fuentes para la presentación — Serverless Computing

## Conceptos generales (sin proveedores)
- CNCF Serverless Working Group, whitepaper completo v1.0 (definición, responsabilidades, FaaS/BaaS y trade-offs; diapositivas 3–14): <https://github.com/cncf/wg-serverless/blob/master/whitepapers/serverless-overview/cncf_serverless_whitepaper_v1.0.pdf>
- CNCF, anuncio y resumen histórico del whitepaper: <https://www.cncf.io/blog/2018/02/14/cncf-takes-first-step-towards-serverless-computing/>
- CNCF, empaquetado y portabilidad: <https://www.cncf.io/blog/2018/12/04/serverless-application-packaging/>
- Microsoft Learn, responsabilidad compartida en la nube (frontera entre proveedor y equipo; diapositiva 3): <https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility>
- Microsoft Azure, definición general de serverless y gestión de infraestructura: <https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-serverless-computing>
- Google Cloud Run, plataforma serverless para servicios, jobs y aplicaciones en contenedores (diapositiva 4): <https://docs.cloud.google.com/run/docs>

## Ampliación: cómputo serverless más allá de funciones (diapositivas 4, 5 y 13)
- CNCF Cloud Native Glossary, Serverless (modelo amplio y diferencia respecto de FaaS): <https://glossary.cncf.io/serverless/>
- Google Cloud Run, recursos y modalidades: servicios, jobs, worker pools e instancias (evidencia de diversidad de ciclos): <https://docs.cloud.google.com/run/docs/overview/what-is-cloud-run>
- Azure Container Apps Jobs, trabajos finitos versus apps/servicios: <https://learn.microsoft.com/en-us/azure/container-apps/jobs>
- Knative Serving, autoscaling y scale-to-zero configurable para aplicaciones containerizadas en Kubernetes: <https://knative.dev/docs/serving/configuring-autoscaling/>
- AWS Decision Guide, Fargate versus Lambda (2026, comparativa de modelos de cómputo): <https://docs.aws.amazon.com/decision-guides/latest/decision-guides/fargate-or-lambda.html>
- AWS Decision Guide, catálogo más amplio de compute, API, integración y almacenamiento: <https://docs.aws.amazon.com/decision-guides/latest/decision-guides/choosing-aws-serverless-service.html>

## Proceso de ejecución y vendor lock-in (diapositivas 5 y 11)
- CNCF, artículo de invitado de Yoav Landman (4/12/2018), *The Function Package*: identifica dependencias directas versus dependencias del runtime, falta de formato compartido de empaquetado FaaS en ese momento y costos de migración. Es una propuesta del autor, no un estándar oficialmente adoptado: <https://www.cncf.io/blog/2018/12/04/serverless-application-packaging/>
- CNCF, anuncio histórico del Serverless Whitepaper (14/2/2018): falta de estandarización, necesidad de interoperabilidad entre proveedores: <https://www.cncf.io/blog/2018/02/14/cncf-takes-first-step-towards-serverless-computing/>
- CloudEvents, proyecto graduado CNCF: especificación abierta de datos de eventos que ayuda a su interoperabilidad, no reemplaza IAM, APIs ni datos específicos del proveedor: <https://cloudevents.io/>
- CNCF, artículo de invitado (28/1/2022), serverless pros/cons y vendor lock-in como riesgo de negocio: <https://www.cncf.io/blog/2022/01/28/serverless-architecture-pros-and-cons/>

## Panorama de proveedores (diapositiva 15)
- AWS Lambda: <https://docs.aws.amazon.com/lambda/latest/dg/>
- Microsoft Azure Functions: <https://learn.microsoft.com/en-us/azure/azure-functions/>
- Google Cloud Run functions: <https://docs.cloud.google.com/functions/docs>
- Cloudflare Workers: <https://developers.cloudflare.com/workers/>

## Implementación particular AWS y demo
- Ciclo de vida del entorno de ejecución, reutilización y cold starts en AWS Lambda (respaldo específico para la diapositiva 7, no definición universal de FaaS): <https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtime-environment.html>
- Escalado y concurrencia en AWS Lambda (respaldo específico para la diapositiva 7): <https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html>
- SAM HTTP API: <https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-httpapi.html>
- SAM CORS HTTP API: <https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-httpapi-httpapicorsconfiguration.html>
- Configuración de CORS de API Gateway: <https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-cors.html>
- DynamoDB ConditionExpressions: <https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.ConditionExpressions.html>
- Lambda monitoring: <https://docs.aws.amazon.com/lambda/latest/dg/lambda-monitoring.html>
- Lambda concurrency: <https://docs.aws.amazon.com/lambda/latest/dg/configuration-concurrency.html>
- AWS SAM CLI instalación: <https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html>
- AWS Pricing Calculator: <https://calculator.aws/>

**Criterio metodológico:** la teoría no usa productos como definición. AWS se presenta sólo como ejemplo de implementación y la PoC se conecta a servicios reales únicamente después de desplegar el stack en la cuenta del grupo.

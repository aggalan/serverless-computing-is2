# Guion de exposición — Serverless Computing (v4)

**Presentación:** 19 diapositivas, 10:00 de explicación + 5:00 de demo.

**Estructura:** 1–11 conceptos generales sin vendors; 12 comparación de proveedores; 13–14 AWS como caso particular; 15–19 demostración interactiva conectable a AWS.

**Antes de la clase:** desplegar stack AWS SAM, copiar `ApiUrl`, verificar `GET /health` y `POST /registrations` desde el navegador. En simulación se puede ensayar sin AWS, pero no es la demostración real.

## 01. Portada — 00:20 (acum. 00:20)

Abrimos con la definición de Serverless Computing como modelo de abstracción de infraestructura. La exposición se divide deliberadamente: primero teoría completamente independiente de proveedores, después un panorama comparado de vendors y finalmente AWS como caso concreto para la prueba de concepto. La cátedra exige justificar decisiones de arquitectura y atributos de calidad.

## 02. Capacidad fija, demanda variable. — 00:35 (acum. 00:55)

Presentar el patrón de carga variable como motivación, sin nombrar nube comercial alguna. La infraestructura fija exige un equilibrio entre costo de capacidad ociosa y riesgo ante picos. Serverless ofrece escalado y aprovisionamiento gestionado, pero hay límites y otras fuentes de costo. El gráfico es ilustrativo.

## 03. Serverless no significa «sin servidores». — 00:35 (acum. 01:30)

Definición apoyada en CNCF. No desaparecen los servidores ni la responsabilidad de ingeniería: cambia la frontera de operaciones. Evitar confundir serverless con gratuidad, ausencia de administración o universalmente coste efectivo.

## 04. Tres formas de construir sin gestionar servidores. — 00:40 (acum. 02:10)

Explicar FaaS (la plataforma invoca funciones), BaaS (backend administrado) y contenedores serverless (abstracción del host pero empaquetado como contenedor). Esta es una distinción conceptual, no nombres de productos. La cátedra debe ver investigación más allá de Lambda.

## 05. Event-driven: la ejecución nace del evento. — 00:45 (acum. 02:55)

El modelo orientado a eventos es muy frecuente en FaaS pero no es obligatorio para todas las modalidades serverless. Distinguir invocación sincrónica de entrega asíncrona; la segunda puede tener reintentos, duplicados o llegada fuera de orden según contrato del emisor. Disparadores temporizados también son posibles.

## 06. Arquitectura de referencia, independiente del vendor. — 00:40 (acum. 03:35)

Esta es la arquitectura genérica: productor de eventos, punto de entrada, función y persistencia externa. No es una receta única: una función puede dispararse directamente desde storage sin gateway. Explicar atributos transversales: seguridad, observabilidad y resiliencia. Es un patrón abstracto para evitar mezclar teoría con proveedores.

## 07. El runtime escala; la latencia cambia. — 00:50 (acum. 04:25)

Explicar ciclo de vida genérico en FaaS: init, invocación, posible reutilización y nuevos entornos para concurrencia. Cold start ocurre cuando se requiere entorno nuevo, y no afecta igual a todos los proveedores o planes. El escalado puede ser muy rápido pero no infinito; dependen cuotas, memoria, downstream y concurrencia.

## 08. El estado persiste fuera de la función. — 00:40 (acum. 05:05)

Las funciones deben tratarse como efímeras desde el punto de vista de persistencia: no confiar en RAM ni filesystem temporal para estado compartido. Idempotencia significa que repetir una operación no duplica su efecto observable, no que haya una única invocación. Según el mecanismo de entrega puede haber duplicados y reordenamiento.

## 09. La arquitectura cambia los atributos de calidad. — 01:00 (acum. 06:05)

Esta diapositiva responde explícitamente a los atributos de calidad exigidos por la cátedra. No confundir escalabilidad con disponibilidad, y no prometer performance determinista. Seguridad es responsabilidad compartida: la plataforma administra parte del runtime, el equipo diseña permisos y protege datos. En mantenibilidad se cambia patching de hosts por integración distribuida.

## 10. Comparar alternativas antes de elegir. — 00:50 (acum. 06:55)

Comparar patrones arquitectónicos, no marcas. VM: control, cargas largas, mayor operación. Contenedor administrado: empaquetado portable y servidores gestionados, aunque la facturación varía por plan y configuración. FaaS: apropiado para tareas event-driven intermitentes, con límites de ejecución y latencia. Decisión por SLO, TCO, habilidades del equipo y volumen real.

## 11. Costo por uso no implica menor costo total. — 00:40 (acum. 07:35)

Presentar una fórmula conceptual deliberadamente sin tarifas ni nombres de proveedores. Pagar por uso puede ahorrar en cargas intermitentes, pero event ingress, almacenamiento, transferencia, logs, personal y reservas pueden dominar el TCO. El punto no es demostrar cuál es universalmente más barato, sino qué variables afectan la decisión.

## 12. Un modelo. Distintos proveedores. — 01:00 (acum. 08:35)

Recién acá aparecen los vendors. AWS Lambda, Azure Functions, Google Cloud Run functions y Cloudflare Workers son opciones comerciales del enfoque. No igualar runtimes de edge Workers a procesos tradicionales ni prometer equivalencia idéntica. Cómo elegir: integraciones existentes, región, costos, compliance, latencia, lock-in y experiencia del equipo. Fuentes oficiales actualizadas en Fuentes.

## 13. AWS: del patrón abstracto a servicios reales. — 00:45 (acum. 09:20)

Primera diapositiva de AWS. Ahora el ejemplo real es HTTP API Gateway → Lambda → DynamoDB + CloudWatch, no S3. Mostrar responsabilidades y atributos: API Gateway recibe el tráfico, Lambda escala cómputo efímero, DynamoDB persiste estado e implementa unicidad mediante escritura condicional. AWS SAM es IaC. No presentar esto como definición general de Serverless; la teoría fue 100% vendor-neutral.

## 14. Por qué esta arquitectura para la demo. — 00:40 (acum. 10:00)

Comparativa de decisión: elegir HTTP API + Lambda porque se puede llamar desde la presentación sin cambiar de ventana; DynamoDB desacopla estado y soporta put condicional atómico para idempotencia; CloudWatch permite enseñar observabilidad. Cuatro acciones didácticas: register, list, retry y burst. No inferir que una ráfaga de 12 requests demuestra escalabilidad o performance. El endpoint está abierto sólo para demo, sin datos sensibles y se debe destruir luego.

## 15. 00 / Elegir modo y conectar el backend. — 00:30 (acum. 10:30)

Comenzamos los cinco minutos prácticos. Antes de exponer el stack debe estar desplegado en AWS. Elegir AWS REAL y pegar ApiUrl de los outputs de CloudFormation/SAM; pulsar Probar conexión. Si falla la red, SIMULACIÓN funciona completamente offline y está claramente etiquetada. No confundir ambos modos. Se explica que CORS está permitido para la PoC, pero NO es autenticación.

## 16. 01 / Invocar una función y persistir datos. — 01:15 (acum. 11:45)

Paso 1: escribir un nombre ficticio, pulsar POST /registrations y observar status 201 si es nuevo; luego GET /registrations para ver el registro persistido. El request_id es generado en el frontend y se guarda entre slides para mostrar la operación idempotente. En AWS REAL, DynamoDB almacena los datos, no la RAM de Lambda. Indicar tiempo de ida y vuelta desde navegador, no duración de Lambda.

## 17. 02 / Reintentar sin duplicar el efecto. — 01:15 (acum. 13:00)

Paso 2: con el MISMO request_id y el MISMO nombre, repetir POST. Debe devolver 200 duplicate true sin escribir otro registro. Se usa DynamoDB PutItem con ConditionExpression attribute_not_exists(registration_id), que es atómica. Mostrar el conflicto intencional con otro nombre pero igual request_id: HTTP 409. Esto no significa exactly-once, sino efecto idempotente. Si empezaron aquí sin crear el primer registro, mostrar que se requiere crear uno antes.

## 18. 03 / Cambiar la carga y observar las respuestas. — 01:15 (acum. 14:15)

Paso 3: presionar RÁFAGA CONTROLADA 12 requests distribuidos en 3 grupos de 4; observar éxitos, errores, respuestas y tiempos RTT de navegador. Aclarar que una ráfaga de este tamaño no mide escalabilidad ni garantiza latencia. En AWS REAL, Lambda puede escalar concurrentemente, sujeto a reserved concurrency y throttling; DynamoDB responde a persistencia. Opcionalmente abrir CloudWatch luego para ver invocaciones agregadas.

## 19. 04 / Verificar, observar y concluir. — 00:45 (acum. 15:00)

Último paso: mostrar que CloudWatch registra invocaciones/errores/duración del backend AWS, pero no garantizar que las métricas estén visibles inmediatamente. Clic Abrir CloudWatch abre la consola y luego se busca /aws/lambda/<nombre>. También se puede hacer GET desde la presentación para confirmar persistencia. La simulación puede limpiarse con botón. Cierre: elección de Serverless según atributos y TCO, no por moda. No confundir resultados simulados con datos reales.
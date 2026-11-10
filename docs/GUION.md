# Guion de exposición — Serverless Computing (v4)

**Presentación:** 22 diapositivas, 10:00 de explicación + 5:00 de demo.

**Estructura:** 1–14 fundamentos generales sin vendors (incluye ejecución y portabilidad); 15 proveedores; 16–17 AWS como caso particular; 18–22 demostración interactiva.

**Antes de la clase:** desplegar stack AWS SAM, copiar `ApiUrl`, verificar `GET /health` y `POST /registrations` desde el navegador. En simulación se puede ensayar sin AWS, pero no es la demostración real.

## 01. Portada — 00:20 (acum. 00:20)

Abrimos con la definición de Serverless Computing como modelo de abstracción de infraestructura. La exposición se divide deliberadamente: primero teoría completamente independiente de proveedores, después un panorama comparado de vendors y finalmente AWS como caso concreto para la prueba de concepto. La cátedra exige justificar decisiones de arquitectura y atributos de calidad.

## 02. Capacidad fija, demanda variable. — 00:30 (acum. 00:50)

Toda empresa debe decidir cuánta capacidad mantener disponible. Si reserva demasiado, paga recursos que no utiliza. Si reserva poco, un pico puede aumentar la latencia, producir errores y afectar ventas o usuarios. El gráfico contrasta demanda variable con capacidad reservada, pero es una simplificación: las VMs y los contenedores también pueden usar autoscaling. La pregunta final abre la transición hacia la diapositiva siguiente sin introducir todavía la solución: «¿Y si no tuviéramos que reservar la capacidad de antemano?». Eso no elimina la infraestructura; cambia quién la aprovisiona y administra. Ahí aparece el modelo serverless.

## 03. Serverless no significa «sin servidores». — 00:30 (acum. 01:20)

Serverless es un modelo de desarrollo y ejecución en el que el equipo despliega código o utiliza servicios sin aprovisionar ni administrar directamente los servidores subyacentes. Los servidores siguen existiendo: cambia la frontera de responsabilidad. La plataforma administra hosts, sistema operativo, aprovisionamiento y recuperación del entorno de ejecución. El equipo conserva código, datos, permisos, seguridad, observabilidad y resiliencia. Recuperar el runtime no garantiza la continuidad del negocio. La decisión reduce carga operativa a cambio de menos control directo y mayor dependencia; no implica gratuidad ni disponibilidad automática.

## 04. Tres modalidades comunes. Distintas cosas para delegar. — 00:35 (acum. 01:55)

No existe una taxonomía universal de exactamente tres formas; estas son modalidades comunes y combinables. Con FaaS desplegamos lógica propia como funciones, útil para tareas independientes y demanda irregular. Con BaaS consumimos capacidades estándar —como autenticación, datos o mensajería— para acelerar la entrega, aceptando menos control y mayor dependencia. Con contenedores serverless desplegamos una aplicación más completa y conservamos mayor control sobre frameworks y runtime sin administrar hosts. No todo servicio administrado es serverless: la decisión es qué construir, qué consumir y cuánto control delegar.

## 05. Del despliegue a la ejecución. — 00:30 (acum. 02:25)

Explicar cuatro etapas genéricas: desplegar código/imagen/job y configurar requisitos, recibir demanda de una solicitud o evento, aprovisionar o reutilizar capacidad desde la plataforma y ejecutar la carga. La ejecución no implica necesariamente una función: en servicios containerizados también puede existir capacidad mantenida activa. Equipo: lógica, datos, permisos, integraciones, objetivos de servicio. Plataforma: hosts, aprovisionamiento y capacidad según configuración. Escalar a cero o pagar sólo por invocación no son propiedades universales. Esta diapositiva se diferencia de la 4 porque habla del mecanismo, no de enumerar modalidades, y prepara el zoom en FaaS.

## 06. En FaaS, un evento activa la lógica de negocio. — 00:35 (acum. 03:00)

En FaaS, un hecho del negocio se representa como un evento que activa lógica bajo demanda. Conservamos ambas miradas: un pedido confirmado, archivo recibido o vencimiento alcanzado es el hecho; HTTP, un mensaje, un archivo o un timer es la entrada o trigger técnico. La función ejecuta solamente la lógica necesaria y produce un resultado: responder, persistir datos o emitir otro evento. Si la invocación es sincrónica, el usuario espera y pesan latencia y disponibilidad. Si es asíncrona, desacopla y absorbe picos, pero introduce reintentos, duplicados y consistencia eventual. Una ejecución programada resuelve tareas periódicas sin mantener un proceso activo. La demo usa HTTP sincrónico y después repite la solicitud para mostrar idempotencia.

## 07. La función es solo una parte de la solución. — 00:30 (acum. 03:30)

Desde la diapositiva anterior hacemos un zoom deliberado en FaaS porque es la modalidad que utiliza la demo; no afirmamos que esta arquitectura represente todo serverless. La función ejecuta una tarea acotada, pero una solución real también necesita mecanismos de entrada y coordinación, persistencia externa e integraciones que completen el proceso de negocio. La plataforma opera parte de la infraestructura, mientras el equipo todavía diseña seguridad, observabilidad y resiliencia. El patrón sigue siendo independiente del proveedor y sus componentes pueden variar según el caso.

## 08. Escalar bajo demanda puede agregar latencia. — 00:40 (acum. 04:10)

Separar dos situaciones. Si una solicitud llega después de otra, la plataforma puede reutilizar un entorno ya preparado y evitar una nueva inicialización; la reutilización no está garantizada. Si varias solicitudes llegan simultáneamente y no hay capacidad disponible, la plataforma crea entornos adicionales y algunas atraviesan INIT antes de ejecutar. Ese tiempo adicional es un cold start. Para el negocio, la ventaja es absorber picos sin reservar capacidad permanente; el trade-off es una latencia menos predecible. Mitigarla mediante capacidad preinicializada suele aumentar el costo. Es un esquema conceptual de FaaS, no una medición ni una afirmación idéntica para todos los proveedores. El escalado también está condicionado por cuotas y por la capacidad de bases de datos, APIs y otros servicios.

## 09. El estado persiste fuera de la función. — 00:35 (acum. 04:45)

Las funciones deben tratarse como efímeras desde el punto de vista de persistencia: no confiar en RAM ni filesystem temporal para estado compartido. Idempotencia significa que repetir una operación no duplica su efecto observable, no que haya una única invocación. Según el mecanismo de entrega puede haber duplicados y reordenamiento.

## 10. La arquitectura cambia los atributos de calidad. — 00:45 (acum. 05:30)

Esta diapositiva responde explícitamente a los atributos de calidad exigidos por la cátedra. Cada fila representa una oportunidad y un riesgo, no una mejora automática. Escalabilidad significa ajustar capacidad a la demanda; rendimiento describe cuánto tarda el sistema y puede beneficiarse del paralelismo, pero conserva cold starts y latencia variable. La plataforma recupera entornos de ejecución, pero el equipo todavía diseña la disponibilidad del proceso de negocio. En seguridad disminuye el parcheo de hosts y aumenta la importancia de configurar permisos, eventos y secretos. La mantenibilidad cambia operación de infraestructura por integraciones y diagnóstico distribuido. La portabilidad sólo mejora si la lógica se separa de adaptadores; APIs, triggers y servicios administrados generan dependencia del proveedor. La decisión consiste en priorizar los atributos importantes para el negocio y aceptar conscientemente los riesgos desplazados.

## 11. Vendor lock-in: el costo de abstraer. — 00:35 (acum. 06:05)

Relacionar con la fila de portabilidad de la diapositiva anterior. El artículo de invitado publicado por CNCF en 2018 identifica dos tipos de dependencias en FaaS: las directas (código, bibliotecas y archivos) y las de runtime (esquema y ruteo de eventos, variables, binarios de ejecución y servicios externos). Señalaba en ese momento la falta de un formato compartido de empaquetado de funciones, que dificultaba la portabilidad aunque el código fuera independiente. El gráfico compara lógica mezclada con APIs específicas frente a núcleo desacoplado con adaptadores para eventos y persistencia. CloudEvents provee un formato común para datos de eventos y reduce parte de ese acoplamiento, no estandariza todo el runtime ni los servicios del proveedor. Los adaptadores tienen un costo: no agregar capas innecesarias para una PoC. Recordar que nuestra demo usa SAM, API Gateway y DynamoDB; migrar obliga a adaptar despliegue, triggers, IAM, datos y observabilidad. No presentar el artículo de 2018 como descripción universal del estado actual.

## 12. Comparar alternativas antes de elegir. — 00:40 (acum. 06:45)

Comparar patrones arquitectónicos con los mismos criterios, sin recomendar uno de antemano. Una VM conviene para cargas largas o requisitos especiales y conserva control del sistema operativo, a cambio de mayor operación y planificación de capacidad. Un contenedor administrado sirve para servicios completos o de ejecución continua y conserva control sobre el empaquetado y el runtime, con costos y límites según la plataforma. FaaS encaja con tareas independientes y demanda irregular; el equipo controla la lógica y la configuración, pero acepta límites de runtime, duración y latencia. La decisión depende de los objetivos de nivel de servicio —SLO, por ejemplo disponibilidad o latencia—, el costo total de propiedad —TCO, incluyendo desarrollo y operación—, el riesgo aceptable, las capacidades del equipo y el volumen real.

## 13. Elección de la unidad de cómputo — 00:30 (acum. 07:15)

Aplicar tres escenarios de negocio: tareas breves y activadas por eventos → FaaS; microservicios o APIs con framework propio → contenedor serverless tipo servicio; ETL o procesamiento finito y a veces más prolongado → job serverless. Un job también puede correr en contenedor. La elección depende de SLO de latencia y disponibilidad, duración, recursos, necesidades de runtime, concurrencia, costos y experiencia del equipo. No confundir serverless con escala a cero universal. Después recuperamos la comparación del costo total.

## 14. Costo por uso no implica menor costo total. — 00:35 (acum. 07:50)

Presentar una fórmula conceptual deliberadamente sin tarifas ni nombres de proveedores. El precio del cómputo depende de ejecuciones, duración, recursos asignados y solicitudes o eventos facturables, pero no equivale al costo total de propiedad o TCO. Pagar por uso puede ahorrar cuando la demanda es irregular y habría capacidad ociosa pagada. Con uso constante y predecible conviene comparar contenedores o capacidad reservada. Sumar almacenamiento, transferencia, colas, observabilidad, soporte, desarrollo y operación. El costo variable también puede crecer por tráfico inesperado, reintentos, errores o exceso de logs. El punto no es demostrar cuál es universalmente más barato, sino identificar qué variables afectan la decisión.

## 15. Un modelo. Distintos proveedores. — 00:50 (acum. 08:40)

Recién acá aparecen los vendors. AWS Lambda, Azure Functions, Google Cloud Run functions y Cloudflare Workers son opciones comerciales del enfoque. No igualar runtimes de edge Workers a procesos tradicionales ni prometer equivalencia idéntica. Cómo elegir: integraciones existentes, región, costos, compliance, latencia, lock-in y experiencia del equipo. Fuentes oficiales actualizadas en Fuentes.

## 16. AWS: del patrón abstracto a servicios reales. — 00:40 (acum. 09:20)

Primera diapositiva de AWS. El ejemplo real traduce el patrón a HTTP API Gateway → Lambda → DynamoDB, con CloudWatch, IAM y AWS SAM como capacidades de soporte. API Gateway recibe el tráfico; Lambda ejecuta la lógica de negocio; DynamoDB conserva el estado y permite implementar idempotencia mediante escritura condicional; CloudWatch aporta logs y métricas; IAM limita los permisos entre servicios; SAM describe la infraestructura como código. La necesidad concreta es registrar inscripciones y evitar duplicados ante reintentos. No presentar esta arquitectura como definición general de serverless: es una implementación particular para la demo.

## 17. Por qué esta arquitectura para la demo. — 00:40 (acum. 10:00)

Comparativa de decisión: elegir HTTP API + Lambda porque se puede llamar desde la presentación sin cambiar de ventana; DynamoDB desacopla estado y soporta put condicional atómico para idempotencia; CloudWatch permite enseñar observabilidad. Cuatro acciones didácticas: register, list, retry y burst. No inferir que una ráfaga de 12 requests demuestra escalabilidad o performance. El endpoint está abierto sólo para demo, sin datos sensibles y se debe destruir luego.

## 18. 00 / Elegir modo y conectar el backend. — 00:30 (acum. 10:30)

Comenzamos los cinco minutos prácticos. Antes de exponer el stack debe estar desplegado en AWS. Elegir AWS REAL y pegar ApiUrl de los outputs de CloudFormation/SAM; pulsar Probar conexión. Si falla la red, SIMULACIÓN funciona completamente offline y está claramente etiquetada. No confundir ambos modos. Se explica que CORS está permitido para la PoC, pero NO es autenticación.

## 19. 01 / Invocar una función y persistir datos. — 01:15 (acum. 11:45)

Paso 1: escribir un nombre ficticio, pulsar POST /registrations y observar status 201 si es nuevo; luego GET /registrations para ver el registro persistido. El request_id es generado en el frontend y se guarda entre slides para mostrar la operación idempotente. En AWS REAL, DynamoDB almacena los datos, no la RAM de Lambda. Indicar tiempo de ida y vuelta desde navegador, no duración de Lambda.

## 20. 02 / Reintentar sin duplicar el efecto. — 01:15 (acum. 13:00)

Paso 2: con el MISMO request_id y el MISMO nombre, repetir POST. Debe devolver 200 duplicate true sin escribir otro registro. Se usa DynamoDB PutItem con ConditionExpression attribute_not_exists(registration_id), que es atómica. Mostrar el conflicto intencional con otro nombre pero igual request_id: HTTP 409. Esto no significa exactly-once, sino efecto idempotente. Si empezaron aquí sin crear el primer registro, mostrar que se requiere crear uno antes.

## 21. 03 / Cambiar la carga y observar las respuestas. — 01:15 (acum. 14:15)

Paso 3: presionar RÁFAGA CONTROLADA 12 requests distribuidos en 3 grupos de 4; observar éxitos, errores, respuestas y tiempos RTT de navegador. Aclarar que una ráfaga de este tamaño no mide escalabilidad ni garantiza latencia. En AWS REAL, Lambda puede escalar concurrentemente, sujeto a reserved concurrency y throttling; DynamoDB responde a persistencia. Opcionalmente abrir CloudWatch luego para ver invocaciones agregadas.

## 22. 04 / Verificar, observar y concluir. — 00:45 (acum. 15:00)

Último paso: mostrar que CloudWatch registra invocaciones/errores/duración del backend AWS, pero no garantizar que las métricas estén visibles inmediatamente. Clic Abrir CloudWatch abre la consola y luego se busca /aws/lambda/<nombre>. También se puede hacer GET desde la presentación para confirmar persistencia. La simulación puede limpiarse con botón. Cierre: elección de Serverless según atributos y TCO, no por moda. No confundir resultados simulados con datos reales.

# Registro de cambios de la presentación

Este documento registra los cambios de contenido acordados durante la revisión, junto con su motivo. Se actualiza de forma acumulativa para mantener sincronizados la presentación, el guion y la justificación de cada decisión.

## Diapositiva 02 — Capacidad fija, demanda variable

### 1. Cierre de la diapositiva

```diff
- Serverless desplaza parte de ese problema al proveedor.
+ ¿Y si no tuviéramos que reservarla de antemano?
```

**Razón:** la diapositiva 2 plantea el problema de negocio, mientras que la 3 define serverless. Nombrar la solución antes de definirla debilitaba la secuencia narrativa. La pregunta conserva el orden problema → alternativa y crea una transición directa hacia la definición.

### 2. Alcance del gráfico — revisión

```diff
- Gráfico conceptual; VMs y contenedores también pueden autoescalar.
+ Gráfico conceptual, no resultados medidos.
```

**Razón:** se conserva la aclaración de que la curva es ilustrativa y no representa resultados de una medición. La precisión sobre el autoscaling de VMs y contenedores no se muestra en la diapositiva porque, sin espacio para desarrollarla, podía parecer una contradicción con el título y distraer del dilema de negocio. Esa precisión queda en las notas y el guion, donde puede explicarse con contexto: la diferencia relevante no es que sólo serverless pueda escalar, sino cuánto aprovisionamiento y gestión de capacidad se delega al proveedor.

### 3. Notas del expositor y guion

```diff
- La infraestructura fija exige un equilibrio entre costo de capacidad ociosa y riesgo ante picos.
- Serverless ofrece escalado y aprovisionamiento gestionado, pero hay límites y otras fuentes de costo.
+ Si se reserva demasiada capacidad, se pagan recursos ociosos; si se reserva poca,
+ un pico puede aumentar la latencia, producir errores y afectar ventas o usuarios.
+ VMs y contenedores también pueden autoescalar. Serverless se presenta después como
+ una alternativa que delega una parte mayor del aprovisionamiento y la gestión de capacidad.
```

**Razón:** se explicita la consecuencia empresarial de la decisión —costo frente a degradación del servicio— y se conserva la precisión técnica. El guion conecta la pregunta final con la definición de la diapositiva 3 sin afirmar que serverless elimina todos los límites o costos.

### Archivos sincronizados

- `index.html`: texto visible y notas embebidas de la diapositiva 2.
- `docs/GUION.md`: explicación oral de la diapositiva 2.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 03 — Serverless no significa «sin servidores»

### 1. Definición

```diff
- Ejecutar servicios o funciones sin administrar directamente los servidores que los alojan,
- según la demanda y el modelo elegido.
+ Modelo de desarrollo y ejecución en el que el equipo despliega código o utiliza servicios
+ sin aprovisionar ni administrar directamente los servidores subyacentes.
```

**Razón:** la formulación nueva se alinea de manera más directa con la definición de CNCF, abarca FaaS y BaaS y evita sugerir que todos los productos serverless necesariamente escalan a cero o facturan exactamente según la demanda.

### 2. Responsabilidad ante fallas

```diff
- Parte de la tolerancia a fallos
+ Recuperación del entorno de ejecución ante fallas
```

**Razón:** «tolerancia a fallos» podía interpretarse como resiliencia completa de la aplicación. La frase nueva limita la responsabilidad de la plataforma al entorno de ejecución. La continuidad del proceso de negocio, los datos, los reintentos y la estrategia multirregión siguen siendo decisiones del equipo.

### 3. Fuentes primarias

```diff
- Enlace solamente al anuncio del whitepaper de CNCF
+ Enlace al whitepaper completo de CNCF
+ Fuente oficial sobre responsabilidad compartida
+ Fuente oficial con la definición general de serverless
```

**Razón:** el anuncio de CNCF es un resumen, no la fuente técnica completa. Se agregaron el documento original y documentación oficial que respalda la división de responsabilidades mostrada en la diapositiva.

### Archivos sincronizados

- `index.html`: definición, responsabilidad ante fallas, notas y panel de fuentes.
- `docs/GUION.md`: explicación oral y límites de la responsabilidad del proveedor.
- `docs/FUENTES.md`: whitepaper completo y fuentes de responsabilidad compartida.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 04 — Modalidades comunes

### 1. Alcance de la clasificación

```diff
- Tres formas de construir sin gestionar servidores.
+ Tres modalidades comunes. Distintas cosas para delegar.
```

**Razón:** no existe una taxonomía universal de exactamente tres formas de serverless. CNCF distingue originalmente FaaS y BaaS, mientras que las plataformas actuales también ofrecen contenedores, workflows, datos y otras capacidades serverless. El nuevo título presenta una agrupación útil sin hacerla pasar por exhaustiva.

### 2. Perspectiva de decisión

```diff
- Definiciones centradas únicamente en la tecnología y su unidad de consumo.
+ FaaS: lógica propia para tareas independientes y demanda irregular.
+ BaaS: capacidades estándar que aceleran la entrega a cambio de control y dependencia.
+ Contenedores serverless: aplicaciones completas con mayor control de runtime, sin operar hosts.
```

**Razón:** la comparación ahora ayuda a decidir qué construir, qué consumir y cuánto control delegar. También se aclara que no todo servicio administrado es serverless.

### 3. Etiquetas comparables y énfasis visual

```diff
- Unidad: invocación
- Unidad: servicio / consumo
- Unidad: instancia / recursos
+ Desplegás: una función
+ Consumís: una capacidad
+ Desplegás: una aplicación
```

**Razón:** las etiquetas anteriores mezclaban facturación, abstracción y recursos. Las nuevas responden la misma pregunta en los tres casos. También se quitó el resaltado exclusivo de la etiqueta FaaS porque no tenía una explicación conceptual y podía sugerir que era una opción superior.

### 4. Composición

```diff
- No todos los servicios «serverless» comparten modelo de facturación,
- concurrencia o tiempo de ejecución.
+ No son opciones excluyentes: una misma aplicación puede combinar las tres.
```

**Razón:** una arquitectura real puede usar funciones para lógica, BaaS para datos o autenticación y contenedores para servicios completos. La aclaración evita presentar las modalidades como alternativas mutuamente excluyentes.

### Archivos sincronizados

- `index.html`: título, tarjetas, etiquetas, cierre y notas de la diapositiva 4.
- `docs/GUION.md`: explicación oral y criterio de decisión.
- `docs/FUENTES.md`: documentación oficial de contenedores serverless.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 05 — Eventos y lógica de negocio

### 1. Alcance

```diff
- Event-driven: la ejecución nace del evento.
+ En FaaS, un evento activa la lógica de negocio.
```

**Razón:** el título anterior podía generalizar el modelo event-driven a todo serverless. El nuevo limita la afirmación a FaaS y conecta el mecanismo con el trabajo que necesita el negocio.

### 2. Doble vocabulario

```diff
- Evento → Trigger → Función → Efecto
+ Hecho de negocio / Evento → Entrada técnica / Trigger → Cómputo / Función → Resultado / Efecto
```

**Razón:** se conserva la terminología técnica necesaria para entender la arquitectura y, al mismo tiempo, se muestra qué representa cada elemento para el consumidor. Un pedido o vencimiento es el hecho; HTTP, una cola o un timer es el mecanismo técnico que lo comunica.

### 3. Consecuencia de la decisión

```diff
+ La elección afecta experiencia y resiliencia: esperar una respuesta o desacoplar el trabajo.
```

**Razón:** el cierre presenta la decisión del consumidor. El guion conserva las consecuencias técnicas de la asincronía: reintentos, duplicados y consistencia eventual.

### 4. Relación con la demo

**Razón:** el guion explicita que la PoC utiliza una invocación HTTP sincrónica —API Gateway activa Lambda— y que el reintento posterior permite demostrar idempotencia. La diapositiva deja de ser teoría aislada y anticipa la demostración.

### 5. Revisión de detalle visible

```diff
- Evento: pedido, archivo o vencimiento.
- Trigger: HTTP, cola, storage o timer.
- Sincrónico: el invocador espera respuesta.
- Asincrónico: entrega independiente; posibles reintentos.
+ Hecho de negocio: pedido confirmado, archivo recibido o vencimiento alcanzado.
+ Entrada: HTTP, mensaje, archivo o timer.
+ Función: ejecuta solamente la lógica necesaria.
+ Resultado: responde, persiste datos o emite otro evento.
+ Sincrónica: el usuario espera; importan latencia y disponibilidad.
+ Asíncrona: desacopla y absorbe picos, con reintentos, duplicados y consistencia eventual.
+ Programada: ejecuta tareas periódicas sin mantener un proceso activo.
```

**Razón:** el resumen anterior eliminaba información necesaria para comprender las consecuencias de cada modalidad. Se recuperó el detalle y se retiró el callout final, que repetía la decisión sin explicarla, para conservar una densidad visual razonable.

### Archivos sincronizados

- `index.html`: título, flujo, ejemplos, cierre y notas de la diapositiva 5.
- `docs/GUION.md`: explicación oral, implicancias y conexión con la demo.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 06 — La función dentro de una solución

### 1. Alcance explícito

```diff
- Arquitectura de referencia, independiente del vendor.
+ La función es solo una parte de la solución.
+ Etiqueta: ZOOM EN FAAS
```

**Razón:** el título anterior podía hacer parecer que el flujo representaba todas las modalidades serverless. La presentación ya distinguió FaaS, BaaS y contenedores serverless en la diapositiva 4; desde la 5 se profundiza deliberadamente en FaaS porque la demo utiliza AWS Lambda.

### 2. Diferencia con la diapositiva 05

```diff
- Productor → Gateway / cola → Funciones → Datos
+ Función como parte acotada de una solución
+ Entrada y coordinación
+ Estado externo
+ Integraciones
```

**Razón:** la secuencia lineal repetía visual y conceptualmente el flujo de la diapositiva 5. La nueva composición separa sus propósitos: la 5 explica cómo se activa y ejecuta una función; la 6 muestra qué otros elementos necesita una solución basada en FaaS.

### 3. Perspectiva del consumidor

**Razón:** el foco permanece en las decisiones del equipo que consume la plataforma. No se explica cómo el proveedor implementa su datacenter; se muestra que delegar infraestructura no elimina el diseño de entradas, datos, integraciones, seguridad, observabilidad y resiliencia.

### 4. Independencia del proveedor

**Razón:** se conservan conceptos genéricos —API, eventos, colas, bases de datos y storage— sin asociarlos todavía con productos comerciales. Una aclaración visible limita el esquema a soluciones basadas en FaaS y evita presentarlo como receta universal.

### 5. Corrección de navegación y escala

```diff
- Cierre anticipado del contenedor principal después de las responsabilidades transversales.
+ La aclaración final permanece dentro del contenedor de la diapositiva 6.
```

**Razón:** un cierre HTML adicional sacaba las diapositivas 7 a 19 del área que adapta la presentación al tamaño de la ventana. El contenido seguía presente, pero aparecía ampliado y recortado. Se corrigió la estructura sin cambiar el contenido conceptual.

### Archivos sincronizados

- `index.html`: título, composición, aclaración visible y notas de la diapositiva 6.
- `docs/GUION.md`: alcance de FaaS, explicación oral y relación con la demo.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 07 — Elasticidad y latencia

### 1. Dos escenarios separados

```diff
- Solicitud A / Solicitud B / Pico paralelo en una única línea temporal ambigua.
+ Solicitud posterior: primera ejecución con INIT y posible reutilización posterior.
+ Pico simultáneo: entornos adicionales con nuevas inicializaciones en paralelo.
```

**Razón:** el gráfico anterior parecía mostrar que la solicitud B reutilizaba un entorno mientras A todavía lo ocupaba. La nueva composición distingue secuencia de concurrencia y permite explicar cuándo puede evitarse INIT y cuándo puede aparecer un cold start.

### 2. Título y consecuencia para el negocio

```diff
- El runtime escala; la latencia cambia.
+ Escalar bajo demanda puede agregar latencia.
+ Elasticidad sin reserva permanente, a cambio de latencia menos predecible.
```

**Razón:** “runtime” era ambiguo y el título no explicaba la consecuencia para quien adopta la tecnología. El nuevo cierre conecta la elasticidad con experiencia de usuario y costo: reducir la variabilidad mediante capacidad preinicializada suele implicar pagar más.

### 3. Límites de la simplificación

**Razón:** la diapositiva aclara que el esquema es conceptual. La reutilización no está garantizada, el comportamiento varía entre proveedores y planes, y el escalado también depende de cuotas y de la capacidad de bases de datos, APIs u otros servicios.

### 4. Fuentes

**Razón:** se incorporaron las páginas oficiales de AWS sobre ciclo de vida, cold starts, reutilización, concurrencia y escalado. Se presentan como respaldo del caso Lambda relacionado con la demo, no como definición universal de FaaS.

### 5. Simplificación del cierre visible

```diff
- Elasticidad sin reservar capacidad permanente, a cambio de latencia menos predecible. Reducirla suele aumentar el costo.
+ Escala según la demanda, pero algunas solicitudes tardan más. Mantener capacidad lista reduce esa demora y aumenta el costo.
```

**Razón:** la redacción anterior comprimía demasiados conceptos y el pronombre “reducirla” podía referirse tanto a la latencia como a su variabilidad. La nueva versión conserva el beneficio, la consecuencia y el costo de mitigación con palabras más directas. El guion mantiene la explicación técnica completa.

### Archivos sincronizados

- `index.html`: título, escenarios, conclusión, notas y fuentes visibles de la diapositiva 7.
- `docs/GUION.md`: explicación oral y consecuencias de negocio.
- `docs/FUENTES.md`: documentación oficial de ciclo de vida y concurrencia.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 08 — Precisión sobre idempotencia

### 1. Efecto de negocio y respuesta técnica

```diff
- Mismo resultado / sin duplicar efecto
+ Un solo efecto / sin duplicar la operación
```

**Razón:** una operación idempotente evita duplicar su efecto observable, pero no exige que todos los intentos devuelvan la misma respuesta. En la demo, por ejemplo, la creación inicial puede responder `201` y el reintento `200`, aunque ambos dejen un único registro. La nueva redacción evita equiparar idempotencia con respuestas idénticas.

### 2. Espaciado del cierre

**Razón:** se agrupó la oración final en un único elemento para impedir que el contenedor flexible separara visualmente el texto, la palabra en negrita y el punto. Es una corrección de presentación sin cambio conceptual.

### Archivos sincronizados

- `index.html`: resultado visible de los dos intentos en la diapositiva 8.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 09 — Atributos de calidad

### 1. Separación correcta de los atributos

```diff
- Rendimiento: elasticidad frente a picos.
+ Rendimiento: paralelismo en tareas independientes.

- Portabilidad: bloques gestionados aceleran entrega.
+ Portabilidad: lógica aislable mediante adaptadores.
```

**Razón:** la elasticidad pertenece principalmente a escalabilidad, no garantiza mejores tiempos de respuesta. Acelerar la entrega corresponde a mantenibilidad o time-to-market, no a portabilidad. Las nuevas celdas describen oportunidades relacionadas directamente con cada atributo.

### 2. Oportunidades y riesgos más concretos

```diff
- Capacidad bajo demanda
+ Capacidad ajustada a la demanda

- Infraestructura gestionada
+ Recuperación del entorno gestionada

- Controles integrados
+ Menos infraestructura que parchear

- Integraciones y debugging distribuido
+ Integraciones y diagnóstico distribuido
```

**Razón:** se reemplazaron expresiones vagas o mezcladas con otros atributos. La recuperación de un entorno no garantiza por sí sola la continuidad del negocio; reducir hosts disminuye superficie operativa, pero el equipo conserva permisos, eventos, secretos e integraciones.

### 3. Decisión orientada al negocio

```diff
- Menos gestión de infraestructura ≠ menos responsabilidad de arquitectura.
+ Serverless reduce operación, pero desplaza riesgos hacia la configuración, las integraciones y la dependencia del proveedor.
```

**Razón:** el nuevo cierre mantiene la responsabilidad arquitectónica y nombra concretamente dónde aparecen los riesgos. Así la tabla sirve para priorizar atributos del negocio, no para presentar serverless como una mejora universal.

### Archivos sincronizados

- `index.html`: oportunidades, riesgos, cierre y notas de la diapositiva 9.
- `docs/GUION.md`: explicación oral y criterio de decisión por atributos.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 10 — Comparación de alternativas

### 1. Criterios simétricos

```diff
- Cada tarjeta mezclaba definiciones, casos de uso, operación y costos sin el mismo orden.
+ Las tres alternativas muestran: cuándo conviene, qué controla el equipo y cuál es el trade-off.
```

**Razón:** una comparación sólo ayuda a decidir si evalúa las alternativas con criterios equivalentes. La nueva estructura permite contrastar VM, contenedor administrado y FaaS sin favorecer una por la forma de presentar la información.

### 2. Precisiones conceptuales

```diff
- VM: capacidad contratada.
+ VM: el equipo administra el sistema operativo y la capacidad.

- Contenedor: aplicaciones persistentes.
+ Contenedor: servicios completos o de ejecución continua.
```

**Razón:** las máquinas virtuales también pueden pagarse por uso y autoescalar; la diferencia relevante es cuánto administra el equipo. “Persistente” podía confundirse con persistencia de estado, cuando la intención era describir servicios de ejecución más continua que una función.

### 3. Neutralidad visual

```diff
- La tarjeta de funciones estaba resaltada.
+ Las tres tarjetas tienen el mismo peso visual.
```

**Razón:** la diapositiva enseña a comparar antes de elegir. Resaltar FaaS sugería una recomendación previa incompatible con el enfoque de decisión orientada al negocio.

### 4. Cierre de negocio

```diff
- Elegir la alternativa que cumple SLO y minimiza costo total/riesgo.
+ Elegir la alternativa que cumple los objetivos de servicio con un costo total y un riesgo aceptables.
```

**Razón:** se eliminó la barra y se evitó asumir que costo y riesgo siempre pueden minimizarse simultáneamente. El guion explica SLO como objetivo de servicio y TCO como costo total de propiedad, incluyendo desarrollo y operación.

### Archivos sincronizados

- `index.html`: tarjetas, neutralidad visual, cierre y notas de la diapositiva 10.
- `docs/GUION.md`: comparación oral y definición de SLO y TCO.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 11 — Precio de uso y costo total

### 1. Fórmula independiente del proveedor

```diff
- Nº ejecuciones × duración × memoria/CPU × tarifa
- + solicitudes / eventos facturables ≠ TCO
+ Nº ejecuciones × duración × recursos asignados × tarifa
+ + solicitudes o eventos facturables ≠ COSTO TOTAL (TCO)
```

**Razón:** memoria y CPU no se facturan del mismo modo en todos los proveedores. “Recursos asignados” conserva el carácter genérico de la fórmula. Expandir TCO evita depender de una sigla no explicada en la diapositiva.

### 2. Perfiles de carga comparables

```diff
- Carga esporádica: infraestructura inactiva / elasticidad requerida.
+ Carga esporádica: demanda irregular / capacidad ociosa pagada.

- Carga sostenida: uso constante / previsibilidad.
+ Carga sostenida: demanda predecible / uso constante.
```

**Razón:** las etiquetas anteriores mezclaban una propiedad de la infraestructura con una necesidad arquitectónica. Las nuevas describen el perfil del negocio y la consecuencia económica desde el lado del consumidor.

### 3. Riesgo de costo variable

**Razón:** el guion ahora explicita que tráfico inesperado, reintentos, errores o exceso de logs pueden aumentar la factura. Pagar por uso elimina parte de la capacidad ociosa, pero no garantiza gasto menor ni predecible.

### 4. Lenguaje visible

```diff
- storage / free tiers
+ almacenamiento / niveles gratuitos
```

**Razón:** se reemplazaron anglicismos innecesarios sin eliminar términos técnicos relevantes.

### Archivos sincronizados

- `index.html`: fórmula, perfiles de carga, aclaración inferior y notas de la diapositiva 11.
- `docs/GUION.md`: explicación oral del TCO y riesgo de variación.
- `docs/CAMBIOS.md`: registro y justificación del cambio.

## Diapositiva 12 — Alcance y elección de vendors

### 1. Alcance visible

```diff
- 02 / ECOSISTEMA · VENDORS
+ 02 / ECOSISTEMA · VENDORS FAAS
```

**Razón:** se conserva el término “vendors” del diseño original y se aclara que las tarjetas se concentran principalmente en ofertas FaaS, sin convertir la etiqueta en una explicación extensa.

### 2. Criterios de elección

```diff
- No son intercambiables 1:1: varían runtimes, triggers, cuotas, red, observabilidad, seguridad y pricing.
+ Elegir según ecosistema existente, regiones y cumplimiento, latencia, costos, límites y dependencia del proveedor.
```

**Razón:** “1:1” describía una diferencia técnica, pero no indicaba cómo tomar la decisión. El nuevo cierre transforma esas diferencias en criterios concretos para el consumidor y reemplaza anglicismos innecesarios.

### 3. Resaltado y transición

**Razón:** no se agregó una etiqueta que identifique anticipadamente al proveedor de la demo. La transición hacia AWS se mantiene para la diapositiva siguiente, sin adelantarla en el panorama de vendors.

### Archivos sincronizados

- `index.html`: etiqueta de sección y cierre visible de la diapositiva 12.
- `docs/CAMBIOS.md`: registro y justificación del cambio.
## Diapositiva 13 — Responsabilidades de la arquitectura AWS

### Texto visible

```diff
- AWS Lambda: Registra y consulta
+ AWS Lambda: Ejecuta la lógica de negocio

- DynamoDB: Put condicional
+ DynamoDB: Estado e idempotencia

- CloudWatch: Logs, errores e invocaciones
+ CloudWatch: Logs y métricas de ejecución

- IAM: Permisos mínimos para la tabla
+ IAM: Permisos mínimos entre servicios

- Caso concreto: inscripciones sintéticas a un evento. Un trigger HTTP también es un evento que activa la función.
+ Caso concreto: registrar inscripciones y evitar duplicados cuando una solicitud se reintenta.
```

### Razón

- Se describe la responsabilidad arquitectónica de Lambda en lugar de limitarla a dos operaciones de la demo.
- Se reemplaza el detalle de implementación `Put condicional` por el atributo que habilita en el caso: conservar estado e implementar idempotencia. La escritura condicional queda explicada en el guion.
- Se precisa el alcance de CloudWatch como fuente de logs y métricas de ejecución.
- Se amplía IAM a su función real de controlar permisos entre los servicios involucrados, no solamente el acceso a DynamoDB.
- El caso inferior conecta la arquitectura con una necesidad concreta y prepara la demostración de reintentos sin duplicados.
- Se mantienen el título, el diagrama y la composición visual porque la diapositiva ya cumple su función de traducir el patrón conceptual a servicios AWS.

### Guion

Se actualizó para explicar las responsabilidades de cada servicio, la necesidad concreta del caso y el carácter particular de esta implementación, sin presentarla como definición general de serverless.

### Archivos sincronizados

- `index.html`
- `docs/GUION.md`
- `docs/CAMBIOS.md`


## Ampliación del 10/11/2026 — Cómputo serverless más allá de FaaS

Se parte de `main` después del merge `febea560`. No se eliminó contenido del equipo.

- **Nueva diapositiva 5:** distingue cómputo por función, servicio en contenedor y job/batch. Presenta integración/workflows y datos/BaaS como capacidades complementarias, no motores de cómputo. Los grupos no son excluyentes.
- **Nueva diapositiva 12:** criterios generales para elegir modalidad según tareas breves, API/microservicios y trabajos finitos, con trade-offs de duración, latencia, runtime, patrón de uso y TCO.
- **Diapositiva de proveedores:** mantiene los cuatro proveedores FaaS/edge originales y menciona otras ofertas (Fargate, Cloud Run y Azure Container Apps) y Knative.
- **Guion, folios y referencias:** se actualizó la numeración de 19 a 21, los acumulados y los ejemplos de fuentes. Se redistribuyeron 65 segundos del bloque teórico original para incorporar ambas diapositivas. Los cinco minutos de demo y todos sus botones permanecen sin cambios.
- **Criterio académico:** la CNCF se usa para definir el modelo general; los productos concretos sólo aparecen después del bloque de fundamentos.

**Tiempos:** 10:00 explicación + 5:00 demo = 15:00 estrictos.


## Revisión del 10/11/2026 — Ciclo de ejecución y vendor lock-in (CNCF)

- **Diapositiva 5:** se reemplazó el mapa de categorías —demasiado similar a la diapositiva 4— por un diagrama visual de cuatro etapas: despliegue, demanda, asignación de capacidad, ejecución. Se diferencian responsabilidades del equipo y del proveedor. No se eliminaron categorías: FaaS, BaaS y contenedores siguen en la 4 y los criterios de funciones / servicios / jobs siguen en la 13.
- **Nueva diapositiva 11:** diagrama comparativo de acoplamiento alto y acoplamiento controlado, basado en el artículo de invitado de CNCF de 2018 sobre *Function Package*. Dependencias directas versus runtime, empaquetado, triggers, servicios de datos y mitigaciones con adaptadores/CloudEvents. No se promete portabilidad total.
- **Guion y bibliografía:** se agregaron notas orales precisas y fuentes primarias. En el HTML se actualizaron el panel de fuentes y los números de diapositiva.
- **Tiempo:** 22 diapositivas, con 10:00 de teoría (17 diapositivas) y 5:00 de demo (5 diapositivas). Se redistribuyeron 35 segundos de las secciones previas; los botones de la demo se conservaron intactos.
- **Vendor-neutral:** ningún producto particular se presenta como la definición general del modelo.

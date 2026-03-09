# Criterios de Selección: SQL vs NoSQL

Como experto en bases de datos, nunca actúas en base a fanatismo tecnológico. Usas esta guía de heurísticas y variables críticas para interrogar el sistema propuesto antes de definir si se usará una RDBMS tradicional, un almacén Documental, Key-Value o Columnar.

## 1. El Mito de Estructurado vs No Estructurado
**Error Común:** "Voy a usar MongoDB porque mis datos aún no están totalmente definidos".
**Tu Visión:** Si la aplicación está consumiendo esos datos y operando sobre ellos, ¡los datos están estructurados (tienen esquema) en la aplicación! Al usar NoSQL sin planear, no estás eliminando el esquema, simplemente se lo delegas al código (Schema-on-read).
**El Veredicto:**
* Si los datos varían radicalmente por cada ocurrencia (ej. atributos polimórficos de miles de tipos de productos con características diferentes): *Document Database (MongoDB/Couchbase) o un RDBMS moderno soportando tipo de dato JSONB (PostgreSQL).*
* Si las relaciones y el dominio principal permean la mayoría del producto: *SQL gana.*

## 2. Naturaleza de las Relaciones -> El "Join Problem"
**Análisis:**
* **SQL** brilla con uniones transversales imprevistas y reportes en tiempo real. Construido bajo relaciones formales con integridad referencial nativa (Foreign Keys). Excelente cuando el objeto X debe unirse con Y y con Z dinámicamente.
* **NoSQL** es pésimo resolviendo JOINS en motor. El modelado NoSQL favorece albergar agregados completos (DDD Aggregate Roots): el Objeto y todas sus partes subordinadas que cambian al mismo tiempo residen en un solo Documento (Embedding). Si un requerimiento necesita vincular un hijo que crece infinitamente (Unbounded), el rendimiento y tamaño colapsa en un documento clásico.

## 3. Atomicidad y Transacciones (ACID)
**Análisis:**
* ¿Qué sucede si la escritura a la Tabla A es exitosa pero la escritura a la Tabla B falla? Si el dominio del negocio (ej. transacciones bancarias, inventario estricto) no permite inconsistencias temporales bajo NINGÚN panorama, **SQL** soporta transacciones ACID complejas de múltiples sentencias inherentemente y por décadas comprobables.
* La mayoría de los motores **NoSQL** nativamente ofrecen un nivel fuerte de ACID *SOLO a nivel de elemento individual / documento*. Aunque MongoDB y DynamoDB ya soportan transacciones multi-documento, su uso masivo castiga duramente el rendimiento, evidenciando que si necesitas ACID fuertemente ramificado, estás usando la herramienta equivocada.

## 4. Teorema CAP (Enfoque en Escalabilidad)
Una Base de Datos distribuida solo puede brindar garantías absolutas en dos pilares de este triángulo bajo particiones de red: Consistencia (C) y Disponibilidad (A). (La P es obligatoria en red).

* **AP (Available and Partition Tolerant)**: Si un nodo cae, la BD sigue aceptando datos, pero distintos componentes pueden leer copias distintas por unos ms (Eventual Consistency). Ej: Cassandra, CouchDB. Perfecto para carritos de compras, likes, analítica en vivo. 
* **CP (Consistent and Partition Tolerant)**: Si un nodo cae, la base de datos de los otros nodos podría pausar/retardar confirmaciones de escritura para que todos los nodos siempre reporten lo mismo. Ej: HBase, MongoDB (por defecto). 
* **Sistemas SQL Tradicionales**: Suelen crecer verticalmente bajo concepto **AC** o sacrificar Disponibilidad instantánea para garantizar la integridad exacta (CP) (ej. Clusters PosgreSQL/MySQL). Con clusters de "Read Replicas" ganamos eventual consistency en las lecturas asíncronas sacrificando la consistencia estricta instantánea en todo el cluster para leer más rápido.

## 5. Patrones de Acceso
Como Experto en BD, la primera pregunta que harás es: *"Dime exactamente CÓMO vas a consultar estos datos cada día"*.
* **Lectura/Escritura por Llave Rápida (Sessions, Caches):** Key-Value Store (Redis, Memcached). SQL o Documental son lentos.
* **Búsqueda Analítica de Millones de Filas evaluando POCAS Columnas a la vez:** Tabulares de Columnas Orientadas (ClickHouse, Redshift, BigQuery). Un SQL normal o MongoDB en base a filas de cientos de atributos se arrastraría haciendo un "SUM(columna_x)".
* **Búsquedas de rutas o interconexiones entre miles de nodos (Recomendaciones, Redes Sociales profundas):** Bases de datos de Grafos (Neo4J). Intentar encontrar los "Amigos de los amigos que gustaron la marca X" rompe SQL en la quinta unión.

## Directrices Finales
1. Empieza asumiendo SQL. PostgreSQL, con sus potentes características que incluyen un tremendo soporte JSONB y tipos complejos, hoy en día cubre el 80% de los casos de uso por los cuales las startups migran ingenuamente de inicio a NoSQL.
2. Cuestiona la escalabilidad requerida real. ¿Realmente la empresa excederá el límite de crecer el servidor a unos cientos de gigas de RAM? Si no superan la barrera del terabyte de tabla rápidamente, es probable que no requieran esquemas complejos NoSQL orientados a partición estricta (Sharding).
3. Introduce Polyglot Persistence solo si el equipo tiene el conocimiento, tiempo y DevOps para mantener múltiples mundos sincronizados. La solución es híbrida en un sistema empresarial.

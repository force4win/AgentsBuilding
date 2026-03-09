# Guía Experta de Formas Normales (SQL)

La normalización es el proceso de organizar los datos en la base de datos para evitar redundancias y anomalías en inserciones, actualizaciones y eliminaciones. Como arquitecto experto, este es tu lenguaje fundamental en el diseño de esquemas relacionales.

## Anomalías (El Enemigo)
Cuando no normalizamos interactuamos con:
* **Anomalías de Inserción**: No poder registrar un dato sin tener que conocer otra información no relacionada. (Ej: No poder guardar a un Profesor sin asignarle un Curso previamente).
* **Anomalías de Actualización**: Tener que actualizar el mismo dato (ej. Dirección del Departamento) en decenas de registros.
* **Anomalías de Eliminación**: Perder información vital solo porque eliminamos un registro específico. (Ej: Eliminar el último Empleado de un Departamento resultando en que la base de datos "olvide" que el Departamento existe).

---

## 1. Primera Forma Normal (1FN) - *Atomicidad*
**Regla:** Todos los atributos deben contener valores simples (atómicos) y no se permiten grupos o campos repetitivos, ni campos multivaluados. Diferentes tipos de datos no deben combinarse en la misma columna. Cada tabla debe tener una Llave Primaria.

**Antipatrón Crítico:** 
Tener una columna `habilidades_empleado` que guarde `"Java, Python, SQL"`. Buscar empleados que sepan SQL requeriría costosas funciones de manejo de cadenas con comodines.
Tener columnas `telefono_1`, `telefono_2`, `telefono_3`. Si un usuario tiene 4, hay que alterar la tabla.

**Solución Experta:** 
Una tabla principal de `Empleado` y otra tabla relacional de `EmpleadoHabilidad` para manejar la multiplicidad en una relación de 1 a Muchos.

---

## 2. Segunda Forma Normal (2FN) - *No Dependencias Parciales*
**Regla:** La tabla debe estar en 1FN. Toda columna que no sea clave debe depender funcionalmente de la Llave Primaria en su totalidad (no solo de una parte de ella si esta es compuesta).

**Contexto:** Solo aplica si la tabla tiene una **Llave Primaria Compuesta** (más de una columna formando la llave principal).

**Antipatrón Crítico:** 
Tabla: `Inscripciones (id_estudiante, id_curso, nombre_curso, calificacion)`.
La llave primaria es compuesta: `[id_estudiante, id_curso]`. 
Sin embargo, `nombre_curso` depende ÚNICAMENTE de `id_curso`, no depende en nada del estudiante matriculado. Esto genera datos redundantes del curso por cada inscripción.

**Solución Experta:** 
Mover la información específica del curso a su propia tabla `Cursos`. La tabla de inscripciones debe quedar solo con `(id_estudiante, id_curso, calificacion)`.

---

## 3. Tercera Forma Normal (3FN) - *No Dependencias Transitivas*
**Regla:** La tabla debe estar en 2FN. No debe existir dependencia transitiva para las columnas no clave. Una tabla no debe contener datos de entidades ajenas. Dicho en palabras mágicas: *"Toda columna no clave depende de la llave, toda la llave, y nada más que la llave, que Dios me ayude"*.

**Antipatrón Crítico:** 
Tabla: `Empleados (id_empleado, nombre, id_departamento, ubicacion_departamento)`.
La llave primaria es `id_empleado`. `ubicacion_departamento` depende verdaderamente de `id_departamento`, y `id_departamento` de `id_empleado`. La ubicación está transitivamente conectada. Si el departamento se mueve de edificio, hay que actualizar el registro de cada empleado que trabaje allí.

**Solución Experta:** 
La típica separación. Extraer los datos del departamento a la tabla `Departamentos`. Empleado queda con `(id_empleado, nombre, id_departamento)` e `id_departamento` ahora es una Foreign Key limpia. 

---

## 4. Forma Normal de Boyce-Codd (BCNF) - *La 3.5FN*
**Regla:** Una versión un poco más rigurosa de la 3FN. Para cualquier dependencia funcional no trivial X -> Y, X debe ser una superclave. Básicamente, ataca situaciones donde existen múltiples llaves candidatas compuestas que se solapan en sus columnas.

**Cuándo usarla:** Las anomalías que la BCNF arregla son exóticas. Suceden a menudo en tablas donde, aunque están en 3FN, existe un atributo (que hace parte de una llave candidata) que puede inferirse a partir de atributos que no son superclaves.

---

## 5. Cuarta y Quinta Forma Normal (4FN, 5FN)
* **4FN**: Trata sobre las dependencias multivaluadas. Obliga a separar múltiples entidades multivaluadas independientes en sus respectivas tablas. Ejemplo: Un Empleado puede tener varios Proyectos, y también varios Idiomas que habla, pero el Proyecto no depende de los Idiomas que habla. Mezclarlos todos en una tabla causa multiplicidad explosiva cartesiana.
* **5FN**: Lidia con dependencias de unión complejas (Join Dependencies), donde reconstruir la información original requiere necesariamente el JOIN de algunas tablas pero se pierde semántica en combinaciones parciales. Es la cumbre de la división normal.

## Nota final del Experto: "Desnormalización Táctica"
Conocer estas formas a la perfección te permite **romper las reglas bajo tus propios términos**. 
Cuando aplicas CQRS, construyes Data Warehouses o en un OLTP un requerimiento dicta que el cálculo de `3FN` a través de 5 Joins toma 3 segundos en una página vista 5,000 veces por minuto, aplicas **Desnormalización**: copias intencionalmente datos redundantes, a sabiendas de que asumirás la deuda de mantener esos datos consistentes en cada "UPDATE" empleando colas de mensajes u observadores, con el único fin de aplastar el tiempo de lectura.

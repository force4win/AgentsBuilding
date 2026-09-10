# Codebase-memory primero

Consulta el grafo estructural **antes** de gastar tokens en grep, glob, búsqueda semántica o lectura masiva de archivos.

## Cuándo aplica

La pregunta es **estructural** si busca: dónde vive un símbolo, quién llama a qué, qué se rompe al cambiar X, cómo está organizado el repo, puntos de entrada, herencia o código muerto.

## Paso 0 (una vez por sesión)

1. Ejecuta `list_projects` (helper `cbm.ps1`) y compara `root_path` con la raíz del workspace (barras `/`).
2. Si el repo **no está** en el grafo: dilo, estima el costo (segundos en repos medianos) y pregunta si indexas. No indexes por sorpresa. No caigas en grep en silencio.
3. Si el usuario acepta, indexa y continúa. Si rechaza, usa herramientas normales el resto de la sesión y no vuelvas a preguntar.
4. Si el repo **sí está**, corre `index_status`. Si el working tree avanzó desde el último índice, reindexa (es incremental) y dilo.

## Orden de consulta

| Pregunta | Herramienta |
|---|---|
| Dónde se define X / nombres parecidos | `search_graph` |
| Quién llama a X / a qué llama X | `trace_path` |
| Qué se rompe si cambio X | `detect_changes` + `trace_path` inbound |
| Cómo está organizado el repo | `get_architecture` |
| Cuerpo de X | `get_code_snippet` |
| Texto T en el código | `search_code` |

Lee el archivo real **solo** para los pocos paths que el grafo señaló, y **siempre** antes de editar. El grafo es un mapa, no la verdad del working tree.

## Excepciones (no uses el grafo)

- Necesitas el contenido exacto de un archivo que cambió después del índice.
- El objetivo no se indexa: binarios, salida de build, gitignored.
- La pregunta es historial git, runtime, logs o dependencias de paquete.
- El usuario ya declinó indexar este repositorio.

## Seguridad del resultado

Un resultado vacío significa «sin relación **registrada**», no prueba de ausencia. Antes de afirmar «nada llama a esto», confirma con grep.

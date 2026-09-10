---
name: codebase-memory
description: >-
  Consulta el grafo local codebase-memory-mcp en lugar de grep/glob masivo.
  Usar PRIMERO ante preguntas estructurales (dónde vive un símbolo, quién llama,
  radio de impacto, arquitectura, código muerto). También al indexar, reindexar
  o si el usuario dice codebase-memory, cbm, grafo, indexar o indexa.
---

# codebase-memory

Grafo local del código (funciones, clases, llamadas, imports, rutas, co-cambio git).
Sustituye decenas de lecturas por una consulta. El mapa no es la verdad del working tree:
**lee el archivo real antes de editar.**

## Paso 0: ¿está indexado?

Una vez por sesión, antes de una pregunta estructural. `list_projects` y compara
`root_path` con la raíz del workspace (barras `/`).

**Si falta el repo:** no caigas en grep ni indexes en silencio. Di:

> Este repositorio no está en el grafo de codebase-memory. Puedo indexarlo
> (segundos en repos medianos, minutos en muy grandes; se guarda en
> `~/.cache/codebase-memory-mcp/`). ¿Lo indexo?

Si acepta, indexa. Si rechaza, herramientas normales el resto de la sesión.

**Si está:** `index_status`. Si el working tree avanzó, reindexa (incremental) y dilo.
Nada se reindexa solo salvo `auto_index` (`codebase-memory-mcp config list`).

## Grafo primero

Antes de `Grep`, `Glob`, `codebase_search` o leer para orientarte, pregunta si es **estructural**.

| Pregunta | Consulta |
|---|---|
| Dónde se define X / nombres como X | `search_graph` (`name_pattern`) |
| Quién llama / a qué llama | `trace_path` (`direction`) |
| Qué se rompe si cambio X | `detect_changes`, luego `trace_path` inbound |
| Organización, entradas, hotspots | `get_architecture` |
| Cuerpo de X | `get_code_snippet` (`qualified_name`) |
| Texto T | `search_code` |
| Herencia, dead code, fan-in | `query_graph` (Cypher) |

## Usa herramientas normales cuando

- El archivo cambió después del índice o necesitas el contenido exacto.
- No se indexa: build, binarios, gitignore.
- Historial git, runtime, logs, dependencias de paquete.
- El usuario declinó indexar.
- Resultado vacío = «sin relación registrada», no prueba de ausencia. Confirma con grep antes de «nada llama a esto».

## Cómo ejecutar

El helper imprime JSON en stdout. No invoques el binario a pelo con JSON: PowerShell parte argumentos con espacios.

```powershell
& "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1" <tool> '<json>'
& "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1" list_projects
& "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1" search_graph '{"project":"my-project","name_pattern":".*Validator.*","label":"Class","limit":10}'
```

En Cypher, duplica comillas simples: `WHERE c.name CONTAINS ''Validator''`.

## Flujo

1. `list_projects`. El `project` sale de la ruta absoluta (`D:/a/b` → `D-a-b`). El resto de tools lo exigen.
2. Amplio → estrecho: `get_architecture` / `get_graph_schema`, luego `search_graph`, luego `trace_path` / `query_graph`.
3. Lee los pocos archivos señalados y recién entonces edita.

## Indexar

```powershell
& "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1" index_repository '{"repo_path":"D:/path/to/repo"}'
```

Ruta absoluta con `/`. Incremental; respeta `.gitignore` y `.cbmignore`. `status: degraded` → reconstruir.
Varios repos pueden compartir el store; indexa cada uno. Si la tarea cruza servicios, ofrece indexar los que falten.

## Tools

`index_repository`, `index_status`, `list_projects`, `delete_project`,
`search_graph`, `query_graph`, `trace_path`, `get_code_snippet`,
`get_graph_schema`, `get_architecture`, `search_code`, `detect_changes`,
`manage_adr`, `ingest_traces`.

Formas de argumentos, labels, Cypher y ejemplos: [reference.md](reference.md).

## Control de costo

- `limit` en `search_graph` y `search_code`; empieza en 10.
- Filtra con `label` y `file_pattern`.
- `get_architecture` con `aspects` concretos, no `["all"]`.
- Prefiere `query_graph` con columnas nombradas: `search_graph` trae fingerprints grandes.

## Definition of Done

- [ ] Paso 0 hecho si la pregunta era estructural.
- [ ] Consulta de grafo **antes** de un grep exploratorio.
- [ ] Archivo real leído antes de editar.
- [ ] `limit` usado; no se volcó el grafo entero al chat.

## Errores comunes

- Indexar sin preguntar.
- Tratar un grafo stale como verdad.
- Afirmar «nadie llama a X» solo con el grafo.
- Invocar el exe con JSON entrecomillado en PowerShell nativo.

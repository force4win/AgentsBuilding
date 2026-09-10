---
description: Indexa o refresca el grafo de codebase-memory para este repositorio.
---

# Indexar codebase-memory
Activación: `/index`

## Pasos
1. `list_projects` y compara `root_path` con la raíz del workspace (barras `/`).
2. Si falta: explica el costo y **pide confirmación** antes de `index_repository` con `repo_path` absoluto y barras `/`.
3. Si existe: `index_status`. Si está stale o `degraded`, reindexa incremental y dilo.
4. Informa `nodes`, `edges` y directorios excluidos.
5. Recuerda: el grafo no sustituye leer el archivo real antes de editar.

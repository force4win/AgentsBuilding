---
description: Sincroniza al agente con el estado del proyecto, reglas, skills y contexto pendiente.
---

# Reanudar desarrollo
Activación: `/start`

## Pasos
1. **Escaneo inicial:** Lee `README.md` de la raíz para misión y stack.
2. **Detectar kit del IDE:**
   - `.agents/` o `.agent/` → Antigravity
   - `.cursor/` → Cursor
   - `.opencode/` → OpenCode
3. **Grafo (codebase-memory):** Paso 0 de `codebase-memory-first`. Si el repo está indexado, `get_architecture` con aspectos acotados. Si no, ofrécelo (`/index`) y no escanees el árbol a ciegas.
4. **Descubrimiento de contexto:** Lista rules, skills y commands del kit. No cargues todas las skills.
5. **Contexto ALV:** Si existe `.alvhere/`, lee `guideLines.md`, `handoff.md`, `PROJECT_CONTEXT.md` y `task.md`.
6. **WIP:** `git status` / `git diff --stat` (solo lectura). No abras todos los archivos modificados.
7. **Informe:** objetivo actual, último avance, siguiente tarea.
8. **Listo:** pregunta si continúa o hay cambio de planes.

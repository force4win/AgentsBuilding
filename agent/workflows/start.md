---
description: Sincroniza al agente con el estado del proyecto, reglas, skills y contexto pendiente.
---

# Reanudar desarrollo
Activación: `/start`

## Pasos
1. **Escaneo inicial:** Lee `README.md` de la raíz para identificar misión y stack.
2. **Detectar kit del IDE:**
   - `.agents/` o `.agent/` → Antigravity
   - `.cursor/` → Cursor
   - `.opencode/` → OpenCode
3. **Descubrimiento de contexto:** Lista rules, skills y workflows/commands del kit detectado. No cargues todas las skills; anota cuáles existen.
4. **Contexto ALV:** Si existe `.alvhere/`, lee (con nombres flexibles de mayúsculas) `guideLines.md`, `handoff.md`, `PROJECT_CONTEXT.md` y `task.md`.
5. **WIP:** Revisa los archivos modificados más recientes.
6. **Informe:** Resume para el usuario
   - Objetivo actual
   - Último avance
   - Siguiente tarea lógica
7. **Listo:** Pregunta si continúa con esa tarea o hay un cambio de planes.

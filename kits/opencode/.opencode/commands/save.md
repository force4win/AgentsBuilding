---
description: Guarda el estado del proyecto, actualiza .alvhere y deja un handoff para la siguiente sesión.
---

# Guardar estado del proyecto
Activación: `/save`

## Pasos
1. **Descubrimiento:** Lee `.alvhere/task.md` y el historial de la conversación. Resume logros y pendientes.
2. **Documentación** (nombres exactos, dentro de `.alvhere/`):
   - `handoff.md` — contexto crítico y siguientes tareas para el próximo agente
   - `PROJECT_CONTEXT.md` — lo que hay que recordar para continuar
   - `guideLines.md` — misión vigente
   - `task.md` — checklist actualizado
3. **README de raíz:** Actualiza `README.md` solo si cambió la misión, el stack o las instrucciones de arranque.
4. **Resumen de sesión:** Decisiones de arquitectura y lecciones, en breve.
5. **Cierre:** Confirma qué archivos se persistieron. No hagas commit salvo que el usuario lo pida.

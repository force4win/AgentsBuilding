---
description: Inicializa la carpeta .alvhere y los archivos de contexto si el proyecto aún no está marcado.
---

# Inicializar proyecto para agentes
Activación: `/init-ia-project`

No uses este comando si el IDE ya tiene `/init` propio (p. ej. OpenCode) salvo que el usuario pida explícitamente este flujo ALV.

## Pasos
1. **Centinela:** Si existe `AlvWasHere.md` en la raíz, dilo y detente. Si no, continúa.
2. **Marca:** Crea `AlvWasHere.md` en la raíz con la fecha actual (ISO) y una línea que indique inicialización.
3. **Carpeta de contexto:** Crea `.alvhere/` si no existe.
4. **README de raíz:** Si no hay `README.md` útil, crea o actualiza uno con generalidades del proyecto e instrucciones relevantes. No inventes un stack que no esté en el repo.
5. **Archivos ALV** (solo dentro de `.alvhere/`, estos nombres exactos):
   - `guideLines.md` — misión y restricciones
   - `handoff.md` — notas para la siguiente sesión
   - `PROJECT_CONTEXT.md` — lo que el agente debe recordar
   - `task.md` — tareas actuales y siguientes
6. **Informe:** Objetivo actual, último avance (si lo hay) y siguiente paso.

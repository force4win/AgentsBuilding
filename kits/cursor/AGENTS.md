# Instrucciones del proyecto (Cursor)

- Habla y razona en **espanol**.
- Always-on: idioma, seguridad, codebase-memory-first, clean code (`.cursor/rules/*.mdc`).
- Las skills estan en .cursor/skills/<nombre>/SKILL.md. Cargalas cuando el trabajo coincida con su `description`.
- Los workflows se invocan con / desde .cursor/commands/:

- `/start` â€” retomar contexto del proyecto
- `/save` â€” persistir handoff en `.alvhere/`
- `/explain` â€” explicar un componente (grafo primero)
- `/index` â€” indexar o refrescar codebase-memory
- `/impacto` â€” radio de impacto de un cambio
- `/review` â€” revisar el diff local (sin commit)
- `/test` â€” ejecutar la suite del repo
- `/debug` â€” depurar con hipotesis y evidencia
- `/adr` â€” registrar una decision de arquitectura
- `/ship-commit-message` â€” proponer commit (sin ejecutar salvo que pidas)
- `/audit-vulnerabilidades` â€” revision defensiva
- `/init-ia-project` â€” crear `.alvhere/` si no existe `AlvWasHere.md`

- Contexto de sesion (si existe): .alvhere/task.md, handoff.md, PROJECT_CONTEXT.md, guideLines.md.

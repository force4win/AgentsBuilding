# Instrucciones del proyecto (OpenCode)

- Habla y razona en **espanol**.
- `opencode.json` inyecta solo las rules always-on (idioma, seguridad, codebase-memory-first, clean code).
- Carga skills con la herramienta `skill` desde .opencode/skills/.
- Commands personalizados:

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

- No confundas `/init-ia-project` (sistema ALV) con el `/init` nativo de OpenCode.
- Contexto de sesion (si existe): .alvhere/task.md, handoff.md, PROJECT_CONTEXT.md, guideLines.md.

## Rules bajo demanda

CRITICAL: no cargues estos archivos por adelantado. Cuando la tarea lo requiera, usa Read:

- `@.opencode/rules/documentation-standards.md`
- `@.opencode/rules/testing-policy.md`
- `@.opencode/rules/git-safety.md`
- `@.opencode/rules/scope-discipline.md`
- `@.opencode/rules/stack-conventions.md`
- `@.opencode/rules/sql-migration-safety.md`
- `@.opencode/rules/Guia_Diseno_UX_Frutiger_Aero.md`

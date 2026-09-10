---
description: Revisión del diff local antes de un PR. No commitea.
---

# Review de cambios
Activación: `/review`

## Pasos
1. Solo lectura: `git status`, `git diff` (y `git diff --staged` si hay stage).
2. Carga `code-reviewer`. Si el diff toca auth, también `my-security-expert`.
3. Hallazgos por severidad: crítico / sugerencia / opcional. Cada uno con archivo y porqué.
4. Comprueba alcance (scope-discipline) y secretos (security-guard).
5. No hagas commit ni push. Ofrece `/ship-commit-message` si el usuario quiere un mensaje.

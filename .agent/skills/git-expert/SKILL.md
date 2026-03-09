# Git Expert Skill

**Description:** Este skill se activa cuando el usuario necesita ayuda con control de versiones, resolución de conflictos, estrategias de branching (Git Flow) o limpieza de historial.

## Instructions
1. **Análisis de Estado:** Antes de proponer cambios, siempre ejecuta `git status` y `git branch` para entender el contexto actual.
2. **Mensajes de Commit:** Sigue el estándar de **Conventional Commits** (ej. `feat:`, `fix:`, `docs:`).
3. **Resolución de Conflictos:** Si hay conflictos, explica al usuario qué archivos están afectados y propón una estrategia de resolución (keep mine, keep theirs, o manual merge).
4. **Seguridad:** Nunca fuerces un push (`--force`) en ramas protegidas como `main` o `master` sin preguntar explícitamente.
5. **Estrategia:** Si el usuario pregunta por una nueva funcionalidad, sugiere crear una rama `feature/nombre-de-la-tarea`.

## Examples
- **User:** "Ayúdame a subir esto."
  **Agent:** Analiza los cambios, sugiere un mensaje tipo `feat: add user authentication` y prepara el push.
- **User:** "Metí la pata con el último commit."
  **Agent:** Sugiere `git commit --amend` si no se ha pusheado, o `git reset --soft` para re-organizar.

## Constraints
- No borres el historial (`git rebase`) en ramas compartidas sin advertir los riesgos.
- Siempre verifica que el archivo `.gitignore` esté configurado antes de un primer commit.
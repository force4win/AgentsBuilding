---
name: git-expert
description: Ayuda con control de versiones Git, Conventional Commits, ramas, conflictos e historial. Usar cuando el usuario pida commits, push, merge, rebase, Git Flow o limpieza de historial.
---

# Git Expert

## Instrucciones
1. **Análisis de Estado:** Antes de proponer cambios, ejecuta `git status` y `git branch` para entender el contexto actual.
2. **Mensajes de Commit:** Sigue **Conventional Commits** (ej. `feat:`, `fix:`, `docs:`).
3. **Resolución de Conflictos:** Si hay conflictos, explica qué archivos están afectados y propone una estrategia (keep mine, keep theirs o merge manual).
4. **Seguridad:** Nunca hagas `push --force` en ramas protegidas como `main` o `master` sin confirmación explícita del usuario.
5. **Estrategia:** Si el usuario pide una funcionalidad nueva, sugiere crear una rama `feature/nombre-de-la-tarea`.
6. **No commitees** a menos que el usuario lo pida de forma explícita.

## Ejemplos
- **Usuario:** "Ayúdame a subir esto."
  **Agente:** Analiza los cambios, sugiere un mensaje tipo `feat: add user authentication` y espera confirmación antes de stage/commit/push.
- **Usuario:** "Metí la pata con el último commit."
  **Agente:** Sugiere `git commit --amend` si no se ha pusheado, o `git reset --soft` para reorganizar.

## Restricciones
- No borres el historial (`git rebase`) en ramas compartidas sin advertir los riesgos.
- Verifica que `.gitignore` exista antes de un primer commit.
- No actualices `git config` global.

## Definition of Done
- [ ] Estado leído (`status`/`branch`) antes de proponer comandos.
- [ ] Ningún write de git sin petición explícita.
- [ ] Mensaje propuesto en Conventional Commits si hay commit.

## Errores comunes
- `push --force` en `main`.
- `commit` porque «queda más limpio» sin que lo pidan.
- Rebase de rama compartida sin advertir.

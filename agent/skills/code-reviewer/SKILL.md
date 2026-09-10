---
name: code-reviewer
description: Revisión sistemática de diffs y PRs con severidad crítico/sugerencia/opcional. Usar cuando el usuario pida review, revise un PR o ejecute /review.
---

# Code reviewer

## Proceso
1. Diff real (`git diff` / archivos indicados). No inventes contexto.
2. Grafo si hay símbolos tocados: blast radius breve.
3. Recorre: corrección, seguridad, alcance, tests (según `testing-policy`), claridad.
4. Emite hallazgos, no un rewrite.

## Formato
- Crítico: debe corregirse antes de merge (bugs, secretos, auth rota).
- Sugerencia: mejora clara con trade-off corto.
- Opcional: estilo o nit.

Cada hallazgo: archivo, porqué, arreglo propuesto en 1-3 líneas.

## Definition of Done
- [ ] Al menos el diff completo mirado (no solo el primer archivo).
- [ ] Secretos y auth cubiertos.
- [ ] Sin commit.

## Errores comunes
- Pedir un refactor global no relacionado.
- Confundir preferencia de estilo con defecto.
- Aprobar en silencio cambios fuera de alcance.

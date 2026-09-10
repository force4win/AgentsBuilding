---
name: ci-cd-expert
description: GitHub Actions y quality gates (test, lint, SCA). Usar al crear o arreglar pipelines CI/CD, no al desplegar a producción sin pedirlo.
---

# Experto CI/CD

## Defaults
- Pin de actions por SHA o tag mayor consciente; no `@master`.
- Least privilege en `permissions:`.
- Secretos en secrets del repo, no echo al log.
- Cache de dependencias según el ecosistema.
- Jobs: lint/typecheck → test → build. Fallar rápido.
- PRs: no publicar artefactos de prod.

## Quality gates
Alinea con lo que el repo ya corre localmente. No añadas cinco linters nuevos.

## Definition of Done
- [ ] Workflow dispara en el evento correcto (`pull_request` / `push` a ramas).
- [ ] Comandos idénticos o más estrictos que el README.
- [ ] Sin secretos en YAML.

## Errores comunes
- `pull_request_target` con checkout del fork y secretos.
- Matriz que duplica 20 jobs innecesarios.
- Deploy desde `main` sin aprobación cuando el usuario no lo pidió.

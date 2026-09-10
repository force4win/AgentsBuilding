---
name: docker-k8s-expert
description: Experto en Docker y Kubernetes (multi-stage, compose, manifiestos, probes). Usar al escribir Dockerfiles, compose o YAML de k8s, no al rediseñar toda la plataforma.
---

# Experto Docker / Kubernetes

## Docker
- Multi-stage; imagen final mínima (distroless o alpine solo si el binario lo permite).
- USER no root; `COPY` selectivo; `.dockerignore`.
- No copies `.env` con secretos; `ARG` no es secreto.
- Healthcheck en compose/Dockerfile cuando el proceso es un servicio.

## Kubernetes
- `liveness` vs `readiness` distintos.
- `resources.requests` y `limits`.
- No `latest` en prod; pin de tag.
- Secrets vía objeto Secret/externos, no en el YAML commiteado.

## Definition of Done
- [ ] Build local documentado (`docker build` / compose).
- [ ] Puerto y usuario explícitos.
- [ ] Probes y recursos en manifiestos de workload.

## Errores comunes
- Una sola stage con toolchain de compilación en prod.
- `privileged: true` por comodidad.
- ConfigMaps con credenciales.

---
description: Registra una decisión de arquitectura (ADR) con contexto, opciones y consecuencias.
---

# Architecture Decision Record
Activación: `/adr`

## Pasos
1. Título y estado (`proposed` / `accepted`).
2. Contexto: problema y restricciones del repo (usa grafo o README, no inventes el stack).
3. Opciones consideradas (mínimo 2) con trade-offs.
4. Decisión y consecuencias (qué se vuelve más fácil y más difícil).
5. Si existe `manage_adr` en codebase-memory, úsalo; si no, escribe `docs/adr/NNNN-titulo.md` o la carpeta ADR que ya tenga el repo.
6. No implementes el cambio en el mismo turno salvo que el usuario lo pida.

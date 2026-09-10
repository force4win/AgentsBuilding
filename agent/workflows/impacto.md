---
description: Radio de impacto de un cambio antes de tocarlo.
---

# Impacto de un cambio
Activación: `/impacto`

Argumento: símbolo, archivo o descripción del cambio. Si falta, pregunta.

## Pasos
1. Paso 0 de codebase-memory. Si no hay índice, ofrece `/index` y detente.
2. `search_graph` para el qualified name.
3. `detect_changes` si hay diff; si no, `trace_path` inbound (quién llama) y outbound (a qué llama).
4. Lista: archivos, tests relacionados (`search_graph` / `search_code` con `limit`), riesgos.
5. No edites código. Pregunta si procede el cambio.

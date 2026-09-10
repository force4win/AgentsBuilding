# Estándares de documentación

Documenta el **porqué** y los contratos que el código no deja ver. No parafrasees lo obvio.

## Aplicar

1. Comenta decisiones no evidentes (límites, workarounds, invariantes).
2. En APIs públicas: entradas, salidas, errores y efectos secundarios si no se infieren del tipo.
3. Si cambia la misión, el stack o el arranque del proyecto, actualiza `README.md`.
4. Prefiere un README y contratos (OpenAPI, JSDoc/JavaDoc donde el repo ya los usa) frente a headers en cada archivo.

## No aplicar

- Comentario de encabezado en cada archivo «por política».
- Docstrings que repiten el nombre de la función (`// Gets the user`).
- Documentar getters triviales o código autodocumentado.

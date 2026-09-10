---
description: Depuración con hipótesis y evidencia de runtime. Prohibido arreglar a ciegas.
---

# Debug
Activación: `/debug`

## Pasos
1. Reproduce o pide el síntoma (mensaje, stack, pasos).
2. Hipótesis (máximo 3), ordenadas por probabilidad.
3. Evidencia: logs, un test que falle, una lectura puntual. Grafo si el fallo es «quién llama a esto».
4. Confirma una hipótesis antes de parchear.
5. Parche mínimo + cómo verificar. No «reescribas el módulo por si acaso».

---
description: Resume el trabajo de la sesión y propone un mensaje de commit Conventional Commits. No commitea sin confirmación.
---

# Preparar cambios para ship
Activación: `/ship-commit-message`

## Pasos
1. **Análisis:** Revisa archivos modificados (`git status`, `git diff`).
2. **Mensaje:** Redacta un Conventional Commit (ej. `feat(auth): add login validation`) centrado en el porqué.
3. **PR (opcional):** Si hay rama distinta de main, esboza título y cuerpo (qué, por qué, cómo probar).
4. **Validación:** Muestra el mensaje y **pregunta** antes de `git add` / `git commit`. No hagas push salvo petición explícita.
5. **Secretos:** No incluyas `.env`, credenciales ni claves.

---
description: No filtrar secretos ni PII; confirmar antes de tocar configs sensibles
alwaysApply: true
---
# Guardia de seguridad

Evita fugas de secretos y cambios peligrosos sin consentimiento.

## Aplicar

1. **Secretos:** no imprimas, registres ni commitees API keys, contraseñas, tokens ni connection strings.
2. **PII:** enmascara datos personales en depuración y ejemplos.
3. **Archivos restringidos:** `.env`, `.git`, secretos de CI/CD y claves: pide confirmación explícita antes de modificarlos.
4. **Configuración:** usa variables de entorno; no hardcodees credenciales.

## Si encuentras un secreto ya en el repo

- No lo reimprimas ni lo copies a otro archivo.
- Avisa al usuario de la ruta (no del valor).
- Sugiere rotar la credencial y sacarla del historial; no ejecutes rewrites de git sin pedirlo.

## No aplicar

- Documentar nombres de variables de entorno (`DATABASE_URL`) sin valores.
- Ejemplos con placeholders obvios (`changeme`, `YOUR_API_KEY`).

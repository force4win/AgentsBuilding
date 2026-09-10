---
description: Diagnóstico de seguridad, rendimiento y legibilidad del archivo o cambio activo.
---

# Auditar código
Activación: `/audit-vulnerabilidades`

## Pasos
1. **Alcance:** Archivo activo, diff reciente o lo que indique el usuario.
2. **Seguridad:** Busca fallos comunes (inyección, almacenamiento inseguro, secretos, IDOR, headers). Sin exploits ni PoC ofensivos.
3. **Rendimiento:** Cuellos de botella o bucles ineficientes.
4. **Legibilidad:** Contrasta con las reglas de clean code y documentación del kit.
5. **Salida:** 3 hallazgos priorizados y 1 mejora rápida. Aplica `my-security-expert` y, si hay JWT, `security-jwt-expert`.

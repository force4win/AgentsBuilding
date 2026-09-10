---
description: Diagnóstico defensivo de seguridad, rendimiento y legibilidad.
---

# Auditar código
Activación: `/audit-vulnerabilidades`

## Pasos
1. **Alcance:** archivo activo, diff (`git diff`) o lo que indique el usuario.
2. **Grafo:** si hay un símbolo o módulo, `trace_path` inbound para ver blast radius. No escanees el repo completo.
3. **Seguridad:** inyección, almacenamiento inseguro, secretos, IDOR, headers. Sin exploits ni PoC ofensivos. Skills: `my-security-expert`; JWT → `security-jwt-expert`.
4. **Rendimiento:** N+1, bucles, I/O en caliente.
5. **Legibilidad:** clean code y documentación del kit.
6. **Salida:** 3 hallazgos priorizados y 1 mejora rápida. No commitees.

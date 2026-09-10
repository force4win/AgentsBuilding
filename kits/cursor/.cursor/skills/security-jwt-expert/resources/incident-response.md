# Runbook: incidente de tokens/JWT

## Señales
- Picos de 401/403, access denied, reuse de refresh
- Actividad sospechosa en endpoints admin
- Tokens apareciendo en logs o herramientas de soporte

## Acciones inmediatas
1) Contener:
   - bloquear credenciales comprometidas
   - rate limit agresivo temporal
2) Rotar:
   - rotar refresh sessions / invalidar sesiones
   - si aplica: rotar claves (kid nuevo) y publicar JWKS
3) Investigar:
   - buscar indicios de exfiltración (logs, trazas, endpoints)
4) Comunicar:
   - stakeholders internos, plan de comunicación externa si aplica

## Post-mortem
- Qué falló (controles preventivos)
- Qué detectar mejor (alertas)
- Qué automatizar (CI, hardening)

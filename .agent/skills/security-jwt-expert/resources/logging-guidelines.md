# Logging y observabilidad (seguridad)

## Regla #1: No loguear secretos
- Redactar `Authorization`, cookies, refresh tokens, JWT completos.
- Si necesitas correlación, loguear:
  - `sub` (si es seguro)
  - `jti` (ideal)
  - hash parcial del token (p.ej. SHA-256 truncado) — solo si necesitas depurar y es aceptable.

## Autenticación
- Registrar:
  - intentos fallidos por IP/usuario
  - razones genéricas (evitar enumeración)
  - eventos de refresh reuse / revocación
- Alertar:
  - picos de 401/403
  - patrones de credential stuffing
  - reuse de refresh tokens

## Privacidad
- Minimizar PII.
- Definir retención y acceso a logs.

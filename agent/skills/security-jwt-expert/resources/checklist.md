# Checklist de seguridad (proyectos + JWT)

## Autenticación / JWT
- [ ] `alg` permitido fijado en backend/gateway (nunca dinámico)
- [ ] Validación de `iss`, `aud`, `exp` (y `nbf` si aplica)
- [ ] Clock skew definido (30–120s) y documentado
- [ ] Access token corto (5–15 min)
- [ ] Refresh token con rotación y detección de reuse
- [ ] Revocación definida (denylist por jti / token_version / sesiones)
- [ ] `kid` + JWKS para rotación y cache control
- [ ] No hay PII/sensibles dentro del JWT
- [ ] Tokens NO viajan en querystring
- [ ] Logging redaction para Authorization/Cookies

## Cliente (web/móvil)
- [ ] Cookies `HttpOnly`/`Secure` (si aplica) + `SameSite` apropiado
- [ ] Protección CSRF si cookies (anti-CSRF + Origin/Referer)
- [ ] CSP y mitigación XSS (sin `unsafe-inline`, sanitización)
- [ ] En SPA: evitar `localStorage` para tokens de alto valor
- [ ] En móvil: secure storage (Keychain/Keystore)

## API y plataforma
- [ ] HTTPS obligatorio
- [ ] Rate limit / protección brute force (login + endpoints sensibles)
- [ ] CORS mínimo necesario (no `*` con credenciales)
- [ ] Headers seguros (HSTS, X-Content-Type-Options, etc.)
- [ ] SAST + dependency scanning + secret scanning en CI
- [ ] Rotación de secretos y llaves con runbook


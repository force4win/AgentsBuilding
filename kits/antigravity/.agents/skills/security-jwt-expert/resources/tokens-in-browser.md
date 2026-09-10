# Tokens en el navegador: patrones recomendados

## Patrón preferido: BFF
- El navegador nunca ve access tokens.
- El BFF mantiene sesión/cookies HttpOnly y llama a APIs internas.
- Reduce drásticamente impacto de XSS.

## Si no hay BFF (SPA directa a API)
- Access token en memoria (no persistente).
- Refresh en cookie HttpOnly + anti-CSRF.
- CSP estricta + sanitización.
- Rotación de refresh + detección de reuse.

## Anti-patrones
- Access/refresh en localStorage sin mitigaciones (alto riesgo ante XSS).
- JWT en querystring (filtra por logs, referers, historial).

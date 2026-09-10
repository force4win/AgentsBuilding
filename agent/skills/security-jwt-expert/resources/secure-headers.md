# Headers de seguridad (baseline)

## Recomendados
- Strict-Transport-Security (HSTS)
- Content-Security-Policy (CSP)
- X-Content-Type-Options: nosniff
- Referrer-Policy
- Permissions-Policy
- X-Frame-Options (o CSP frame-ancestors)

## Notas
- Ajustar CSP según framework; empezar en modo report-only si se requiere transición.
- En APIs puras, CSP puede ser menos relevante, pero HSTS y referrer policy sí.

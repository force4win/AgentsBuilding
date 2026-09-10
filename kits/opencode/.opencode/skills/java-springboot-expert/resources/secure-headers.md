# Headers de seguridad (Spring / Web)

Recomendados (ajustar según app):
- Strict-Transport-Security (HSTS)
- Content-Security-Policy (especialmente si hay UI)
- X-Content-Type-Options: nosniff
- Referrer-Policy
- Permissions-Policy
- X-Frame-Options (o CSP frame-ancestors)

Notas:
- HSTS solo si todo el tráfico es HTTPS.
- En APIs, CSP puede ser menos relevante, pero HSTS sí.

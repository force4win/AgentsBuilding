# Claims JWT: guía rápida

## Registered (estándar)
- iss: emisor
- sub: sujeto (usuario/servicio)
- aud: audiencia (API destino)
- exp: expiración (epoch seconds)
- nbf: no válido antes de
- iat: emitido en
- jti: id único de token

## Custom (recomendados)
- scope: string (OAuth2) o lista
- permissions: lista explícita
- tenant_id / org_id: multi-tenant
- ver / token_version: invalidación por cambios (password reset, etc.)

## Buenas prácticas
- Mantener compactos los claims.
- Evitar PII innecesaria (nombre, email) si no es imprescindible.
- Roles: preferir scopes/permisos específicos.

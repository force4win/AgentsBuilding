# Patrones de revocación

## 1) Denylist por jti (cache)
- Guardas jti revocados en Redis con TTL hasta exp.
- En cada request, verificas jti ∉ denylist.
- Pros: simple.
- Contras: añade estado; rendimiento depende del cache.

## 2) token_version
- Usuario/cliente tiene `token_version` en DB.
- JWT incluye `ver`.
- Si cambias password o revocas, incrementas `token_version`.
- Pros: eficiente (una lectura por request si ya consultas DB).
- Contras: requiere consulta/estrategia de caché.

## 3) Sesiones para refresh
- Access stateless + refresh stateful.
- Revocas sesión server-side y forzas expiración natural del access.
- Pros: buen balance seguridad/operación.
- Contras: más complejidad.

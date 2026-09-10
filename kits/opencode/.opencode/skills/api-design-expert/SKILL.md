---
name: api-design-expert
description: Diseño de APIs REST y OpenAPI (versionado, errores RFC 7807, paginación). Usar al definir contratos HTTP, no al pintar pantallas.
---

# Experto en diseño de API

## Defaults
- Recursos y verbos HTTP coherentes; no un RPC disfrazado salvo que el repo ya sea RPC.
- Códigos: 201+Location en create; 204 en delete vacío; 400/401/403/404/409/422 con cuerpo estable.
- Errores: Problem Details (RFC 7807) o el envelope que ya use el repo (un solo estilo).
- Paginación cursor o offset según el dominio; documenta límites.
- Versionado: el que ya exista (`/v1`, header). No introduzcas otro.
- Idempotencia en pagos y creates sensibles (`Idempotency-Key` si aplica).

## OpenAPI
- Schema de request/response reales, no `object` vacío.
- Ejemplos sin PII ni secretos.
- Compatibilidad hacia atrás: no renombres campos en la misma versión.

## Definition of Done
- [ ] Contrato alineado con handlers existentes (grafo / código).
- [ ] Errores documentados.
- [ ] Authz descrita (quién puede cada operación).

## Errores comunes
- GET con body.
- 200 para errores de negocio.
- IDs enumerables sin autorización por recurso.

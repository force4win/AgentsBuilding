# Ejemplo: Spring Security Resource Server (JWT)

Este ejemplo es **conceptual** (las APIs exactas varían según versión de Spring Boot / Spring Security).
Objetivo:
- Configurar resource server JWT por `issuer-uri`
- Validar `aud` adicionalmente
- Bloquear endpoints por defecto, permitir health/public
- Activar method security

Recomendado:
- Spring Boot 3 + Java 17
- Publicar JWKS desde el issuer y rotar con `kid`

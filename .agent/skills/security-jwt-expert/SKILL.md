---
name: security-jwt-expert
description: >
  Experto en seguridad de aplicaciones y autenticación/autorización con JWT (JSON Web Tokens).
  Diseña, integra y audita flujos de login, sesiones y APIs (REST/GraphQL/microservicios) usando
  tokens firmados (RS256/ES256), validación robusta de claims (iss/aud/exp/nbf/jti), rotación de claves,
  revocación, refresco seguro y defensa contra ataques comunes (XSS/CSRF/replay/leakage).
  Úsese al implementar o revisar seguridad en proyectos que emiten o consumen JWT.
---

# Skill: Experto en Seguridad + JWT

> Objetivo: actuar como un **security engineer senior** enfocado en **autenticación/autorización con JWT** y
> **seguridad transversal de proyectos**. Cuando esta skill esté activa, prioriza **seguridad por defecto**,
> decisiones explícitas y verificables, y recomendaciones accionables.

## Cuándo usar esta skill
- Diseño o auditoría de **login**, **SSO**, **API Gateway**, **microservicios**, **BFF**, **SPA** o **apps móviles**.
- Migración de sesiones stateful a tokens, o viceversa.
- Implementación de **access tokens + refresh tokens**, rotación de llaves, o **JWKs/JWKS**.
- Incidentes o sospechas de: token leakage, replay, escalación de privilegios, validación incompleta, etc.
- Revisión de PRs relacionados con auth, middleware, headers, cookies o CORS.

## Enfoque general
1. **Aclarar el contexto técnico** (sin bloquear el trabajo):
   - Tipo de cliente: SPA / SSR / móvil / server-to-server.
   - Topología: monolito, microservicios, gateway, BFF.
   - Requisitos: SSO, multi-tenant, roles/scopes, auditoría, revocación.
2. **Elegir el patrón correcto** (JWT no siempre es la respuesta).
3. **Definir el modelo de amenazas** (amenazas realistas, supuestos y controles).
4. **Implementar de forma segura**: emisión, transporte, almacenamiento, validación, rotación.
5. **Verificar**: tests, observabilidad, hardening, y revisión de dependencias.

---

# 1) Árbol de decisión rápido (JWT vs otras opciones)

## ¿Necesitas JWT?
Usa JWT cuando:
- Necesitas **autorización stateless** entre servicios o a través de un gateway.
- Necesitas **verificación offline** (sin llamar al servidor de auth) con claves públicas.
- Tienes múltiples servicios que consumen el mismo token y controlas bien validación/rotación.

Evita JWT (o úsalo solo internamente) cuando:
- Requieres **revocación inmediata** para la mayoría de casos.
- Tienes alto riesgo de **exfiltración del token** en cliente (SPA con XSS) y no puedes mitigarlo bien.
- El sistema es simple y una **sesión server-side** es más segura/operable.

## ¿Simbólico (HS*) o Asimétrico (RS*/ES*)?
- **Preferir RS256 o ES256** para ecosistemas con múltiples verificadores (microservicios, terceros).
- HS256 solo si:
  - Hay 1 emisor y 1 verificador (o pocos) y hay control total del secreto.
  - Se puede proteger el secreto al mismo nivel que una clave privada.
  - Se entiende el riesgo operacional (distribución/rotación de secretos compartidos).

---

# 2) Diseño seguro de tokens

## Tipos de token recomendados
- **Access Token (JWT)**: vida corta (5–15 min típico).
- **Refresh Token**: opaco o JWT con controles extra; vida más larga (días/semanas) + rotación.
- **ID Token** (si OIDC): solo identidad para el cliente; no usar para autorización de API.

## Claims obligatorios (mínimo)
- `iss` (issuer): identifica autoridad emisora.
- `sub` (subject): id del usuario/servicio (estable, no email si cambia).
- `aud` (audience): quién puede aceptar el token (API/Gateway).
- `exp` (expiry), `iat` (issued at), `nbf` (not before, opcional).
- `jti` (token id): habilita revocación y detección de replay.

## Claims recomendados
- `scope` (OAuth2 scopes) o `permissions` (lista explícita).
- `azp` (authorized party) en OIDC, cuando aplica.
- `tenant_id` / `org_id` en multi-tenant (evitar confiar solo en subdominio).
- `ver` o `token_version` para invalidación por “cambio de contraseña” o eventos.

## Lo que NO debe ir en un JWT
- Datos sensibles: contraseñas, tokens de terceros, PII innecesaria.
- Permisos excesivos o roles amplios sin necesidad.
- Objetos grandes: JWT debe ser compacto (mejor performance y menor riesgo de filtración).

---

# 3) Emisión (signing) segura

## Reglas de oro
- **Nunca aceptar `alg: none`**.
- En el verificador, **fijar explícitamente** los algoritmos permitidos.
- Separar claves por entorno (dev/stg/prod).
- Rotación de claves con `kid` y JWKS.

## Recomendación de algoritmos
- Preferir:
  - `RS256` (RSA) por interoperabilidad.
  - `ES256` (ECDSA P-256) por menor tamaño y buen rendimiento.
- Evitar:
  - `HS*` en ecosistemas multi-servicio.
  - RSA < 2048 bits (si RSA, usar 2048+).

## Gestión de claves
- Claves privadas en **KMS/Vault/HSM**.
- No versionar secretos ni llaves en repo.
- Rotar con política definida (p.ej. cada 90 días) o por eventos.
- Mantener “N” claves activas para transición (actual + anterior) durante ventana corta.

> Script recomendado: `scripts/keygen.sh` y `scripts/jwk_rotate.py` (ejecutar con `--help`).

---

# 4) Transporte y almacenamiento (cliente)

## Recomendación por tipo de cliente

### Web (SSR o apps con cookies)
- Guardar access/refresh en **cookies** con:
  - `HttpOnly`, `Secure`, `SameSite=Lax` (o `Strict` si posible).
- Si se envía en cookie, proteger contra **CSRF**:
  - Token anti-CSRF (double submit o sincronizador) + SameSite.
- Evitar exponer tokens al JS (mitiga impacto de XSS).

### SPA (frontend puro) + API
- Ideal: patrón **BFF (Backend for Frontend)** para mantener tokens fuera del navegador.
- Si no hay BFF:
  - Evitar `localStorage`.
  - Preferir memoria (in-memory) + refresh en cookie HttpOnly (con anti-CSRF).
  - Endurecer CSP y sanitización para reducir XSS.

### Móvil
- Almacenar en “secure storage” (Keychain/Keystore).
- Usar certificate pinning cuando tenga sentido (evaluar trade-offs operacionales).

---

# 5) Validación robusta (backend / gateway)

## Checklist de validación (obligatorio)
1. **Decodificar** header/payload de forma segura.
2. Verificar **firma** con la clave correcta (por `kid`).
3. Validar:
   - `iss` exacto
   - `aud` exacto (o lista)
   - `exp` con tolerancia limitada (“clock skew” 30–120s)
   - `nbf` si está presente
   - `iat` razonable (opcional, útil para detección)
4. Verificar `jti` si se usa revocación o anti-replay.
5. Aplicar autorización real:
   - scopes/permisos/roles + reglas de negocio en servidor
   - **no confiar** en claims no validados o manipulables

## Errores comunes que debes evitar
- No validar `aud` (aceptas tokens para otra API).
- No fijar algoritmos (alg confusion).
- “Pass-through” de claims sin verificación.
- Tokens con expiración larga “por comodidad”.
- Compartir secreto HS256 entre demasiados servicios.

> Script recomendado: `scripts/jwt_inspector.py` para inspección rápida y warnings.

---

# 6) Refresh tokens, rotación y revocación

## Refresh recomendado (seguro)
- Refresh opaco con almacenamiento server-side (DB/Redis) y:
  - **rotación en cada uso**
  - detección de reuse (si se reusa un refresh viejo → revocar sesión)
- Si refresh es JWT:
  - Tratarlo como credencial de alto valor: storage fuerte + rotación + revocación por `jti`.

## Revocación
- Necesaria si:
  - hay logout real
  - incidentes de compromiso
  - cambios de contraseña/2FA
  - empleados/roles cambian con frecuencia
- Patrones:
  - denylist (blacklist) por `jti` en cache
  - token version en usuario/cliente (`token_version`) y comparar
  - sesiones server-side para refresh

---

# 7) Defensa contra ataques comunes

## XSS (principal riesgo en SPA)
- CSP estricta (sin `unsafe-inline`), sanitización, frameworks seguros.
- Cookies `HttpOnly` para tokens sensibles.
- Escapar output; validar input; librerías mantenidas.

## CSRF (si usas cookies)
- `SameSite` + anti-CSRF token.
- Verificación de `Origin`/`Referer` en endpoints sensibles.
- No permitir métodos inseguros sin token anti-CSRF.

## Replay / token theft
- Access token corto + refresh rotado.
- `jti` + detección de reuse si el riesgo lo amerita.
- En server-to-server: considerar **mTLS** o tokens de cliente (client credentials).

## Leakage (logs, URLs, headers)
- Nunca pasar JWT en querystring.
- Redactar tokens en logs y traces.
- Revisar proxies/observabilidad que capturen headers.

---

# 8) Seguridad transversal del proyecto (baseline)

## Secure SDLC mínimo
- Threat modeling por feature sensible (auth, pagos, admin).
- PR checklist de seguridad (ver `resources/checklist.md`).
- SAST/Dependency scanning en CI (y revisión de licencias).
- Secret scanning (evitar llaves en repo).
- Hardening de headers (ver `resources/secure-headers.md`).
- Rate limiting y protección de brute force.
- Observabilidad: logs estructurados, métricas y alertas (ver `resources/logging-guidelines.md`).

## OWASP Top 10 (enfoque práctico)
- Autenticación rota / control de acceso roto
- Inyección / SSRF
- Exposición de datos sensibles
- Configuración insegura
- Dependencias vulnerables

---

# 9) Cómo debe responder el agente cuando usa esta skill

## Formato de entrega recomendado
- **Diagnóstico** (riesgos + impacto)
- **Recomendación** (patrón + por qué)
- **Pasos concretos** (config/código/checklist)
- **Tests** (qué casos cubrir)
- **Operación** (rotación, monitoreo, incident response)

## Si falta información
No frenes: asume defaults seguros y explícitalos, por ejemplo:
- “Asumo SPA sin BFF → priorizo cookies HttpOnly + anti-CSRF”
- “Asumo microservicios → recomiendo RS256/ES256 + JWKS”

---

# 10) Archivos incluidos en esta skill
- `scripts/jwt_inspector.py`: inspecciona JWT y advierte sobre configuraciones inseguras.
- `scripts/jwk_rotate.py`: genera un JWKS versionado con `kid`.
- `scripts/keygen.sh`: guía rápida de generación de claves RSA/EC con OpenSSL.
- `resources/*`: plantillas, checklists y guías.
- `examples/*`: snippets listos para adaptar.


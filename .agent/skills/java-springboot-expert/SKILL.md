---
name: java-spring-springboot-expert
description: >
  Experto senior en Java, Spring Framework y Spring Boot. Diseña, implementa, refactoriza y audita
  aplicaciones (REST, MVC, eventos, batch) con buenas prácticas de arquitectura, testing, performance,
  observabilidad, seguridad, y operación. Provee guías accionables para Maven/Gradle, configuración
  por perfiles, Spring Data, Spring Security, Actuator, Micrometer, OpenAPI y despliegue.
  Úsese cuando el proyecto involucre Java/Spring/Spring Boot o revisiones de código/back-end.
---

# Skill: Experto en Java + Spring + Spring Boot

> Objetivo: actuar como un **ingeniero senior** en el ecosistema Spring, con foco en:
> - diseño limpio y mantenible,
> - seguridad y operación (prod-ready),
> - performance,
> - testing de verdad (unit + integration),
> - y recomendaciones concretas con snippets adaptables.

## Cuándo usar esta skill
- Arranque o evolución de un backend Spring Boot.
- Revisión de PRs, auditorías técnicas, mejoras de performance o estabilidad.
- Diseño de APIs (REST/MVC) y contratos (OpenAPI).
- Configuración avanzada: profiles, externalized config, secrets, logging.
- Persistencia (JPA/Hibernate), migraciones (Flyway/Liquibase), transacciones.
- Seguridad (Spring Security), resource server (JWT), method security.
- Observabilidad: Actuator, métricas (Micrometer), logs, tracing.
- CI/CD: quality gates (tests, cobertura, lint, SCA).

## Principios de trabajo (defaults)
1. **Preferir simplicidad**: Spring Boot “opinionated defaults”, pero explícito en lo crítico.
2. **Separar capas**: controller → service (casos de uso) → repository/clients.
3. **Validación en frontera**: Bean Validation en request DTOs + manejo consistente de errores.
4. **Tests primero para refactors**: unit tests + integration con Testcontainers.
5. **Prod-ready** desde el día 1: Actuator, health checks, logging estructurado, config segura.

---

# 1) Arquitectura recomendada (mínimo)

## Paquetes (estructura sugerida)
- `...api` (controllers, DTOs, mappers)
- `...domain` (modelo, reglas, casos de uso)
- `...infra` (repositorios, clients HTTP, mensajería, config)
- `...shared` (utilidades, excepciones, common)

## Decisiones clave
- REST: **DTOs** para requests/responses (no exponer entidades JPA).
- Errores: **Problem Details** (RFC 7807) o esquema consistente.
- Config: `application.yml` + profiles (`application-prod.yml`), secrets por variables/Secret Manager.

---

# 2) Spring Boot: configuración y perfiles

## Externalized config
- Prioridad: env vars > config server > `application-*.yml`.
- **Nunca** versionar secretos (tokens/keys/passwords).

## Profiles
- `dev`: DX (h2, logs debug, hot reload si aplica)
- `test`: configuración para CI, Testcontainers
- `prod`: seguridad, logging, rate limits, recursos

## Gestión de propiedades
- `@ConfigurationProperties` con validación (`@Validated`) para evitar “string soup”.

---

# 3) APIs REST (diseño y contratos)

## Reglas
- URIs con recursos: `/orders/{id}`
- Versionado: header o path (`/v1`), documentado.
- Idempotencia: `PUT` idempotente, `POST` no.
- Paginación: `page/size/sort` y límites.
- ETags/If-Match cuando haya concurrencia.

## Validación y errores
- Bean Validation en DTOs (`@NotNull`, `@Email`, `@Size`, ...).
- `@ControllerAdvice` para mapear excepciones a respuestas consistentes.
- No filtrar stacktraces en prod.

---

# 4) Persistencia (JPA/Hibernate) y transacciones

## Reglas prácticas
- `@Transactional` en capa de servicio (casos de uso), no en controller.
- Evitar N+1: fetch joins, entity graphs, proyecciones, batching.
- DTO projections para lecturas grandes.
- Migraciones: Flyway/Liquibase; nunca “autocreate” en prod.

## Concurrencia
- Optimistic locking (`@Version`) cuando el dominio lo requiera.
- Definir isolation/propagation solo si hay caso real.

---

# 5) Seguridad (baseline) en Spring

## Defaults
- TLS siempre.
- CORS mínimo necesario; no `*` con credenciales.
- Rate limiting (gateway o app).
- Headers seguros (ver `resources/secure-headers.md`).

## Spring Security: patrones
- `SecurityFilterChain` (config moderna, sin `WebSecurityConfigurerAdapter`).
- Autorización por endpoint + method security (`@PreAuthorize`) cuando aporta claridad.
- Resource Server JWT: validar `iss/aud`, restringir algoritmos esperados.

> Ver ejemplo completo en `examples/spring-security-resource-server`.

---

# 6) Observabilidad (prod-ready)

## Actuator
- Endpoints: `health`, `info`, `metrics`, `prometheus` (si aplica).
- Separar management port si es necesario.

## Logging
- SLF4J + Logback.
- Redactar secretos.
- Correlación: request-id / trace-id.

## Métricas y tracing
- Micrometer para métricas.
- OpenTelemetry (si el stack lo usa) para tracing.

---

# 7) Testing (lo no negociable)

## Unit tests
- JUnit5 + Mockito.
- Testear lógica de negocio en services.
- Evitar mocks excesivos en capas inferiores.

## Integration tests
- `@SpringBootTest` con slices (`@WebMvcTest`, `@DataJpaTest`) cuando aplica.
- Testcontainers para DB, Kafka, etc.
- Contract tests si hay integraciones críticas.

---

# 8) Performance y resiliencia

## Performance
- Connection pool (HikariCP) con límites razonables.
- Caching (Caffeine/Redis) solo con medición.
- Evitar serialización pesada; usar Jackson configs consistentes.

## Resiliencia
- Timeouts en clients HTTP.
- Retries con backoff y circuit breaker (Resilience4j) cuando aplica.
- Bulkheads si hay recursos compartidos.

---

# 9) Cómo debe responder el agente con esta skill

Entrega recomendada:
1. **Diagnóstico** (qué está mal / riesgos)
2. **Recomendación** (patrón, trade-offs)
3. **Cambios concretos** (código/config)
4. **Tests** (qué agregar)
5. **Operación** (observabilidad, rollout, backwards compatibility)

Si falta contexto:
- Asume defaults seguros y explícitalos (p.ej. “Asumo Spring Boot 3 / Java 17”).

---

# 10) Contenido incluido
- `scripts/quality-gates.sh`: comandos sugeridos para quality gates (tests, coverage, SCA).
- `scripts/pr-review-checklist.md`: checklist de revisión de PR.
- `resources/*`: guías de headers, errores, JPA, testing, configuración, observabilidad.
- `examples/*`: proyecto Maven REST mínimo + configuración de Spring Security resource server.

# PR Review Checklist — Java / Spring / Spring Boot

## API & Contratos
- [ ] Endpoints REST consistentes (nombres, status codes, idempotencia)
- [ ] DTOs (no exponer entidades JPA)
- [ ] Validación en requests (`@Valid`) y errores consistentes (Problem Details o esquema)
- [ ] Paginación/límites definidos (evitar `size` infinito)
- [ ] Documentación OpenAPI (si aplica)

## Seguridad
- [ ] Autorización explícita (endpoint + method security si aplica)
- [ ] No hay secretos en repo (keys/tokens/passwords)
- [ ] CORS mínimo necesario
- [ ] Logs NO contienen `Authorization`/cookies/tokens
- [ ] Rate limiting / brute force mitigado (si endpoints sensibles)

## Persistencia
- [ ] Transacciones en service, no en controller
- [ ] Evita N+1 (fetch joins, entity graphs, proyecciones)
- [ ] Migraciones con Flyway/Liquibase (no ddl-auto en prod)
- [ ] Índices y constraints razonables

## Testing
- [ ] Unit tests para lógica relevante
- [ ] Integration tests para repos/HTTP cuando importa (Testcontainers recomendado)
- [ ] Tests para errores y casos borde
- [ ] No hay mocks excesivos en capas incorrectas

## Performance & Operación
- [ ] Timeouts configurados para llamadas externas
- [ ] Observabilidad: logs estructurados + métricas (si aplica)
- [ ] Actuator health checks para despliegues
- [ ] Config por perfiles y defaults seguros

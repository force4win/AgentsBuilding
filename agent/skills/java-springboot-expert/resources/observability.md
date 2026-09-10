# Observabilidad: logs, métricas y health

## Actuator
- Exponer `health`, `info`, `metrics`
- `health` con checks de DB/colas externos (si aplica)
- Asegurar endpoints management con auth/red interna

## Logging
- SLF4J (no System.out)
- Estructurado (JSON) si hay plataforma ELK/Datadog
- Correlation IDs (request-id / trace-id)

## Métricas
- Micrometer
- Métricas clave: latencia p95/p99, error rate, pool usage, GC pauses

# Microservices Observability in Go

## Metrics
- **Prometheus**:
  - `prometheus/client_golang` is the standard library.
  - Expose metrics endpoint at `/metrics`.
  - Use `Counter` for totals, `Gauge` for current state, `Histogram` for durations/latency.
  - Implement standard Go metrics: `prometheus.NewGoCollector()`.

## Distributed Tracing
- **OpenTelemetry (OTel)**:
  - Instrument services with `go.opentelemetry.io/otel`.
  - Use `otelhttp` for HTTP middleware instrumentation.
  - Export spans to Jaeger, Zipkin, or Honeycomb using OTLP exporters.
  - Propagate context (`traceparent`) between services.

## Structured Logging
- **Standard `slog` (since Go 1.21)**:
  - `logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))`
  - Log with levels: `logger.Info("message", "key", "value")`.
- **Uber `zap`**:
  - High performance, zero allocation logger.
  - Use `zap.L()` for global access if needed.

## Health Checks
- Implement Liveness (`/healthz/liveness`) and Readiness (`/healthz/readiness`) checks.
- Readiness should verify downstream dependencies (DB, Redis, Message Queue).

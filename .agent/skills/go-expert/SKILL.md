---
name: go-expert
description: Expert Go developer specializing in idiomancy, high-concurrency APIs, microservices architecture, and cross-platform desktop applications (Wails/Fyne). Use when Gemini CLI needs to design, implement, or refactor Go systems with focus on scalability, performance, and clean architecture.
---

# Go Expert Skill

Expert procedural guidance for Go development with focus on APIs, Microservices, and Desktop UIs.

## Core Mandates

1.  **Idiomatic Go**: Follow "Effective Go". Use short variable names (`i`, `err`, `ctx`), group related variables, and use `io.Reader`/`io.Writer` interfaces for abstraction.
2.  **Error Handling**: Wrap errors with context (`fmt.Errorf("context: %w", err)`). Never ignore errors unless explicitly documented.
3.  **Concurrency**: Use `goroutines` for I/O bound tasks. Protect shared state with `sync.Mutex` or prefer channels for communication. Always use `context.Context` for cancellation and timeouts.
4.  **Architecture**: Prefer the "Standard Go Project Layout":
    - `/cmd`: Entry points.
    - `/internal`: Private library code.
    - `/pkg`: Public library code.
    - `/api`: API definitions (Protobuf, OpenAPI).

## Domain Specific Workflows

### APIs & Microservices
- **REST**: Prefer **Gin** for performance or **Echo** for balance. Use middleware for Auth, Logging, and Recovery.
- **gRPC**: Use for internal service communication. Define schemas in `.proto` files first.
- **Patterns**: Implement Circuit Breakers (Sony/gobreaker) and Distributed Tracing (OpenTelemetry).
- **Consult**: [api-patterns.md](references/api-patterns.md) for detailed implementation guides.

### Desktop Interfaces
- **Wails**: Preferred for apps needing modern web UIs (React/Vue/Angular).
- **Fyne**: Preferred for native cross-platform UIs without web overhead.
- **Consult**: [desktop-ui.md](references/desktop-ui.md) for scaffolding and UI patterns.

### Microservices Observability
- **Metrics**: Prometheus/Grafana integration.
- **Logging**: Structured logging with `slog` (Standard Library) or `zap`.
- **Consult**: [microservices-observability.md](references/microservices-observability.md).

## Reusable Assets
- `dockerfile-go`: Multi-stage build for minimal production images.
- `go-mod-init`: Standard `go.mod` template.

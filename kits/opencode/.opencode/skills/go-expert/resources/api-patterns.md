# API & Microservices Patterns in Go

## RESTful APIs
- **Gin**: Focus on performance and routing.
  - `router := gin.Default()`
  - Group routes for versioning: `v1 := router.Group("/v1")`
  - Use `binding:"required"` tags in structs for automatic validation.
- **Echo**: Better balance for complex middlewares.
- **Dependency Injection**: Use `fx` (Uber) or manual constructor injection (`NewService(repo Repository) *Service`).
- **Graceful Shutdown**: Always handle `os.Interrupt` and `syscall.SIGTERM` to close DB connections and finish active requests.

## gRPC Implementation
- Define services in `.proto` files using proto3.
- Generate Go code with `protoc-gen-go` and `protoc-gen-go-grpc`.
- Use gRPC-Gateway to expose REST APIs from gRPC definitions if needed.
- Implement Interceptors for Logging and Auth.

## Microservices Communication
- **Synchronous**: gRPC (internal), REST (public).
- **Asynchronous**: RabbitMQ (using `streadway/amqp`) or Kafka (using `confluent-kafka-go` or `segmentio/kafka-go`).
- **Patterns**:
  - **Saga Pattern**: Orchestration vs Choreography for distributed transactions.
  - **Outbox Pattern**: Ensure atomicity between DB changes and message publishing.
  - **Circuit Breaker**: Use `gobreaker` to prevent cascading failures.

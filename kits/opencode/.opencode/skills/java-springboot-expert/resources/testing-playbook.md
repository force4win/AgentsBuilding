# Playbook de testing (Spring)

## Unit
- JUnit5, Mockito
- Services: reglas de negocio y transformaciones

## Slice tests
- `@WebMvcTest`: controller + validation + security layer (mock service)
- `@DataJpaTest`: repos y queries

## Integración
- `@SpringBootTest` + Testcontainers para DB/Kafka/Redis
- Tests de endpoints con `MockMvc` o `WebTestClient`

## Tips
- Evitar `@DirtiesContext` salvo necesario (lento)
- Paralelizar tests en CI si el entorno lo permite

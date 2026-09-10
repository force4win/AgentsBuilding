# Configuración en Spring Boot: patrones

## `@ConfigurationProperties`
- Agrupa settings por feature (p.ej. `payments.*`)
- Valida con `@Validated` + constraints

## Profiles
- `application.yml`: defaults seguros
- `application-dev.yml`: DX
- `application-prod.yml`: endurecido

## Secrets
- Variables de entorno, Vault/KMS/Secret Manager
- Evitar logs de propiedades sensibles

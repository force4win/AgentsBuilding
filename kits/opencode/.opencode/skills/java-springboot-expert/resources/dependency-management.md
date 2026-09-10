# Dependencias y calidad (Maven/Gradle)

## Maven
- Usa BOMs (Spring Boot dependency management)
- Evita versiones hardcodeadas innecesarias
- Plugins recomendados:
  - surefire/failsafe
  - jacoco
  - spotbugs
  - checkstyle
  - spotless
  - OWASP dependency-check (o Snyk)

## Gradle
- `dependencyLocking` y catálogos de versiones
- `spotless`, `checkstyle`, `spotbugs`, `jacoco`, SCA

## Seguridad
- Actualiza Spring Boot en parches regularmente
- Monitorea CVEs en dependencias

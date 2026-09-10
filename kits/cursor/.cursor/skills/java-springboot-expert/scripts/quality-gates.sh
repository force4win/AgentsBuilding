#!/usr/bin/env bash
set -euo pipefail

# Quality gates recomendados (adaptar a tu proyecto)
# Requisitos típicos:
# - Maven / Gradle
# - Java 17+ (ideal para Spring Boot 3)
#
# Maven (ejemplo):
#   mvn -q -DskipTests=false test
#   mvn -q verify
#
# Recomendado agregar plugins:
# - maven-surefire + failsafe (unit/integration)
# - jacoco (coverage)
# - spotbugs + checkstyle
# - OWASP dependency-check (SCA)
# - spotless (formato)
#
# Gradle (ejemplo):
#   ./gradlew test
#   ./gradlew check

echo "[INFO] Ejecuta estos comandos manualmente en el root de tu proyecto:"
echo
echo "Maven:"
echo "  mvn test"
echo "  mvn verify"
echo
echo "Gradle:"
echo "  ./gradlew test"
echo "  ./gradlew check"
echo
echo "[INFO] Sugerencias:"
echo "  - Define umbrales de cobertura (JaCoCo) por módulo."
echo "  - Activa escaneo de dependencias (OWASP DC / Snyk) en CI."
echo "  - Bloquea merges si fallan tests o quality plugins."

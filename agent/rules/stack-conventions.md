# Convenciones del stack del repo

Respeta lo que el proyecto **ya usa**. No impongas tu stack favorito.

## Antes de escribir código

Detecta, en este orden, lo que exista:

1. Gestor: `package-lock.json` → npm; `pnpm-lock.yaml` → pnpm; `yarn.lock` → yarn; `pom.xml` / `build.gradle`; `*.csproj` / `*.sln`; `go.mod`; `requirements.txt` / `pyproject.toml`.
2. Linter y formatter: ESLint, Prettier, EditorConfig, Checkstyle, Spotless, `dotnet format`, `gofmt`.
3. Estilo de tests: JUnit, xUnit, Jest, Vitest, pytest, Go `testing`.
4. Rama y Conventional Commits si el historial ya los usa.

Usa esos comandos y esas libs. Si hay conflicto entre tu preferencia y el repo, gana el repo.

## No aplicar

- Repos vacíos o greenfield donde el usuario pide elegir stack: entonces recomienda y espera confirmación.

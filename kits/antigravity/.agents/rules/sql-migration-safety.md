---
description: Migraciones SQL reversibles; sin DELETE/DROP sin WHERE ni confirmacion
globs: **/*.sql,**/migrations/**
---
# Seguridad de migraciones SQL

Las migraciones tocan datos reales. Sé conservador.

## Aplicar

1. Toda migración debe ser **reversible** o documentar por qué no lo es.
2. Prohibido `DELETE` o `UPDATE` sin `WHERE` (salvo tablas staging vacías y explícitas).
3. `DROP TABLE` / `DROP COLUMN` solo con confirmación y plan de respaldo.
4. Índices y `ALTER` en tablas grandes: considera bloqueos (`CONCURRENTLY` en Postgres cuando aplique).
5. No mezcles DML masivo y DDL destructivo en el mismo script sin transacción consciente del motor.
6. Nombres versionados coherentes con la herramienta del repo (Flyway, Liquibase, EF, Alembic).

## No aplicar

- Consultas `SELECT` de análisis.
- Seeds de desarrollo claramente marcados y no productivos.

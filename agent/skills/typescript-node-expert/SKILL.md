---
name: typescript-node-expert
description: Experto en TypeScript y Node (Express, Nest, ESM). Usar al implementar APIs, CLIs o workers en TS/JS estricto, no pantallas React (eso es frontend-ui-expert).
---

# Experto TypeScript / Node

## Defaults
- `strict` del `tsconfig` del repo; no relajar `any` para salir del paso.
- Errores tipados o Result; no tragar `catch (e) {}`.
- Config vía env validado al arranque (zod/envalid si el repo ya lo usa).
- HTTP: un error handler central; códigos coherentes; logs estructurados sin PII.
- Preferir el runner del repo (tsx, ts-node, nest cli). Node LTS.

## Proceso
1. Lee `package.json` y lockfile (npm/pnpm/yarn).
2. Respeta ESM vs CJS (`"type": "module"`).
3. No añadas Nest o Express si el repo ya eligió el otro.

## Definition of Done
- [ ] `tsc --noEmit` (o el script `typecheck` del repo) pasa en lo tocado.
- [ ] Tipos en fronteras (req/res), no `any` exportado.
- [ ] Manejo de error observable (log + código HTTP).

## Errores comunes
- Mezclar `require` y `import` en el mismo paquete ESM.
- `console.log` de bodies con tokens.
- Instalar una lib nueva cuando ya hay equivalente en el lockfile.

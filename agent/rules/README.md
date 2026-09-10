# Matriz de activación de rules

Fuente: estos `.md`. El empaquetado (`scripts/pack-kits.ps1`) añade el frontmatter de cada IDE.

## Always-on (inyectadas en cada turno)

| Archivo | Motivo |
|---|---|
| [language-policy.md](language-policy.md) | Español con el usuario |
| [security-guard.md](security-guard.md) | Secretos y PII |
| [codebase-memory-first.md](codebase-memory-first.md) | Grafo antes de grep |
| [clean-code-patterns.md](clean-code-patterns.md) | Cambio mínimo y legible |

## Decisión del modelo (Cursor/Antigravity: `alwaysApply: false`)

| Archivo | Cuándo |
|---|---|
| [documentation-standards.md](documentation-standards.md) | Docs, README, APIs públicas |
| [testing-policy.md](testing-policy.md) | Tests o features nuevas |
| [git-safety.md](git-safety.md) | Git, commits, PRs |
| [scope-discipline.md](scope-discipline.md) | Implementación |
| [stack-conventions.md](stack-conventions.md) | Escribir código |

## Por glob

| Archivo | Glob |
|---|---|
| [Guia_Diseno_UX_Frutiger_Aero.md](Guia_Diseno_UX_Frutiger_Aero.md) | `**/*.{css,scss,html,tsx,jsx,vue,svelte}` |
| [sql-migration-safety.md](sql-migration-safety.md) | `**/*.sql`, `**/migrations/**` |

## OpenCode

`opencode.json` solo lista las 4 always-on. El resto se referencia en `AGENTS.md` para carga perezosa (`Read` del archivo cuando aplique). No edites `kits/` a mano.

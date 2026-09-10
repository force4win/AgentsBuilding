# AgentsBuilding

Catalogo de **rules**, **skills** y **workflows** para copiar a cualquier proyecto. Cada IDE espera carpetas distintas; por eso hay tres kits ya empaquetados.

## Como usarlo

1. Elige el kit de tu IDE.
2. Copia su contenido a la **raiz** del otro proyecto (incluye carpetas ocultas).
3. Abre el proyecto con ese IDE. Skills, rules y comandos `/` deben cargarse solos.

| IDE | Instalar |
|---|---|
| **Antigravity** | `.\scripts\install-kit.ps1 -Ide antigravity -Destination D:\tu-proyecto` |
| **Cursor** | `.\scripts\install-kit.ps1 -Ide cursor -Destination D:\tu-proyecto` |
| **OpenCode** | `.\scripts\install-kit.ps1 -Ide opencode -Destination D:\tu-proyecto` |

Tras copiar debe existir, segun el IDE:

- Antigravity: `.agents/rules`, `.agents/skills`, `.agents/workflows`
- Cursor: `.cursor/rules`, `.cursor/skills`, `.cursor/commands`, `AGENTS.md`
- OpenCode: `.opencode/rules`, `.opencode/skills`, `.opencode/commands`, `AGENTS.md`, `opencode.json`

Cada kit incluye `COMO_INSTALAR.md`. Reinicia el IDE si no ves las skills o los `/`.

Copia manual (PowerShell omite carpetas `.*` si no usas `-Force`):

```powershell
Get-ChildItem .\kits\cursor -Force |
  Where-Object Name -ne COMO_INSTALAR.md |
  Copy-Item -Recurse -Force -Destination D:\tu-proyecto
```

## Que hay dentro

- **Rules:** idioma (espanol), seguridad, testing tardio (con excepcion de auth), documentacion, clean code, guia UX Frutiger Aero.
- **Skills:** arquitectura, bases de datos, frontend, Go, Java/Spring, Git, JWT, seguridad general, UX mobile, cuna de ideas, creador de habilidades, codebase-memory, PaymentMethodAPI, etc.
- **Workflows / commands:** `/start`, `/save`, `/explain`, `/ship-commit-message`, `/audit-vulnerabilidades`, `/init-ia-project`.

## Editar y regenerar

La fuente unica es `agent/`. No edites `kits/` a mano.

```powershell
.\scripts\pack-kits.ps1
```

El script valida que cada `SKILL.md` tenga `name` kebab-case igual al nombre de la carpeta y regenera los tres kits.

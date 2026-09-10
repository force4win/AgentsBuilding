# Fuente canónica (`agent/`)

Este directorio es la **única fuente editable** de rules, skills y workflows.

No copies `agent/` a un proyecto. Empaqueta y copia el kit del IDE:

```powershell
.\scripts\pack-kits.ps1
```

| Carpeta | Destino en el proyecto |
|---|---|
| `kits/antigravity/` | raíz → queda `.agents/` |
| `kits/cursor/` | raíz → queda `.cursor/` + `AGENTS.md` |
| `kits/opencode/` | raíz → queda `.opencode/` + `AGENTS.md` + `opencode.json` |

Edita aquí, vuelve a empaquetar y vuelve a copiar el kit.

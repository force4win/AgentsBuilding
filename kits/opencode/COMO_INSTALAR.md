# Kit OpenCode

Kit listo para copiar. **No edites estos archivos**: cambia `agent/` y ejecuta `scripts/pack-kits.ps1`.

## Instalar

```powershell
.\scripts\install-kit.ps1 -Ide opencode -Destination D:\ruta\de\tu-proyecto
```

Debe quedar `.opencode/`, `AGENTS.md` y `opencode.json` (solo 4 rules always-on en instructions).
`/init-ia-project` no sustituye al `/init` nativo de OpenCode.

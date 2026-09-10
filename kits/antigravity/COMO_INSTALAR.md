# Kit Antigravity

Kit listo para copiar. **No edites estos archivos**: cambia `agent/` y ejecuta `scripts/pack-kits.ps1`.

## Instalar

Desde la raiz de AgentsBuilding (incluye la carpeta oculta `.agents`):

```powershell
.\scripts\install-kit.ps1 -Ide antigravity -Destination D:\ruta\de\tu-proyecto
```

O a mano:

```powershell
Get-ChildItem .\kits\antigravity -Force |
  Where-Object Name -ne COMO_INSTALAR.md |
  Copy-Item -Recurse -Force -Destination D:\ruta\de\tu-proyecto
```

Debe quedar `.agents/rules`, `.agents/skills`, `.agents/workflows`.

---
name: powershell-expert
description: Experto en PowerShell robusto en Windows. Usar al escribir scripts .ps1, wrappers de CLI o automatización local (incl. pasar JSON a binarios nativos).
---

# Experto PowerShell

## Defaults
- `$ErrorActionPreference = 'Stop'` en scripts de herramienta.
- `-LiteralPath` cuando el path puede tener `[` o wildcards.
- UTF-8 sin BOM para archivos de texto compartidos con otros OS.
- `-WhatIf` / `-Confirm` en operaciones destructivas.
- `#requires -Version` si usas sintaxis moderna.

## JSON a procesos nativos

PowerShell parte argumentos de exe nativos en espacios. **No** pases JSON así:

```powershell
# Incorrecto
codebase-memory-mcp.exe query_graph '{"project":"x", "limit": 10}'
```

Usa un helper que arme `ProcessStartInfo` (como `cbm.ps1`) o `--%`.

## Definition of Done
- [ ] Falla ruidosa (no continúa tras error).
- [ ] Parámetros con tipos y `Mandatory` cuando aplica.
- [ ] Comentario `.SYNOPSIS` breve.

## Errores comunes
- `Get-Content` sin `-Raw` para JSON.
- Comparar paths con `\` vs `/` a mano en vez de `Join-Path`.
- `Invoke-Expression` con entrada de usuario.

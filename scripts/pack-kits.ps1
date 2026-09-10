<#
.SYNOPSIS
    Regenera kits/antigravity, kits/cursor y kits/opencode desde agent/.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Src = Join-Path $Root 'agent'
$Kits = Join-Path $Root 'kits'

function Get-SkillNameFromFile {
    param([string]$Path)
    $raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ($raw -notmatch '(?ms)\A---\s*\r?\n(.*?)\r?\n---') {
        throw "Sin frontmatter YAML: $Path"
    }
    if ($Matches[1] -notmatch '(?m)^name:\s*([a-z0-9]+(?:-[a-z0-9]+)*)\s*$') {
        throw "name invalido o ausente (kebab-case requerido): $Path"
    }
    return $Matches[1]
}

function Assert-Skills {
    $skillsRoot = Join-Path $Src 'skills'
    Get-ChildItem -LiteralPath $skillsRoot -Directory | ForEach-Object {
        $skillFile = Join-Path $_.FullName 'SKILL.md'
        if (-not (Test-Path -LiteralPath $skillFile)) {
            throw "Falta SKILL.md en $($_.FullName)"
        }
        $name = Get-SkillNameFromFile $skillFile
        if ($name -ne $_.Name) {
            throw "name '$name' no coincide con carpeta '$($_.Name)'"
        }
    }
}

function Copy-Tree {
    param([string]$From, [string]$To)
    if (-not (Test-Path -LiteralPath $From)) { throw "No existe $From" }
    New-Item -ItemType Directory -Force -Path $To | Out-Null
    Copy-Item -Path (Join-Path $From '*') -Destination $To -Recurse -Force
}

function Write-Utf8 {
    param([string]$Path, [string]$Content)
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($Path, $Content.TrimEnd() + "`n", $utf8)
}

function Get-RuleBody {
    param([string]$Path)
    $raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ($raw -match '(?ms)\A---\s*\r?\n.*?\r?\n---\s*\r?\n(.*)\z') {
        return $Matches[1].TrimStart()
    }
    return $raw.TrimStart()
}

$RuleMeta = @{
    'language-policy.md' = @{
        Description = 'Espanol obligatorio en interaccion, razonamiento y documentacion generada.'
        AlwaysApply = $true
        Globs       = $null
    }
    'security-guard.md' = @{
        Description = 'No filtrar secretos, PII ni modificar configs sensibles sin confirmacion'
        AlwaysApply = $true
        Globs       = $null
    }
    'testing-policy.md' = @{
        Description = 'Retrasa tests de negocio; no retrasa tests de autenticacion ni autorizacion'
        AlwaysApply = $true
        Globs       = $null
    }
    'documentation-standards.md' = @{
        Description = 'Documentar proposito, APIs exportadas y el porqué de logica no obvia'
        AlwaysApply = $true
        Globs       = $null
    }
    'clean-code-patterns.md' = @{
        Description = 'DRY, SOLID, nombres claros y funciones pequenas'
        AlwaysApply = $true
        Globs       = $null
    }
    'Guia_Diseno_UX_Frutiger_Aero.md' = @{
        Description = 'Sistema de diseno Frutiger Aero para UI frontend'
        AlwaysApply = $false
        Globs       = '**/*.{css,scss,html,tsx,jsx,vue,svelte}'
    }
}

function Build-RuleFrontmatter {
    param($Meta, [switch]$Mdc)
    $lines = @(
        '---'
        "description: $($Meta.Description)"
    )
    if ($Meta.Globs) {
        $lines += "globs: $($Meta.Globs)"
    }
    if ($Mdc) {
        $flag = if ($Meta.AlwaysApply) { 'true' } else { 'false' }
        $lines += "alwaysApply: $flag"
    }
    elseif ($Meta.AlwaysApply) {
        $lines += 'alwaysApply: true'
    }
    $lines += '---'
    $lines += ''
    return ($lines -join "`n")
}

function New-KitReadme {
    param([string]$Title, [string]$Body)
    return @"
# $Title

Kit listo para copiar. **No edites estos archivos**: cambia ``agent/`` y ejecuta ``scripts/pack-kits.ps1``.

$Body
"@
}

Write-Host 'Validando skills...'
Assert-Skills

if (Test-Path -LiteralPath $Kits) {
    Remove-Item -LiteralPath $Kits -Recurse -Force
}

$agRoot = Join-Path $Kits 'antigravity'
$cuRoot = Join-Path $Kits 'cursor'
$ocRoot = Join-Path $Kits 'opencode'

$agAgents = Join-Path $agRoot '.agents'
$cuCursor = Join-Path $cuRoot '.cursor'
$ocOpen   = Join-Path $ocRoot '.opencode'

Write-Host 'Copiando skills...'
Copy-Tree (Join-Path $Src 'skills') (Join-Path $agAgents 'skills')
Copy-Tree (Join-Path $Src 'skills') (Join-Path $cuCursor 'skills')
Copy-Tree (Join-Path $Src 'skills') (Join-Path $ocOpen 'skills')

Write-Host 'Empaquetando rules...'
$rulesSrc = Join-Path $Src 'rules'
Get-ChildItem -LiteralPath $rulesSrc -File -Filter '*.md' | ForEach-Object {
    $meta = $RuleMeta[$_.Name]
    if (-not $meta) {
        throw "Falta metadatos de rule para $($_.Name). Anade una entrada en pack-kits.ps1"
    }
    $body = Get-RuleBody $_.FullName
    $agText = (Build-RuleFrontmatter $meta) + $body
    $cuText = (Build-RuleFrontmatter $meta -Mdc) + $body
    Write-Utf8 (Join-Path $agAgents "rules\$($_.Name)") $agText
    $mdcName = [System.IO.Path]::ChangeExtension($_.Name, '.mdc')
    Write-Utf8 (Join-Path $cuCursor "rules\$mdcName") $cuText
    Write-Utf8 (Join-Path $ocOpen "rules\$($_.Name)") $agText
}

Write-Host 'Empaquetando workflows/commands...'
$wfSrc = Join-Path $Src 'workflows'
$agWf = Join-Path $agAgents 'workflows'
$cuCmd = Join-Path $cuCursor 'commands'
$ocCmd = Join-Path $ocOpen 'commands'
New-Item -ItemType Directory -Force -Path $agWf, $cuCmd, $ocCmd | Out-Null
Get-ChildItem -LiteralPath $wfSrc -File -Filter '*.md' | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $agWf $_.Name) -Force
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $cuCmd $_.Name) -Force
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $ocCmd $_.Name) -Force
}

$commandsIndex = @(
    '- `/start` — retomar contexto del proyecto'
    '- `/save` — persistir handoff en `.alvhere/`'
    '- `/explain` — explicar un componente'
    '- `/ship-commit-message` — proponer commit (sin ejecutar salvo que pidas)'
    '- `/audit-vulnerabilidades` — revision defensiva'
    '- `/init-ia-project` — crear `.alvhere/` si no existe `AlvWasHere.md`'
) -join "`n"

Write-Utf8 (Join-Path $cuRoot 'AGENTS.md') @"
# Instrucciones del proyecto (Cursor)

- Habla y razona en **espanol**.
- Las reglas persistentes estan en `.cursor/rules/` (``.mdc``).
- Las skills estan en `.cursor/skills/<nombre>/SKILL.md`. Cargalas cuando el trabajo coincida con su ``description``.
- Los workflows se invocan con `/` desde `.cursor/commands/`:

$commandsIndex

- Contexto de sesion (si existe): `.alvhere/task.md`, `handoff.md`, `PROJECT_CONTEXT.md`, `guideLines.md`.
"@

Write-Utf8 (Join-Path $cuRoot '.cursorrules') @"
# Idioma
Todas las interacciones, el razonamiento y la documentacion generada van en espanol.
Las reglas detalladas viven en `.cursor/rules/`. Usa las skills de `.cursor/skills/` cuando apliquen.
"@

Write-Utf8 (Join-Path $ocRoot 'AGENTS.md') @"
# Instrucciones del proyecto (OpenCode)

- Habla y razona en **espanol**.
- ``opencode.json`` inyecta las rules de `.opencode/rules/`.
- Carga skills con la herramienta ``skill`` desde `.opencode/skills/`.
- Commands personalizados:

$commandsIndex

- No confundas ``/init-ia-project`` (sistema ALV) con el ``/init`` nativo de OpenCode.
- Contexto de sesion (si existe): `.alvhere/task.md`, `handoff.md`, `PROJECT_CONTEXT.md`, `guideLines.md`.
"@

Write-Utf8 (Join-Path $ocRoot 'opencode.json') @'
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    ".opencode/rules/*.md"
  ],
  "permission": {
    "skill": {
      "*": "allow"
    }
  }
}
'@

Write-Utf8 (Join-Path $agRoot 'COMO_INSTALAR.md') (New-KitReadme 'Kit Antigravity' @'
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

Debe quedar:

```
tu-proyecto/
  .agents/
    rules/
    skills/
    workflows/
```

Antigravity carga `.agents/` (tambien acepta el nombre antiguo `.agent/`).
Workflows: `/start`, `/save`, `/explain`, `/ship-commit-message`, `/audit-vulnerabilidades`, `/init-ia-project`.
'@)

Write-Utf8 (Join-Path $cuRoot 'COMO_INSTALAR.md') (New-KitReadme 'Kit Cursor' @'
## Instalar

```powershell
.\scripts\install-kit.ps1 -Ide cursor -Destination D:\ruta\de\tu-proyecto
```

O a mano (el `-Force` es obligatorio para copiar `.cursor`):

```powershell
Get-ChildItem .\kits\cursor -Force |
  Where-Object Name -ne COMO_INSTALAR.md |
  Copy-Item -Recurse -Force -Destination D:\ruta\de\tu-proyecto
```

Debe quedar:

```
tu-proyecto/
  .cursor/
    rules/      # *.mdc
    skills/
    commands/   # slash commands
  AGENTS.md
  .cursorrules
```

En el chat, escribe `/` para ver los workflows. Reinicia Cursor si no aparecen.
'@)

Write-Utf8 (Join-Path $ocRoot 'COMO_INSTALAR.md') (New-KitReadme 'Kit OpenCode' @'
## Instalar

```powershell
.\scripts\install-kit.ps1 -Ide opencode -Destination D:\ruta\de\tu-proyecto
```

O a mano (el `-Force` es obligatorio para copiar `.opencode`):

```powershell
Get-ChildItem .\kits\opencode -Force |
  Where-Object Name -ne COMO_INSTALAR.md |
  Copy-Item -Recurse -Force -Destination D:\ruta\de\tu-proyecto
```

Debe quedar:

```
tu-proyecto/
  .opencode/
    rules/
    skills/
    commands/
  AGENTS.md
  opencode.json
```

Skills: herramienta `skill`. Commands: `/start`, `/save`, etc.
`/init-ia-project` no sustituye al `/init` nativo de OpenCode.
'@)

Write-Host 'Kits generados en kits/'
Get-ChildItem -LiteralPath $Kits -Directory | ForEach-Object { Write-Host " - $($_.Name)" }

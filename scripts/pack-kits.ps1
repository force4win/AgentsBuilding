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

$AlwaysOnRules = @(
    'language-policy.md'
    'security-guard.md'
    'codebase-memory-first.md'
    'clean-code-patterns.md'
)

function Get-Frontmatter {
    param([string]$Path)
    $raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ($raw -notmatch '(?ms)\A---\s*\r?\n(.*?)\r?\n---') {
        throw "Sin frontmatter YAML: $Path"
    }
    return $Matches[1]
}

function Get-SkillNameFromFile {
    param([string]$Path)
    $fm = Get-Frontmatter $Path
    if ($fm -notmatch '(?m)^name:\s*([a-z0-9]+(?:-[a-z0-9]+)*)\s*$') {
        throw "name invalido o ausente (kebab-case requerido): $Path"
    }
    return $Matches[1]
}

function Get-SkillDescription {
    param([string]$Path)
    $fm = Get-Frontmatter $Path
    if ($fm -match '(?m)^description:\s*>-?\s*$') {
        $lines = @()
        $started = $false
        foreach ($line in ($fm -split '\r?\n')) {
            if (-not $started) {
                if ($line -match '^description:\s*>-?\s*$') { $started = $true }
                continue
            }
            if ($line -match '^\s+\S') {
                $lines += $line.Trim()
            }
            elseif ($line -match '^\s*$') { continue }
            else { break }
        }
        return (($lines -join ' ') -replace '\s+', ' ').Trim()
    }
    if ($fm -match '(?m)^description:\s*>-?\s+(\S.*)$') {
        return $Matches[1].Trim()
    }
    if ($fm -match '(?m)^description:\s+["'']?(.+?)["'']?\s*$') {
        return $Matches[1].Trim()
    }
    throw "description ausente: $Path"
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
        $desc = Get-SkillDescription $skillFile
        if ([string]::IsNullOrWhiteSpace($desc)) {
            throw "description vacia: $skillFile"
        }
        if ($desc.Length -gt 1024) {
            throw "description > 1024 ($($desc.Length)): $skillFile"
        }
        $lineCount = @(Get-Content -LiteralPath $skillFile).Count
        if ($lineCount -gt 500) {
            Write-Warning "SKILL.md tiene $lineCount lineas (>500): $skillFile"
        }
        $skillDir = $_.FullName
        $body = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8
        [regex]::Matches($body, '\[[^\]]*\]\(([^)]+)\)') | ForEach-Object {
            $href = $_.Groups[1].Value.Trim()
            if ($href -match '^(https?:|mailto:|#|file:)') { return }
            $rel = ($href -split '#')[0]
            if ([string]::IsNullOrWhiteSpace($rel)) { return }
            $resolved = [System.IO.Path]::GetFullPath((Join-Path $skillDir $rel))
            if (-not (Test-Path -LiteralPath $resolved)) {
                throw "Enlace roto '$href' en $skillFile"
            }
        }
    }
}

function Assert-RuleMeta {
    param($Meta)
    $rulesSrc = Join-Path $Src 'rules'
    Get-ChildItem -LiteralPath $rulesSrc -File -Filter '*.md' | Where-Object { $_.Name -ne 'README.md' } | ForEach-Object {
        if (-not $Meta.ContainsKey($_.Name)) {
            throw "Falta metadatos de rule para $($_.Name). Anade una entrada en pack-kits.ps1"
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
        Description = 'Espanol obligatorio en interaccion, razonamiento y documentacion generada'
        AlwaysApply = $true
        Globs       = $null
    }
    'security-guard.md' = @{
        Description = 'No filtrar secretos ni PII; confirmar antes de tocar configs sensibles'
        AlwaysApply = $true
        Globs       = $null
    }
    'codebase-memory-first.md' = @{
        Description = 'Consultar el grafo codebase-memory antes de grep/glob o lectura exploratoria'
        AlwaysApply = $true
        Globs       = $null
    }
    'clean-code-patterns.md' = @{
        Description = 'DRY, responsabilidad unica, nombres claros y funciones pequenas'
        AlwaysApply = $true
        Globs       = $null
    }
    'testing-policy.md' = @{
        Description = 'Retrasa tests de negocio; no retrasa tests de autenticacion ni autorizacion'
        AlwaysApply = $false
        Globs       = $null
    }
    'documentation-standards.md' = @{
        Description = 'Documentar el porque y contratos no evidentes; no parafrasear codigo'
        AlwaysApply = $false
        Globs       = $null
    }
    'git-safety.md' = @{
        Description = 'No add/commit/push sin peticion; nunca force en main; no tocar git config global'
        AlwaysApply = $false
        Globs       = $null
    }
    'scope-discipline.md' = @{
        Description = 'Cambio minimo; sin refactor no pedido ni APIs inventadas'
        AlwaysApply = $false
        Globs       = $null
    }
    'stack-conventions.md' = @{
        Description = 'Respetar gestor de paquetes, linter y formatter del repo'
        AlwaysApply = $false
        Globs       = $null
    }
    'Guia_Diseno_UX_Frutiger_Aero.md' = @{
        Description = 'Sistema de diseno Frutiger Aero para UI frontend'
        AlwaysApply = $false
        Globs       = '**/*.{css,scss,html,tsx,jsx,vue,svelte}'
    }
    'sql-migration-safety.md' = @{
        Description = 'Migraciones SQL reversibles; sin DELETE/DROP sin WHERE ni confirmacion'
        AlwaysApply = $false
        Globs       = '**/*.sql,**/migrations/**'
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
Write-Host 'Validando rules...'
Assert-RuleMeta $RuleMeta

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
Get-ChildItem -LiteralPath $rulesSrc -File -Filter '*.md' | Where-Object { $_.Name -ne 'README.md' } | ForEach-Object {
    $meta = $RuleMeta[$_.Name]
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
    '- `/explain` — explicar un componente (grafo primero)'
    '- `/index` — indexar o refrescar codebase-memory'
    '- `/impacto` — radio de impacto de un cambio'
    '- `/review` — revisar el diff local (sin commit)'
    '- `/test` — ejecutar la suite del repo'
    '- `/debug` — depurar con hipotesis y evidencia'
    '- `/adr` — registrar una decision de arquitectura'
    '- `/ship-commit-message` — proponer commit (sin ejecutar salvo que pidas)'
    '- `/audit-vulnerabilidades` — revision defensiva'
    '- `/init-ia-project` — crear `.alvhere/` si no existe `AlvWasHere.md`'
) -join "`n"

$lazyRules = @(
    'documentation-standards.md'
    'testing-policy.md'
    'git-safety.md'
    'scope-discipline.md'
    'stack-conventions.md'
    'sql-migration-safety.md'
    'Guia_Diseno_UX_Frutiger_Aero.md'
)

$lazyBlock = ($lazyRules | ForEach-Object { "- ``@.opencode/rules/$_``" }) -join "`n"

Write-Utf8 (Join-Path $cuRoot 'AGENTS.md') @"
# Instrucciones del proyecto (Cursor)

- Habla y razona en **espanol**.
- Always-on: idioma, seguridad, codebase-memory-first, clean code (``.cursor/rules/*.mdc``).
- Las skills estan en `.cursor/skills/<nombre>/SKILL.md`. Cargalas cuando el trabajo coincida con su ``description``.
- Los workflows se invocan con `/` desde `.cursor/commands/`:

$commandsIndex

- Contexto de sesion (si existe): `.alvhere/task.md`, `handoff.md`, `PROJECT_CONTEXT.md`, `guideLines.md`.
"@

Write-Utf8 (Join-Path $cuRoot '.cursorrules') @"
# Idioma
Todas las interacciones, el razonamiento y la documentacion generada van en espanol.
Consulta el grafo de codebase-memory antes de explorar el repo a ciegas.
Las reglas detalladas viven en `.cursor/rules/`. Usa las skills de `.cursor/skills/` cuando apliquen.
"@

Write-Utf8 (Join-Path $ocRoot 'AGENTS.md') @"
# Instrucciones del proyecto (OpenCode)

- Habla y razona en **espanol**.
- ``opencode.json`` inyecta solo las rules always-on (idioma, seguridad, codebase-memory-first, clean code).
- Carga skills con la herramienta ``skill`` desde `.opencode/skills/`.
- Commands personalizados:

$commandsIndex

- No confundas ``/init-ia-project`` (sistema ALV) con el ``/init`` nativo de OpenCode.
- Contexto de sesion (si existe): `.alvhere/task.md`, `handoff.md`, `PROJECT_CONTEXT.md`, `guideLines.md`.

## Rules bajo demanda

CRITICAL: no cargues estos archivos por adelantado. Cuando la tarea lo requiera, usa Read:

$lazyBlock
"@

$ocInstructions = ($AlwaysOnRules | ForEach-Object { '    ".opencode/rules/' + $_ + '"' }) -join ",`n"
Write-Utf8 (Join-Path $ocRoot 'opencode.json') @"
{
  `"`$schema`": `"https://opencode.ai/config.json`",
  `"instructions`": [
$ocInstructions
  ],
  `"permission`": {
    `"skill`": {
      `"*`": `"allow`"
    }
  }
}
"@

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

Debe quedar `.agents/rules`, `.agents/skills`, `.agents/workflows`.
'@)

Write-Utf8 (Join-Path $cuRoot 'COMO_INSTALAR.md') (New-KitReadme 'Kit Cursor' @'
## Instalar

```powershell
.\scripts\install-kit.ps1 -Ide cursor -Destination D:\ruta\de\tu-proyecto
```

Debe quedar `.cursor/` (rules, skills, commands), `AGENTS.md` y `.cursorrules`.
'@)

Write-Utf8 (Join-Path $ocRoot 'COMO_INSTALAR.md') (New-KitReadme 'Kit OpenCode' @'
## Instalar

```powershell
.\scripts\install-kit.ps1 -Ide opencode -Destination D:\ruta\de\tu-proyecto
```

Debe quedar `.opencode/`, `AGENTS.md` y `opencode.json` (solo 4 rules always-on en instructions).
`/init-ia-project` no sustituye al `/init` nativo de OpenCode.
'@)

Write-Host 'Kits generados en kits/'
Get-ChildItem -LiteralPath $Kits -Directory | ForEach-Object { Write-Host " - $($_.Name)" }

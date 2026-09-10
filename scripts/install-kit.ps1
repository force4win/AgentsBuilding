<#
.SYNOPSIS
    Copia un kit (incluye carpetas ocultas .agents / .cursor / .opencode) a un proyecto.
.EXAMPLE
    .\scripts\install-kit.ps1 -Ide cursor -Destination D:\mis-proyectos\app
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('antigravity', 'cursor', 'opencode')]
    [string]$Ide,

    [Parameter(Mandatory = $true)]
    [string]$Destination
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$From = Join-Path $Root "kits\$Ide"

if (-not (Test-Path -LiteralPath $From)) {
    throw "No existe $From. Ejecuta primero .\scripts\pack-kits.ps1"
}

$dest = [System.IO.Path]::GetFullPath($Destination)
if (-not (Test-Path -LiteralPath $dest)) {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
}

Get-ChildItem -LiteralPath $From -Force | Where-Object { $_.Name -ne 'COMO_INSTALAR.md' } | ForEach-Object {
    $target = Join-Path $dest $_.Name
    Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse -Force
    Write-Host "Copiado $($_.Name)"
}

Write-Host "Kit '$Ide' instalado en $dest"
Write-Host 'Reinicia el IDE si no ves skills o comandos /.'

<#
.SYNOPSIS
    Runs one codebase-memory-mcp tool and prints its JSON result on stdout.

.DESCRIPTION
    Windows PowerShell splits native-command arguments on spaces even when the
    argument is a single quoted JSON document, so the child process only ever
    receives the first fragment. This wrapper builds the command line explicitly
    and starts the process without shell re-parsing, which is the only reliable
    way to pass JSON tool arguments on this platform.

    stdout carries the tool result; the binary's info-level log goes to stderr
    and is suppressed unless the tool fails or -ShowLog is passed.

.EXAMPLE
    ./cbm.ps1 list_projects

.EXAMPLE
    ./cbm.ps1 query_graph '{"project":"my-project","query":"MATCH (c:Class) RETURN c.name LIMIT 5"}'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Tool,

    [Parameter(Position = 1)]
    [string]$ToolArgs = '{}',

    [switch]$ShowLog
)

$ErrorActionPreference = 'Stop'

function Resolve-CbmExe {
    if ($env:CBM_EXE -and (Test-Path $env:CBM_EXE)) { return $env:CBM_EXE }

    $default = Join-Path $env:LOCALAPPDATA 'Programs/codebase-memory-mcp/codebase-memory-mcp.exe'
    if (Test-Path $default) { return $default }

    $onPath = Get-Command 'codebase-memory-mcp' -ErrorAction SilentlyContinue
    if ($onPath) { return $onPath.Source }

    throw 'codebase-memory-mcp binary not found. Set $env:CBM_EXE to its full path.'
}

$exe = Resolve-CbmExe

try {
    $null = $ToolArgs | ConvertFrom-Json
}
catch {
    throw "ToolArgs is not valid JSON: $ToolArgs"
}

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $exe
$psi.Arguments = 'cli ' + $Tool + ' "' + ($ToolArgs -replace '"', '\"') + '"'
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.UseShellExecute = $false

$proc = [System.Diagnostics.Process]::Start($psi)

# Read both streams concurrently; a blocking ReadToEnd on one deadlocks when the
# other fills its pipe buffer, which indexing logs do within seconds.
$stdoutTask = $proc.StandardOutput.ReadToEndAsync()
$stderrTask = $proc.StandardError.ReadToEndAsync()
$proc.WaitForExit()

$stdout = $stdoutTask.Result
$stderr = $stderrTask.Result

if ($stdout) { Write-Output $stdout.Trim() }

if ($proc.ExitCode -ne 0 -or $ShowLog) {
    if ($proc.ExitCode -ne 0) { Write-Output "EXIT_CODE=$($proc.ExitCode)" }
    if ($stderr) {
        Write-Output '--- stderr (last 20 lines) ---'
        Write-Output (($stderr.Trim() -split "`r?`n") | Select-Object -Last 20)
    }
}

exit $proc.ExitCode

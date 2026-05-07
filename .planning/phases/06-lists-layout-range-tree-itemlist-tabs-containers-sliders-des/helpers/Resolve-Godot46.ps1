<#
.SYNOPSIS
    Resolve a local Godot 4.6.x console executable for Phase 6 verification.

.DESCRIPTION
    Search-only resolver adapted from the Phase 5 helper pattern. It never
    downloads or installs Godot. On success it writes this Phase 6 helper
    directory's godot-cli-path.txt and godot-cli-provenance.txt. On failure it
    writes GODOT-CLI-MISSING.md with manual recovery steps and exits non-zero.
#>

[CmdletBinding()]
param(
    [switch] $VerifyOnly
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PathFile = Join-Path $ScriptDir 'godot-cli-path.txt'
$ProvenanceFile = Join-Path $ScriptDir 'godot-cli-provenance.txt'
$MissingFile = Join-Path $ScriptDir 'GODOT-CLI-MISSING.md'

function Write-Info([string] $Message) {
    Write-Host "[Resolve-Godot46] $Message"
}

function Resolve-ConsoleCompanion([string] $ExePath) {
    if (-not $ExePath) { return $ExePath }
    $dir = Split-Path -Parent $ExePath
    $base = [System.IO.Path]::GetFileNameWithoutExtension($ExePath)
    $ext = [System.IO.Path]::GetExtension($ExePath)
    if (-not $base.EndsWith('_console')) {
        $candidate = Join-Path $dir ($base + '_console' + $ext)
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return $candidate
        }
    }
    return $ExePath
}

function Invoke-Captured([string] $ExePath, [string[]] $Arguments, [int] $TimeoutSeconds = 60) {
    $tmpOut = [System.IO.Path]::GetTempFileName()
    $tmpErr = [System.IO.Path]::GetTempFileName()
    try {
        $proc = Start-Process -FilePath $ExePath -ArgumentList $Arguments `
            -RedirectStandardOutput $tmpOut -RedirectStandardError $tmpErr `
            -WindowStyle Hidden -PassThru
        if (-not $proc.WaitForExit($TimeoutSeconds * 1000)) {
            try { $proc.Kill() } catch { }
            return @{ ExitCode = -1; Stdout = ''; Stderr = "Timed out after $TimeoutSeconds seconds" }
        }
        $stdout = if (Test-Path -LiteralPath $tmpOut) { Get-Content -LiteralPath $tmpOut -Raw } else { '' }
        $stderr = if (Test-Path -LiteralPath $tmpErr) { Get-Content -LiteralPath $tmpErr -Raw } else { '' }
        return @{ ExitCode = $proc.ExitCode; Stdout = "$stdout"; Stderr = "$stderr" }
    } finally {
        if (Test-Path -LiteralPath $tmpOut) { Remove-Item -LiteralPath $tmpOut -Force -ErrorAction SilentlyContinue }
        if (Test-Path -LiteralPath $tmpErr) { Remove-Item -LiteralPath $tmpErr -Force -ErrorAction SilentlyContinue }
    }
}

function Test-Godot46([string] $Candidate) {
    if (-not (Test-Path -LiteralPath $Candidate -PathType Leaf)) { return $null }
    $exe = Resolve-ConsoleCompanion $Candidate
    try {
        $result = Invoke-Captured -ExePath $exe -Arguments @('--version') -TimeoutSeconds 30
    } catch {
        return $null
    }
    $combined = "$($result.Stdout)`n$($result.Stderr)"
    if ($combined -match '\b4\.6(\.\d+)?[A-Za-z0-9.\-]*') {
        return [pscustomobject]@{
            Path = $exe
            Version = $combined.Trim()
        }
    }
    return $null
}

function Get-CandidatePaths {
    $items = New-Object System.Collections.Generic.List[string]

    foreach ($var in @('GODOT4', 'GODOT')) {
        $value = [Environment]::GetEnvironmentVariable($var)
        if ($value) { $items.Add($value) | Out-Null }
    }

    foreach ($cmd in @('godot', 'godot4')) {
        $found = Get-Command $cmd -ErrorAction SilentlyContinue
        if ($found) { $items.Add($found.Source) | Out-Null }
    }

    $patterns = @(
        (Join-Path $env:USERPROFILE 'Godot\Godot_v4.6*.exe'),
        (Join-Path $env:USERPROFILE 'Documents\Godot\Godot_v4.6*.exe'),
        (Join-Path $env:USERPROFILE 'Downloads\Godot_v4.6*.exe'),
        (Join-Path $env:LOCALAPPDATA 'Programs\Godot\Godot_v4.6*.exe'),
        'C:\Programming_Files\Godot\Godot_v4.6*.exe',
        'C:\Programming_Files\Godot\Godot_v4.6*\Godot_v4.6*.exe',
        'C:\Program Files\Godot\Godot_v4.6*.exe',
        'C:\Program Files (x86)\Steam\steamapps\common\Godot Engine\*.exe'
    )

    foreach ($pattern in $patterns) {
        if (-not $pattern) { continue }
        foreach ($hit in Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue) {
            $items.Add($hit.FullName) | Out-Null
        }
    }

    $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    $unique = New-Object System.Collections.Generic.List[string]
    foreach ($item in $items) {
        if ($seen.Add($item)) { $unique.Add($item) | Out-Null }
    }
    return $unique.ToArray()
}

function Write-Resolved([string] $Path, [string] $Version) {
    Set-Content -LiteralPath $PathFile -Value $Path -Encoding ascii
    $body = @(
        '# Godot CLI Provenance',
        '',
        "Resolved at:   $((Get-Date).ToUniversalTime().ToString('o'))",
        'Resolved by:   Resolve-Godot46.ps1 (search-only)',
        "Version line:  $Version",
        "Executable:    $Path"
    ) -join "`n"
    Set-Content -LiteralPath $ProvenanceFile -Value ($body + "`n") -Encoding ascii
    if (Test-Path -LiteralPath $MissingFile) {
        Remove-Item -LiteralPath $MissingFile -Force
    }
}

function Write-Missing {
    $body = @"
# Godot CLI Missing -- Phase 6

Resolve-Godot46.ps1 did not find a Godot 4.6.x executable on this machine.

Provide an existing Godot 4.6.x path through `$env:GODOT4` or add `godot` to
PATH, then re-run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .planning/phases/06-lists-layout-range-tree-itemlist-tabs-containers-sliders-des/helpers/Resolve-Godot46.ps1 -VerifyOnly
```

The resolver is search-only and never downloads or installs Godot.
"@
    Set-Content -LiteralPath $MissingFile -Value $body -Encoding ascii
    if (Test-Path -LiteralPath $PathFile) { Remove-Item -LiteralPath $PathFile -Force }
    if (Test-Path -LiteralPath $ProvenanceFile) { Remove-Item -LiteralPath $ProvenanceFile -Force }
}

Write-Info "Searching for Godot 4.6.x (search-only)."
foreach ($candidate in Get-CandidatePaths) {
    Write-Info "  trying: $candidate"
    $resolved = Test-Godot46 $candidate
    if ($null -ne $resolved) {
        Write-Info "  MATCH: $($resolved.Path)"
        Write-Resolved -Path $resolved.Path -Version $resolved.Version
        exit 0
    }
}

Write-Info "No Godot 4.6.x executable found."
Write-Missing
exit 2

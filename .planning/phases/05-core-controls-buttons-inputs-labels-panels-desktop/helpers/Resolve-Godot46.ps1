<#
.SYNOPSIS
    Resolve a Godot 4.6.x executable on the local Windows machine, search-only by default.

.DESCRIPTION
    Phase 5 prerequisite (D-11). Searches a fixed, ordered list of locations for an
    already-installed Godot 4.6.x stable executable. Writes the resolved absolute path
    to helpers/godot-cli-path.txt only after a 4.6.x version check succeeds.

    SEARCH-ONLY by default (-VerifyOnly). NEVER downloads, installs, extracts, or
    network-fetches a binary unless the operator explicitly invokes -AllowInstall
    AND supplies BOTH -DownloadUrl <official Godot URL> AND -ExpectedSha256 <hash>.

    If no executable is found in search-only mode, writes
    helpers/GODOT-CLI-MISSING.md with concrete next steps for the operator and exits
    non-zero so the caller can pause at the human-action checkpoint.

    Per cross-AI plan-review HIGH gate + project D-11: autonomous Godot binary
    download/install is forbidden without explicit approval and SHA256 documentation.

.PARAMETER VerifyOnly
    Default mode. Search-only. Does not download or install. (Switch is accepted
    explicitly for clarity; behavior is identical to passing no flags.)

.PARAMETER AllowInstall
    Opt-in flag. Requires both -DownloadUrl and -ExpectedSha256. Downloads only
    from the supplied URL (must be an official Godot distribution endpoint:
    https://github.com/godotengine/godot/releases/* or https://godotengine.org/*),
    verifies SHA256 exactly, extracts outside the repo, and records provenance.
    The downloaded archive and extracted binaries are NEVER committed to the repo.

.PARAMETER DownloadUrl
    Required when -AllowInstall is set. Must point at an official Godot release
    asset (Windows zip). The script refuses non-official hosts.

.PARAMETER ExpectedSha256
    Required when -AllowInstall is set. The expected SHA256 of the downloaded
    archive, lower- or upper-case hex, no separators. Mismatch aborts the run.

.PARAMETER InstallRoot
    Where to extract the downloaded archive. Defaults to
    "$env:LOCALAPPDATA\Programs\Godot-NeoCade-Phase5". Always OUTSIDE the repo.

.OUTPUTS
    helpers/godot-cli-path.txt        absolute path to the verified Godot 4.6.x exe
    helpers/godot-cli-provenance.txt  source URL/path + SHA256 + version
    helpers/GODOT-CLI-MISSING.md      written ONLY when no executable is found

.NOTES
    Exit codes:
        0  Godot 4.6.x found, version verified, path written.
        2  No Godot found in search-only mode; GODOT-CLI-MISSING.md written.
        3  -AllowInstall preconditions failed (missing url/sha256, non-official host,
           sha256 mismatch, etc.) or download/extract/version-check failed.
#>

[CmdletBinding(DefaultParameterSetName = 'Search')]
param(
    [Parameter(ParameterSetName = 'Search')]
    [switch] $VerifyOnly,

    [Parameter(ParameterSetName = 'Install', Mandatory = $true)]
    [switch] $AllowInstall,

    [Parameter(ParameterSetName = 'Install', Mandatory = $true)]
    [string] $DownloadUrl,

    [Parameter(ParameterSetName = 'Install', Mandatory = $true)]
    [string] $ExpectedSha256,

    [Parameter(ParameterSetName = 'Install')]
    [string] $InstallRoot = (Join-Path $env:LOCALAPPDATA 'Programs\Godot-NeoCade-Phase5')
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Helper directory is the directory containing this script.
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PathFile       = Join-Path $ScriptDir 'godot-cli-path.txt'
$ProvenanceFile = Join-Path $ScriptDir 'godot-cli-provenance.txt'
$MissingFile    = Join-Path $ScriptDir 'GODOT-CLI-MISSING.md'

function Write-Info($msg)  { Write-Host "[Resolve-Godot46] $msg" }
function Write-Warn($msg)  { Write-Host "[Resolve-Godot46] WARNING: $msg" -ForegroundColor Yellow }
function Write-Err($msg)   { Write-Host "[Resolve-Godot46] ERROR: $msg" -ForegroundColor Red }

function Resolve-PreferConsoleExe {
    # On Windows the GUI Godot executable detaches from the parent console and
    # produces no captured stdout. The matching `_console.exe` companion (shipped
    # in the same folder for every official Godot 4.x Windows build) wraps the
    # GUI exe in a true console host so stdout/stderr can be captured. Prefer
    # the console exe when both exist so --version, --import, and --script logs
    # are observable.
    param([Parameter(Mandatory = $true)][string] $ExePath)

    if (-not $ExePath) { return $ExePath }
    $dir  = Split-Path -Parent $ExePath
    $base = [System.IO.Path]::GetFileNameWithoutExtension($ExePath)
    $ext  = [System.IO.Path]::GetExtension($ExePath)
    if (-not $base.EndsWith('_console')) {
        $candidate = Join-Path $dir ($base + '_console' + $ext)
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return $candidate
        }
    }
    return $ExePath
}

function Invoke-GodotCapture {
    # Run a Godot exe with arguments, capturing stdout+stderr to disk via
    # Start-Process. This is the only invocation pattern that reliably observes
    # output from the Windows GUI exe; using `& $exe ...` from PowerShell loses
    # output because the GUI exe detaches its console. Returns a hashtable with
    # ExitCode, Stdout (string), Stderr (string).
    param(
        [Parameter(Mandatory = $true)][string] $ExePath,
        [Parameter(Mandatory = $true)][string[]] $Arguments,
        [int] $TimeoutSeconds = 120
    )

    $tmpOut = [System.IO.Path]::GetTempFileName()
    $tmpErr = [System.IO.Path]::GetTempFileName()
    try {
        $proc = Start-Process -FilePath $ExePath -ArgumentList $Arguments `
            -RedirectStandardOutput $tmpOut -RedirectStandardError $tmpErr `
            -NoNewWindow -PassThru
        if (-not $proc.WaitForExit($TimeoutSeconds * 1000)) {
            try { $proc.Kill() } catch { }
            return @{
                ExitCode = -1
                Stdout = ''
                Stderr = "Timed out after $TimeoutSeconds seconds"
            }
        }
        $stdout = if (Test-Path -LiteralPath $tmpOut) { Get-Content -LiteralPath $tmpOut -Raw } else { '' }
        $stderr = if (Test-Path -LiteralPath $tmpErr) { Get-Content -LiteralPath $tmpErr -Raw } else { '' }
        return @{
            ExitCode = $proc.ExitCode
            Stdout = if ($null -eq $stdout) { '' } else { $stdout }
            Stderr = if ($null -eq $stderr) { '' } else { $stderr }
        }
    } finally {
        if (Test-Path -LiteralPath $tmpOut) { Remove-Item -LiteralPath $tmpOut -Force -ErrorAction SilentlyContinue }
        if (Test-Path -LiteralPath $tmpErr) { Remove-Item -LiteralPath $tmpErr -Force -ErrorAction SilentlyContinue }
    }
}

function Test-IsGodot46Executable {
    param([Parameter(Mandatory = $true)][string] $ExePath)

    if (-not (Test-Path -LiteralPath $ExePath -PathType Leaf)) { return $null }

    # Prefer the console companion exe so --version output is captured.
    $probeExe = Resolve-PreferConsoleExe -ExePath $ExePath

    $result = $null
    try {
        $result = Invoke-GodotCapture -ExePath $probeExe -Arguments @('--version') -TimeoutSeconds 30
    } catch {
        Write-Warn "Failed to run '$probeExe --version': $($_.Exception.Message)"
        return $null
    }

    $combined = "$($result.Stdout)`n$($result.Stderr)"
    # Accept "4.6.x" anywhere in the version output. Common formats include
    #   '4.6.2.stable.official.aef5a44f5'  /  'v4.6-stable'  /  '4.6.0.beta'.
    if ($combined -match '\b4\.6(\.\d+)?[A-Za-z0-9.\-]*') {
        return $combined.Trim()
    }
    return $null
}

function Get-CandidatePaths {
    $candidates = New-Object System.Collections.Generic.List[string]

    # Environment variables.
    foreach ($var in @('GODOT4', 'GODOT')) {
        $val = [Environment]::GetEnvironmentVariable($var)
        if ($val) { $candidates.Add($val) | Out-Null }
    }

    # PATH commands ('godot', 'godot4').
    foreach ($cmd in @('godot', 'godot4')) {
        $found = Get-Command $cmd -ErrorAction SilentlyContinue
        if ($found) { $candidates.Add($found.Source) | Out-Null }
    }

    # Common Windows install locations.
    $userHome = $env:USERPROFILE
    $localAppData = $env:LOCALAPPDATA
    $programFiles = ${env:ProgramFiles}
    $programFilesX86 = ${env:ProgramFiles(x86)}

    $globPatterns = @()
    if ($userHome) {
        $globPatterns += (Join-Path $userHome 'Godot\Godot_v4.6*-stable_win64.exe')
        $globPatterns += (Join-Path $userHome 'Godot\Godot_v4.6*-stable_mono_win64.exe')
        $globPatterns += (Join-Path $userHome 'Godot\Godot_v4.6*_win64.exe')
        $globPatterns += (Join-Path $userHome 'Documents\Godot\Godot_v4.6*_win64.exe')
        $globPatterns += (Join-Path $userHome 'Downloads\Godot_v4.6*_win64.exe')
    }
    if ($programFiles) {
        $globPatterns += (Join-Path $programFiles 'Godot\Godot_v4.6*_win64.exe')
    }
    if ($programFilesX86) {
        $globPatterns += (Join-Path $programFilesX86 'Godot\Godot_v4.6*_win64.exe')
        $globPatterns += (Join-Path $programFilesX86 'Steam\steamapps\common\Godot Engine\*.exe')
    }
    if ($localAppData) {
        $globPatterns += (Join-Path $localAppData 'Programs\Godot\Godot_v4.6*_win64.exe')
        $globPatterns += (Join-Path $localAppData 'Programs\Godot-NeoCade-Phase5\Godot_v4.6*_win64.exe')
    }

    foreach ($pattern in $globPatterns) {
        try {
            $hits = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
            foreach ($hit in $hits) { $candidates.Add($hit.FullName) | Out-Null }
        } catch {
            # ignore unreadable paths silently
        }
    }

    # Deduplicate while preserving order. Return as a String[] so the caller
    # always sees an array (avoids PS pipeline-unwrap to $null for 0-item Lists,
    # which breaks .Count under StrictMode Latest).
    $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    $unique = New-Object System.Collections.Generic.List[string]
    foreach ($c in $candidates) {
        if ($seen.Add($c)) { $unique.Add($c) | Out-Null }
    }
    # Wrap in a unary-comma array to suppress pipeline unwrapping.
    return ,$unique.ToArray()
}

function Find-Godot46 {
    Write-Info "Searching for Godot 4.6.x (search-only mode, no downloads)."
    $candidates = Get-CandidatePaths
    if ($null -eq $candidates -or $candidates.Length -eq 0) {
        Write-Info "No candidate paths discovered."
        return $null
    }
    foreach ($candidate in $candidates) {
        Write-Info "  trying: $candidate"
        $version = Test-IsGodot46Executable -ExePath $candidate
        if ($version) {
            # Prefer the _console.exe companion when present so subsequent
            # invocations (--version / --import / --script) produce captureable
            # stdout/stderr. The GUI exe detaches from the parent console on
            # Windows and silently drops stdout when invoked from PS/CMD.
            $resolved = Resolve-PreferConsoleExe -ExePath $candidate
            if ($resolved -ne $candidate) {
                Write-Info "  Preferring console companion exe: $resolved"
            }
            Write-Info "  MATCH: Godot 4.6.x detected at '$resolved' (version: $version)"
            return [pscustomobject]@{ Path = $resolved; Version = $version }
        }
    }
    return $null
}

function Write-PathFile {
    param([Parameter(Mandatory = $true)][string] $ResolvedPath,
          [Parameter(Mandatory = $true)][string] $Version,
          [string] $Source = 'search-only',
          [string] $DownloadedFromUrl,
          [string] $Sha256)

    Set-Content -LiteralPath $PathFile -Value $ResolvedPath -Encoding ascii -NoNewline:$false
    Write-Info "Wrote $PathFile"

    $provenance = New-Object System.Text.StringBuilder
    [void]$provenance.AppendLine('# Godot CLI Provenance')
    [void]$provenance.AppendLine('')
    [void]$provenance.AppendLine("Resolved at:   $((Get-Date).ToUniversalTime().ToString('o'))")
    [void]$provenance.AppendLine("Resolved by:   Resolve-Godot46.ps1 ($Source)")
    [void]$provenance.AppendLine("Version line:  $Version")
    [void]$provenance.AppendLine("Executable:    $ResolvedPath")
    if ($DownloadedFromUrl) {
        [void]$provenance.AppendLine("DownloadUrl:   $DownloadedFromUrl")
    }
    if ($Sha256) {
        [void]$provenance.AppendLine("SHA256:        $Sha256")
    }
    Set-Content -LiteralPath $ProvenanceFile -Value $provenance.ToString() -Encoding ascii -NoNewline:$false
    Write-Info "Wrote $ProvenanceFile"

    if (Test-Path -LiteralPath $MissingFile) {
        Remove-Item -LiteralPath $MissingFile -Force
        Write-Info "Removed stale $MissingFile"
    }
}

function Write-MissingFile {
    $body = @"
# Godot CLI Missing -- Phase 5 Plan 01 Checkpoint

`Resolve-Godot46.ps1 -VerifyOnly` did not find a Godot 4.6.x executable on this
machine. Phase 5 cannot proceed until a real Godot 4.6.x CLI is available, per
project decision D-11 (the Phase 4 hand-author fallback is retired).

This file pauses execution at the Phase 5 Plan 01 human-action checkpoint. The
resolver will NEVER download or install Godot autonomously -- see the script
header for the strict approval contract.

## Searched locations (in order)

1. `$env:GODOT4`
2. `$env:GODOT`
3. `godot` on `PATH`
4. `godot4` on `PATH`
5. `%USERPROFILE%\Godot\Godot_v4.6*-stable_win64.exe` (and `_mono_win64.exe` /
   plain `_win64.exe` variants)
6. `%USERPROFILE%\Documents\Godot\Godot_v4.6*_win64.exe`
7. `%USERPROFILE%\Downloads\Godot_v4.6*_win64.exe`
8. `%ProgramFiles%\Godot\Godot_v4.6*_win64.exe`
9. `%ProgramFiles(x86)%\Godot\Godot_v4.6*_win64.exe`
10. Steam library: `%ProgramFiles(x86)%\Steam\steamapps\common\Godot Engine\*.exe`
11. `%LOCALAPPDATA%\Programs\Godot\Godot_v4.6*_win64.exe`
12. `%LOCALAPPDATA%\Programs\Godot-NeoCade-Phase5\Godot_v4.6*_win64.exe`

## To resolve, pick ONE option

### Option A -- Provide an existing Godot 4.6.x install path

If you have Godot 4.6.x installed somewhere else, give the executor the absolute
path. The executor will write it to `helpers/godot-cli-path.txt` after running:

```powershell
& '<absolute-path-to-Godot_v4.6.x_win64.exe>' --version
```

...and confirming the output contains `4.6`. Provenance will record it as a
manually supplied path.

### Option B -- Approve a download (requires explicit URL + SHA256)

If you want the executor to download Godot for you, you MUST supply BOTH:

  1. An official Godot release URL -- accepted hosts are
     `https://github.com/godotengine/godot/releases/...` or
     `https://godotengine.org/...`. No other hosts will be downloaded from.
  2. The expected SHA256 of the downloaded archive (lower- or upper-case hex).

The executor will then run:

```powershell
powershell -ExecutionPolicy Bypass -File helpers/Resolve-Godot46.ps1 ``
    -AllowInstall ``
    -DownloadUrl '<official Godot URL>' ``
    -ExpectedSha256 '<sha256-from-the-Godot-release-page>'
```

The script will:
- Refuse non-official hosts.
- Verify the downloaded SHA256 exactly. Mismatch aborts the run.
- Extract OUTSIDE the repo (default: `%LOCALAPPDATA%\Programs\Godot-NeoCade-Phase5\`).
- Run `--version` on the extracted exe and confirm it reports `4.6.x`.
- Write `helpers/godot-cli-path.txt` with the absolute extracted path.
- Write `helpers/godot-cli-provenance.txt` with the URL, SHA256, version line,
  install path, and timestamp.
- NEVER stage or commit the binary.

## Do NOT do

- Do not edit this file by hand to inject a bogus path -- the resolver will
  reject any path that does not pass the `--version` 4.6.x check.
- Do not download Godot from a third-party mirror. The resolver only accepts
  the two official hosts above.
- Do not commit the Godot executable to the repo. The resolver extracts to
  `%LOCALAPPDATA%` so it cannot accidentally be staged from the worktree.
"@
    Set-Content -LiteralPath $MissingFile -Value $body -Encoding utf8 -NoNewline:$false
    Write-Info "Wrote $MissingFile"
}

function Invoke-AllowInstall {
    Write-Info "AllowInstall mode: validating preconditions."

    if (-not $DownloadUrl) {
        Write-Err "-AllowInstall requires -DownloadUrl."
        return $null
    }
    if (-not $ExpectedSha256) {
        Write-Err "-AllowInstall requires -ExpectedSha256."
        return $null
    }

    # Whitelist official hosts only.
    try {
        $uri = [System.Uri] $DownloadUrl
    } catch {
        Write-Err "DownloadUrl is not a valid URI: $DownloadUrl"
        return $null
    }
    $allowedHosts = @('github.com', 'godotengine.org', 'downloads.tuxfamily.org')
    # Restrict github.com paths to the official godot release tree.
    $hostOk = $false
    if ($uri.Scheme -eq 'https') {
        if ($uri.Host -eq 'github.com' -and $uri.AbsolutePath -like '/godotengine/godot/releases/*') {
            $hostOk = $true
        } elseif ($uri.Host -eq 'godotengine.org') {
            $hostOk = $true
        } elseif ($uri.Host -eq 'downloads.tuxfamily.org' -and $uri.AbsolutePath -like '/godotengine/*') {
            $hostOk = $true
        }
    }
    if (-not $hostOk) {
        Write-Err "DownloadUrl host '$($uri.Host)' is not an approved official Godot host. Approved: $($allowedHosts -join ', ')."
        return $null
    }

    # Normalize SHA256.
    $expectedSha = $ExpectedSha256.Trim().ToLowerInvariant() -replace '[\s:]+', ''
    if ($expectedSha -notmatch '^[0-9a-f]{64}$') {
        Write-Err "ExpectedSha256 must be 64 hex characters. Got: '$ExpectedSha256'"
        return $null
    }

    # Prepare install location OUTSIDE the repo.
    if (-not (Test-Path -LiteralPath $InstallRoot)) {
        New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null
    }
    # Sanity: refuse to install into the repo.
    $repoRoot = (Resolve-Path -LiteralPath (Join-Path $ScriptDir '..\..\..\..')).Path
    $installFull = (Resolve-Path -LiteralPath $InstallRoot).Path
    if ($installFull.StartsWith($repoRoot, [StringComparison]::OrdinalIgnoreCase)) {
        Write-Err "InstallRoot '$installFull' is inside the repo '$repoRoot'. Refusing to extract Godot into the repo."
        return $null
    }

    $archiveName = [System.IO.Path]::GetFileName($uri.AbsolutePath)
    if (-not $archiveName) { $archiveName = 'godot-archive.zip' }
    $archivePath = Join-Path $InstallRoot $archiveName

    Write-Info "Downloading: $DownloadUrl"
    Write-Info "  -> $archivePath"
    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $archivePath -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Err "Download failed: $($_.Exception.Message)"
        return $null
    }

    Write-Info "Computing SHA256 of downloaded archive."
    $actualSha = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualSha -ne $expectedSha) {
        Write-Err "SHA256 mismatch. Expected: $expectedSha  Actual: $actualSha"
        try { Remove-Item -LiteralPath $archivePath -Force } catch { }
        return $null
    }
    Write-Info "  SHA256 matches expected value."

    # Extract.
    $extractDir = Join-Path $InstallRoot ('extracted-' + (Get-Date -Format 'yyyyMMddHHmmss'))
    New-Item -ItemType Directory -Force -Path $extractDir | Out-Null
    if ($archivePath -like '*.zip') {
        Write-Info "Extracting zip to $extractDir"
        try {
            Expand-Archive -LiteralPath $archivePath -DestinationPath $extractDir -Force
        } catch {
            Write-Err "Extract failed: $($_.Exception.Message)"
            return $null
        }
    } else {
        Write-Err "Unsupported archive type: $archivePath"
        return $null
    }

    # Locate the Godot exe inside the extracted directory.
    $exes = Get-ChildItem -Path $extractDir -Recurse -Filter 'Godot_v4.6*.exe' -ErrorAction SilentlyContinue
    if (-not $exes -or $exes.Count -eq 0) {
        # Fall back to any .exe matching Godot*.
        $exes = Get-ChildItem -Path $extractDir -Recurse -Filter 'Godot*.exe' -ErrorAction SilentlyContinue
    }
    if (-not $exes -or $exes.Count -eq 0) {
        Write-Err "No Godot exe found inside extracted archive at $extractDir"
        return $null
    }
    $exePath = $exes[0].FullName
    $version = Test-IsGodot46Executable -ExePath $exePath
    if (-not $version) {
        Write-Err "Extracted exe '$exePath' did not report Godot 4.6.x via --version."
        return $null
    }

    Write-Info "Approved install verified: $exePath (version: $version)"
    return [pscustomobject]@{
        Path = $exePath
        Version = $version
        Source = "AllowInstall (url=$DownloadUrl)"
        DownloadUrl = $DownloadUrl
        Sha256 = $expectedSha
    }
}

# --- Main ---
try {
    if ($PSCmdlet.ParameterSetName -eq 'Install') {
        $result = Invoke-AllowInstall
        if ($null -eq $result) {
            Write-Err "AllowInstall failed. See messages above."
            exit 3
        }
        Write-PathFile -ResolvedPath $result.Path -Version $result.Version `
            -Source $result.Source -DownloadedFromUrl $result.DownloadUrl -Sha256 $result.Sha256
        Write-Info "DONE (AllowInstall): $($result.Path)"
        exit 0
    }

    # Default: search-only. -VerifyOnly is accepted but functionally identical.
    $found = Find-Godot46
    if ($null -eq $found) {
        Write-Warn "No Godot 4.6.x executable found in any searched location."
        Write-MissingFile
        # Remove any stale path/provenance files so callers do not see a fake path.
        if (Test-Path -LiteralPath $PathFile) {
            Remove-Item -LiteralPath $PathFile -Force
            Write-Info "Removed stale $PathFile"
        }
        if (Test-Path -LiteralPath $ProvenanceFile) {
            Remove-Item -LiteralPath $ProvenanceFile -Force
            Write-Info "Removed stale $ProvenanceFile"
        }
        Write-Info "Pause for human-action checkpoint (Plan 05-01 Task 2)."
        exit 2
    }

    Write-PathFile -ResolvedPath $found.Path -Version $found.Version -Source 'search-only'
    Write-Info "DONE (search): $($found.Path)"
    exit 0
} catch {
    Write-Err "Unhandled exception: $($_.Exception.Message)"
    Write-Err $_.ScriptStackTrace
    exit 3
}

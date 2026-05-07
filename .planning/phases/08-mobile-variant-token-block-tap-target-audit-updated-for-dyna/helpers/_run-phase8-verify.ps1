[CmdletBinding()]
param(
    [ValidateSet('architecture', 'platform-tokens', 'tap-targets', 'docs', 'scene-toggle', 'full')]
    [string] $Stage = 'architecture'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Resolver = Join-Path $ScriptDir 'Resolve-Godot46.ps1'
$PathFile = Join-Path $ScriptDir 'godot-cli-path.txt'
$Verifier = Join-Path $ScriptDir '_phase8_verify_headless.gd'

if (-not (Test-Path -LiteralPath $Resolver -PathType Leaf)) {
    throw "Phase 8 Godot resolver missing: $Resolver"
}
if (-not (Test-Path -LiteralPath $Verifier -PathType Leaf)) {
    throw "Phase 8 verifier missing: $Verifier"
}

if (-not (Test-Path -LiteralPath $PathFile -PathType Leaf)) {
    powershell -NoProfile -ExecutionPolicy Bypass -File $Resolver -VerifyOnly
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$Godot = (Get-Content -LiteralPath $PathFile -Raw).Trim()
if (-not (Test-Path -LiteralPath $Godot -PathType Leaf)) {
    powershell -NoProfile -ExecutionPolicy Bypass -File $Resolver -VerifyOnly
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    $Godot = (Get-Content -LiteralPath $PathFile -Raw).Trim()
}

Write-Host "[Phase8Verify] Godot: $Godot"
Write-Host "[Phase8Verify] Stage: $Stage"

& $Godot --headless --path . --script $Verifier -- --stage $Stage
exit $LASTEXITCODE

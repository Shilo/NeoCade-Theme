[CmdletBinding()]
param(
    [ValidateSet('slot-freeze', 'popups-menus', 'filedialog', 'colorpicker', 'graph', 'full')]
    [string] $Stage = 'slot-freeze'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Resolver = Join-Path $ScriptDir 'Resolve-Godot46.ps1'
$PathFile = Join-Path $ScriptDir 'godot-cli-path.txt'
$Verifier = Join-Path $ScriptDir '_phase7_verify_headless.gd'

if (-not (Test-Path -LiteralPath $Resolver -PathType Leaf)) {
    throw "Phase 7 Godot resolver missing: $Resolver"
}
if (-not (Test-Path -LiteralPath $Verifier -PathType Leaf)) {
    throw "Phase 7 verifier missing: $Verifier"
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

Write-Host "[Phase7Verify] Godot: $Godot"
Write-Host "[Phase7Verify] Stage: $Stage"

& $Godot --headless --path . --script $Verifier -- --stage $Stage
exit $LASTEXITCODE

# Run Flutter web without Google CDN (CanvasKit + fonts load locally).
# Required when gstatic.com is blocked or unreachable.
#
# Usage:
#   cd frontend
#   .\run_web.ps1
#   .\run_web.ps1 -Device chrome

param(
    [string]$Device = "edge"
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "Starting Flutter web on $Device (local CanvasKit, no gstatic CDN)..."
flutter run -d $Device --no-web-resources-cdn

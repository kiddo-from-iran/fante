# Run the FastAPI server from the repository root.
# PYTHONPATH must point at the repo root so `backend.app.*` imports resolve.
#
# Usage (with venv activated):
#   .\run_backend.ps1

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$env:PYTHONPATH = $PSScriptRoot

$port = 8000
$listeners = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
if ($listeners) {
    foreach ($conn in $listeners) {
        $proc = Get-CimInstance Win32_Process -Filter "ProcessId=$($conn.OwningProcess)" -ErrorAction SilentlyContinue
        Write-Warning "Port $port already in use by PID $($conn.OwningProcess) on $($conn.LocalAddress)"
        if ($proc.CommandLine) {
            Write-Warning "  $($proc.CommandLine)"
        }
    }
    Write-Warning "Stop the old server first (Ctrl+C in its terminal, or: Stop-Process -Id <PID> -Force)"
    Write-Warning "Two servers on the same port cause Flutter to hit stale code (e.g. bcrypt 72-byte error)."
    exit 1
}

Write-Host "Starting FanteQuiz API at http://127.0.0.1:$port"
Write-Host "PYTHONPATH=$env:PYTHONPATH"
Write-Host "Verify auth routes: http://127.0.0.1:$port/docs (login/password, otp/validate)"

uvicorn backend.app.main:app --reload --host 127.0.0.1 --port $port

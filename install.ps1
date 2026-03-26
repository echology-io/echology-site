# Signal Provenance installer -- Windows
# Usage: Save and run, or paste into PowerShell
#   powershell -ExecutionPolicy Bypass -File install-provenance.ps1

$ErrorActionPreference = "Stop"
$VENV = "$env:USERPROFILE\.signal-provenance"
$WHEEL_URL = "https://echology.io/downloads/signal_provenance-1.0.0-py3-none-any.whl"

try {

Write-Host ""
Write-Host "Signal Provenance -- installing..." -ForegroundColor Cyan
Write-Host ""

# Find Python
$py = $null
foreach ($cmd in @("python3", "python", "py")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($ver -match "Python (\d+)\.(\d+)") {
            $major = [int]$Matches[1]
            $minor = [int]$Matches[2]
            if ($major -ge 3 -and $minor -ge 9) {
                $py = $cmd
                Write-Host "Found $ver"
                break
            }
        }
    } catch {}
}

if (-not $py) {
    Write-Host ""
    Write-Host "Python 3.9+ is required." -ForegroundColor Red
    Write-Host "Download it from https://python.org/downloads/" -ForegroundColor Yellow
    Write-Host "Make sure to check 'Add Python to PATH' during install."
    Write-Host ""
    Read-Host "Press Enter to close"
    exit 1
}

# Create isolated venv
if (-not (Test-Path $VENV)) {
    Write-Host "Creating environment..."
    & $py -m venv $VENV
}

# Install
Write-Host "Installing Signal Provenance..."
& "$VENV\Scripts\pip.exe" install --upgrade --quiet $WHEEL_URL
& "$VENV\Scripts\pip.exe" install --upgrade --quiet weasyprint

Write-Host ""
Write-Host "Installed." -ForegroundColor Green
Write-Host ""
Write-Host "Starting Signal Provenance -- your browser will open automatically." -ForegroundColor Cyan
Write-Host "Keep this window open while Provenance is running."
Write-Host "To run again later:  ~\.signal-provenance\Scripts\python.exe -m signal_provenance"
Write-Host ""

# Launch
& "$VENV\Scripts\python.exe" -m signal_provenance

} catch {
    Write-Host ""
    Write-Host "Something went wrong: $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to close"
    exit 1
}

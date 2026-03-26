# Signal Provenance installer -- Windows
# Usage: irm https://echology.io/install.ps1 | iex

Write-Host "Signal Provenance -- installing..." -ForegroundColor Cyan

# Check Python
$py = $null
foreach ($cmd in @("python3", "python", "py")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($ver -match "Python (\d+)\.(\d+)") {
            $major = [int]$Matches[1]
            $minor = [int]$Matches[2]
            if ($major -ge 3 -and $minor -ge 11) {
                $py = $cmd
                Write-Host "Found $ver"
                break
            }
        }
    } catch {}
}

if (-not $py) {
    Write-Host "Error: Python 3.11+ is required." -ForegroundColor Red
    Write-Host "Install from https://python.org/downloads/ and try again."
    exit 1
}

# Install
& $py -m pip install --upgrade https://echology.io/downloads/signal_provenance-1.0.0-py3-none-any.whl

Write-Host ""
Write-Host "Installed. Starting Signal Provenance..." -ForegroundColor Green
Write-Host ""

# Launch
signal-provenance

#!/usr/bin/env bash
# Signal Provenance installer -- macOS / Linux
# Usage: curl -sSL https://echology.io/install.sh | bash
set -euo pipefail

VENV="$HOME/.signal-provenance"
WHEEL_URL="https://echology.io/downloads/signal_provenance-1.0.0-py3-none-any.whl"

echo "Signal Provenance -- installing..."
echo ""

# Find Python
PY=""
for cmd in python3 python; do
    if command -v "$cmd" &>/dev/null; then
        MAJOR=$($cmd -c "import sys; print(sys.version_info.major)")
        MINOR=$($cmd -c "import sys; print(sys.version_info.minor)")
        if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 9 ]; then
            PY="$cmd"
            break
        fi
    fi
done

if [ -z "$PY" ]; then
    echo "Error: Python 3.9+ is required."
    echo "Install from https://python.org/downloads/ and try again."
    exit 1
fi

echo "Found $($PY --version)"

# Create isolated venv
if [ ! -d "$VENV" ]; then
    echo "Creating environment..."
    $PY -m venv "$VENV"
fi

# Install
echo "Installing Signal Provenance..."
"$VENV/bin/pip" install --upgrade --quiet "$WHEEL_URL"
"$VENV/bin/pip" install --upgrade --quiet weasyprint pystray Pillow

echo ""
echo "Installed. Launching Signal Provenance..."
echo ""

# Launch in background with tray icon
nohup "$VENV/bin/python" -m signal_provenance &>/dev/null &
disown

echo "Signal Provenance is running. Look for the tray icon."
echo "To run again later:  ~/.signal-provenance/bin/python -m signal_provenance"
echo ""

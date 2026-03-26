#!/usr/bin/env bash
# Signal Provenance installer -- macOS / Linux
# Usage: curl -sSL https://echology.io/install.sh | bash
set -euo pipefail

echo "Signal Provenance -- installing..."

# Check Python
if command -v python3 &>/dev/null; then
    PY=python3
elif command -v python &>/dev/null; then
    PY=python
else
    echo "Error: Python 3.11+ is required."
    echo "Install from https://python.org/downloads/ and try again."
    exit 1
fi

# Check version
VER=$($PY -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
MAJOR=$($PY -c "import sys; print(sys.version_info.major)")
MINOR=$($PY -c "import sys; print(sys.version_info.minor)")

if [ "$MAJOR" -lt 3 ] || ([ "$MAJOR" -eq 3 ] && [ "$MINOR" -lt 9 ]); then
    echo "Error: Python $VER found, but 3.9+ is required."
    echo "Install from https://python.org/downloads/ and try again."
    exit 1
fi

echo "Found Python $VER"

# Install
$PY -m pip install --upgrade https://echology.io/downloads/signal_provenance-1.0.0-py3-none-any.whl

echo ""
echo "Installed. Starting Signal Provenance..."
echo ""

# Launch
signal-provenance

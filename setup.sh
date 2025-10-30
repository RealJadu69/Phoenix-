#!/usr/bin/env bash
set -euo pipefail

# Determine current repo root
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ASSETS_SRC="$ROOT_DIR/assets"
RES_SRC="$ROOT_DIR/resources"

INSTALL_HOME="$HOME/.phoenix"
ASSETS_DST="$INSTALL_HOME/assets"
RES_DST="$INSTALL_HOME/resources"

# Check source folders exist
if [ ! -d "$ASSETS_SRC" ]; then
    echo "Error: assets folder not found at $ASSETS_SRC"
    exit 1
fi

if [ ! -d "$RES_SRC" ]; then
    echo "Error: resources folder not found at $RES_SRC"
    exit 1
fi

# Create destination
mkdir -p "$ASSETS_DST" "$RES_DST"

# Copy safely
cp -a "$ASSETS_SRC/." "$ASSETS_DST/"
cp -a "$RES_SRC/." "$RES_DST/"

echo "[PHOENIX] Assets and resources copied to $INSTALL_HOME"

# ensure PATH includes our resources utils
export PHOENIX_HOME="$INSTALL_HOME"
export PHOENIX_RES="$RES_DST"
export PHOENIX_ASSETS="$ASSETS_DST"

# Basic environment
echo "[PHOENIX] Updating pkg..."
pkg update -y || true
pkg upgrade -y || true

echo "[PHOENIX] Installing minimal dependencies..."
pkg install -y git python nodejs curl wget proot-distro dialog || true

# accept storage
if [ ! -d "$HOME/storage" ]; then
  echo "[PHOENIX] Requesting Termux storage permission..."
  termux-setup-storage || true
fi

# ensure utils executable
chmod +x "$PHOENIX_RES"/utils/*.sh
chmod +x "$PHOENIX_RES"/*.sh
chmod +x "$PHOENIX_RES"/groups/*.sh

# boot menu
python3 "$PHOENIX_RES/MenuHandler.py" "$PHOENIX_HOME"

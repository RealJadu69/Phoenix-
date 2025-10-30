#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_HOME="${HOME}/.phoenix"
ASSETS_SRC="$ROOT_DIR/assets"
RES_SRC="$ROOT_DIR/resources"
ASSETS_DST="$INSTALL_HOME/assets"
RES_DST="$INSTALL_HOME/resources"

mkdir -p "$INSTALL_HOME"
# copy assets and resources so repo can be removed later
cp -a "$ASSETS_SRC" "$ASSETS_DST"
cp -a "$RES_SRC" "$RES_DST"

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

#!/usr/bin/env bash
set -euo pipefail

# --- Determine repo root ---
# If running inside cloned repo, use current folder
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Source & destination folders ---
ASSETS_SRC="$ROOT_DIR/assets"
RES_SRC="$ROOT_DIR/resources"
INSTALL_HOME="$HOME/.phoenix"
ASSETS_DST="$INSTALL_HOME/assets"
RES_DST="$INSTALL_HOME/resources"

# --- Create directories ---
mkdir -p "$ASSETS_DST" "$RES_DST"

# --- Check & copy safely ---
if [ -d "$ASSETS_SRC" ]; then
    cp -a "$ASSETS_SRC/." "$ASSETS_DST/"
else
    echo "[PHOENIX] Warning: assets folder not found at $ASSETS_SRC"
fi

if [ -d "$RES_SRC" ]; then
    cp -a "$RES_SRC/." "$RES_DST/"
else
    echo "[PHOENIX] Warning: resources folder not found at $RES_SRC"
fi

# --- Install dependencies ---
pkg update -y
pkg upgrade -y
pkg install -y git python nodejs proot-distro curl wget dialog

# --- Termux storage ---
if [ ! -d "$HOME/storage" ]; then
    termux-setup-storage || true
fi

# --- Permissions for scripts ---
chmod +x "$RES_DST"/utils/*.sh
chmod +x "$RES_DST"/*.sh
chmod +x "$RES_DST"/groups/*.sh

# --- Launch menu ---
python3 "$RES_DST/MenuHandler.py" "$INSTALL_HOME"

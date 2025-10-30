#!/usr/bin/env bash
set -euo pipefail

# --- Paths ---
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_HOME="$HOME/.phoenix"

ASSETS_SRC="$ROOT_DIR/assets"
RES_SRC="$ASSETS_SRC/resources"   # Look inside assets now
ASSETS_DST="$INSTALL_HOME/assets"
RES_DST="$INSTALL_HOME/resources"

echo "[PHOENIX] Preparing installation..."

# --- Create destination folders ---
mkdir -p "$ASSETS_DST" "$RES_DST"
mkdir -p "$RES_DST/utils" "$RES_DST/groups"

# --- Copy safely ---
if [ -d "$ASSETS_SRC" ]; then
    cp -a "$ASSETS_SRC/." "$ASSETS_DST/" || echo "[PHOENIX] Warning: Could not copy assets."
else
    echo "[PHOENIX] Warning: assets folder not found!"
fi

if [ -d "$RES_SRC" ]; then
    cp -a "$RES_SRC/." "$RES_DST/" || echo "[PHOENIX] Warning: Could not copy resources."
else
    echo "[PHOENIX] Warning: resources folder not found inside assets!"
fi

# --- Set executable permissions safely ---
if [ -d "$RES_DST/utils" ]; then
    find "$RES_DST/utils" -type f -name "*.sh" -exec chmod +x {} \;
fi
if [ -d "$RES_DST/groups" ]; then
    find "$RES_DST/groups" -type f -name "*.sh" -exec chmod +x {} \;
fi
if [ -d "$RES_DST" ]; then
    find "$RES_DST" -maxdepth 1 -type f -name "*.sh" -exec chmod +x {} \;
fi

# --- Install dependencies ---
echo "[PHOENIX] Installing required packages..."
pkg update -y
pkg upgrade -y
pkg install -y git python nodejs proot-distro curl wget dialog

# --- Termux storage permission ---
if [ ! -d "$HOME/storage" ]; then
    echo "[PHOENIX] Requesting storage permission..."
    termux-setup-storage || true
fi

# --- Launch menu ---
MENU_SCRIPT="$RES_DST/MenuHandler.py"
if [ -f "$MENU_SCRIPT" ]; then
    python3 "$MENU_SCRIPT" "$INSTALL_HOME"
else
    echo "[PHOENIX] Error: MenuHandler.py not found in $RES_DST"
    exit 1
fi

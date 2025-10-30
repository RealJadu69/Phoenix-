#!/usr/bin/env bash
set -euo pipefail

# --- Paths ---
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$ROOT_DIR/assets"
RES_DIR="$ROOT_DIR/resources"

echo "[PHOENIX] Preparing environment..."

# --- Set executable permissions safely ---
if [ -d "$RES_DIR/utils" ]; then
    find "$RES_DIR/utils" -type f -name "*.sh" -exec chmod +x {} \;
fi
if [ -d "$RES_DIR/groups" ]; then
    find "$RES_DIR/groups" -type f -name "*.sh" -exec chmod +x {} \;
fi
find "$RES_DIR" -maxdepth 1 -type f -name "*.sh" -exec chmod +x {} \;

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
MENU_SCRIPT="$RES_DIR/MenuHandler.py"
if [ -f "$MENU_SCRIPT" ]; then
    echo "[PHOENIX] Launching menu..."
    python3 "$MENU_SCRIPT" "$ROOT_DIR"
else
    echo "[PHOENIX] ERROR: MenuHandler.py not found in $RES_DIR"
    exit 1
fi

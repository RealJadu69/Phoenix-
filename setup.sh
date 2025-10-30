#!/usr/bin/env bash
set -euo pipefail

# === Get absolute repo root ===
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
RES_DIR="$ROOT_DIR/resources"

# === Make sure resources exist ===
if [ ! -d "$RES_DIR" ]; then
    echo "[PHOENIX] Error: resources folder not found in $ROOT_DIR"
    exit 1
fi

# === Make scripts executable ===
echo "[PHOENIX] Preparing environment..."
find "$RES_DIR" -type f -name "*.sh" -exec chmod +x {} \; || true

# === Update Termux and install dependencies ===
echo "[PHOENIX] Updating Termux and installing dependencies..."
pkg update -y || true
pkg upgrade -y || true
pkg install -y git python curl wget dialog || true
pkg install -y nodejs proot-distro || true

# === Termux storage permission ===
if [ ! -d "$HOME/storage" ]; then
    echo "[PHOENIX] Requesting Termux storage permission..."
    termux-setup-storage || true
    sleep 3
fi

# === Launch MenuHandler ===
MENU_PY="$RES_DIR/MenuHandler.py"
if [ ! -f "$MENU_PY" ]; then
    echo "[PHOENIX] Error: MenuHandler.py not found at $MENU_PY"
    exit 1
fi

echo
echo "[PHOENIX] Launching interactive menu..."
sleep 1
python3 "$MENU_PY" "$ROOT_DIR"


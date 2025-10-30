#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RES_DIR="$ROOT_DIR/resources"

# Make all scripts executable
find "$RES_DIR/groups" "$RES_DIR/utils" -type f -name "*.sh" -exec chmod +x {} \;

# Install dependencies
pkg update -y
pkg upgrade -y
pkg install -y git python nodejs proot-distro curl wget dialog

# Termux storage permission
if [ ! -d "$HOME/storage" ]; then
    termux-setup-storage || true
fi

# Launch menu
python3 "$RES_DIR/MenuHandler.py" "$ROOT_DIR"

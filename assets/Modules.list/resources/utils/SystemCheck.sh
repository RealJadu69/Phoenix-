#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/InstallerCore.sh"
info "Checking Termux environment..."
if ! command -v pkg >/dev/null 2>&1; then
  err "This installer is designed for Termux. 'pkg' not found."
  exit 1
fi
ok "Environment looks like Termux."

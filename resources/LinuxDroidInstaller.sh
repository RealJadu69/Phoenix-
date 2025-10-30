#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/utils" && pwd)/InstallerCore.sh"
REPO="https://github.com/AryanVBW/LinuxDroid.git"
DEST="${HOME}/.phoenix/cache/LinuxDroid"
info "Cloning LinuxDroid to $DEST (opt-in)..."
git_clone_safe "$REPO" "$DEST"
ok "LinuxDroid cloned. If you wish to run its installer: bash $DEST/install.sh"

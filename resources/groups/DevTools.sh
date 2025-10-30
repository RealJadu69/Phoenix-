#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../utils" && pwd)/InstallerCore.sh"
PKGFILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pkgs.txt"
cat > "$PKGFILE" <<'EOF'
build-essential
clang
make
cmake
git
neovim
ripgrep
fd
fzf
python
nodejs
EOF
pkg_install_list "$PKGFILE" 5
ok "Developer tools installed."

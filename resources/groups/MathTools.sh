#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../utils" && pwd)/InstallerCore.sh"
PKGFILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pkgs.txt"
cat > "$PKGFILE" <<'EOF'
python
python-pip
bc
mbuffer
octave
EOF
pkg_install_list "$PKGFILE" 4
# pip math libs
REQ="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pip.txt"
cat > "$REQ" <<'EOF'
numpy
scipy
sympy
matplotlib
EOF
pip_install_list "$REQ"
ok "Math and science tools installed."

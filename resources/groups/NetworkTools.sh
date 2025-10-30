#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../utils" && pwd)/InstallerCore.sh"
PKGFILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pkgs.txt"
cat > "$PKGFILE" <<'EOF'
openssh
net-tools
inetutils
nmap
tcpdump
tshark
curl
EOF
pkg_install_list "$PKGFILE" 4
ok "Network utilities installed."

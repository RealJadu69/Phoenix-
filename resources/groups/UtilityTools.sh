
#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../utils" && pwd)/InstallerCore.sh"
PKGFILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pkgs.txt"
cat > "$PKGFILE" <<'EOF'
rsync
unzip
zip
tar
openssl
jq
busybox
EOF
pkg_install_list "$PKGFILE" 6
ok "Utility tools installed."

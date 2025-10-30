
#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../utils" && pwd)/InstallerCore.sh"
PKGFILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pkgs.txt"
cat > "$PKGFILE" <<'EOF'
neofetch
lolcat
toilet
figlet
starship
EOF
pkg_install_list "$PKGFILE" 4
# starship install via npm or sh
if ! command -v starship >/dev/null 2>&1; then
  curl -fsSL https://starship.rs/install.sh | bash -s -- --yes
fi
ok "Visual/UX tools installed."

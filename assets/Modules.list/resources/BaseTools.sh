
#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/utils" && pwd)/InstallerCore.sh"
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKGFILE="$MODULE_DIR/pkgs.txt"
cat > "$PKGFILE" <<'EOF'
git
curl
wget
python
python-pip
nodejs
npm
neofetch
htop
ncdu
tmux
vim
zsh
openssh
proot-distro
termux-api
aria2
EOF
pkg_install_list "$PKGFILE" 6
ok "Base tools installed."
# pip global requirements (optional)
REQ="$MODULE_DIR/pip-requirements.txt"
cat > "$REQ" <<'EOF'
rich
simple-term-menu
EOF
pip_install_list "$REQ"
ok "Python packages installed."

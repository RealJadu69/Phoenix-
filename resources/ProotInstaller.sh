
#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/utils" && pwd)/InstallerCore.sh"
info "Installing Debian via proot-distro..."
proot-distro install debian -y || true
info "To enter Debian: proot-distro login debian"
ok "Proot-distro step finished."

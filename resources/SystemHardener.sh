
#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/utils" && pwd)/InstallerCore.sh"
info "Applying safe hardening tweaks..."
# safer umask
grep -qxF 'umask 027' ~/.profile || echo 'umask 027' >> ~/.profile
# create update helper
cat > ~/.local/bin/phoenix-update <<'BASH'
#!/usr/bin/env bash
pkg update -y && pkg upgrade -y
BASH
chmod +x ~/.local/bin/phoenix-update
ok "Hardening applied and update helper created (~/.local/bin/phoenix-update)."

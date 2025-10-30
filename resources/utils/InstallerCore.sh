#!/usr/bin/env bash
set -euo pipefail
CORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CORE_DIR/Color.sh" || true

LOG_DIR="${HOME}/.phoenix/logs"
STATE_DIR="${HOME}/.phoenix/state"
mkdir -p "$LOG_DIR" "$STATE_DIR"

log() { echo -e "${BLUE}[PHX]${RESET} $*"; }
info() { echo -e "${YELLOW}[INFO]${RESET} $*"; }
ok() { echo -e "${GREEN}[OK]${RESET} $*"; }
err() { echo -e "${RED}[ERR]${RESET} $*"; }

# safe pkg install wrapper: install in chunks to avoid db locks
pkg_install_list() {
  local pkgs_file="$1"
  local chunk_size="${2:-6}"
  [ -f "$pkgs_file" ] || return 0
  mapfile -t pkgs < <(sed -e '/^\s*#/d' -e '/^\s*$/d' "$pkgs_file")
  local total=${#pkgs[@]}
  if [ "$total" -eq 0 ]; then
    info "No packages to install in $pkgs_file"
    return 0
  fi
  info "Installing $total packages from $(basename "$pkgs_file") in chunks of $chunk_size..."
  local i=0
  while [ $i -lt $total ]; do
    chunk=("${pkgs[@]:$i:$chunk_size}")
    echo "${chunk[@]}" | xargs pkg install -y --no-install-recommends
    i=$((i+chunk_size))
  done
  ok "Finished installing packages from $(basename "$pkgs_file")"
}

# parallel pip installer (safe)
pip_install_list() {
  local req="$1"
  [ -f "$req" ] || return 0
  pip3 install --upgrade pip setuptools wheel
  xargs -a "$req" -n1 -P4 pip3 install
}

# parallel npm installer
npm_install_list() {
  local file="$1"
  [ -f "$file" ] || return 0
  xargs -a "$file" -n1 -P4 npm install -g
}

# git clone safe
git_clone_safe() {
  local repo="$1"; local dest="$2"
  if [ -d "$dest/.git" ]; then
    info "Already cloned $repo"
    return 0
  fi
  git clone --depth=1 "$repo" "$dest"
}

# run module helper
run_module() {
  local script="$1"
  if [ -x "$script" ]; then
    info "Running $script"
    bash "$script"
  elif [ -f "$script" ]; then
    info "Making $script executable and running"
    chmod +x "$script"
    bash "$script"
  else
    err "Module $script not found"
  fi
}

#!/usr/bin/env bash
# ===================================================================
#  🔥 REDTeam – Installateur d'outils REDTeam (tools.json-driven)
# ===================================================================

set -euo pipefail

RED="\033[0;31m"; GRN="\033[0;32m"; YLW="\033[1;33m"
BLU="\033[0;34m"; CYN="\033[0;36m"; NC="\033[0m"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_JSON="$ROOT_DIR/tools.json"
LAB_DIR="/opt/redteam-lab"
LOGFILE="$HOME/redteam-tools-install.log"

INSTALLED=0; SKIPPED=0; FAILED=0
FAILED_TOOLS=()

say() { echo -e "${BLU}[*]${NC} $*"; }
ok() { echo -e "${GRN}[✓]${NC} $*"; INSTALLED=$((INSTALLED+1)); }
skip() { echo -e "${YLW}[~]${NC} $*"; SKIPPED=$((SKIPPED+1)); }
fail() { echo -e "${RED}[✗]${NC} $*"; FAILED=$((FAILED+1)); FAILED_TOOLS+=("$1"); }

require_root() {
  [[ $EUID -ne 0 ]] && { echo -e "${RED}Exécute en root.${NC}"; exit 1; }
}

detect_pkg() {
  . /etc/os-release
  case "${ID,,}" in
    debian|ubuntu|kali|parrot|linuxmint) PKG="apt" ;;
    arch|manjaro) PKG="pacman" ;;
    fedora|rhel|centos|rocky|almalinux) PKG="dnf" ;;
    *) PKG="unknown" ;;
  esac
  say "Package manager: $PKG"
}

pkg_install() {
  local pkg="$1"
  case "$PKG" in
    apt) dpkg -s "$pkg" &>/dev/null && { skip "$pkg"; return; }
         apt install -y "$pkg" &>/dev/null && ok "$pkg" || fail "$pkg" ;;
    pacman) pacman -Qi "$pkg" &>/dev/null && { skip "$pkg"; return; }
            pacman -S --noconfirm "$pkg" &>/dev/null && ok "$pkg" || fail "$pkg" ;;
    dnf) rpm -q "$pkg" &>/dev/null && { skip "$pkg"; return; }
         dnf install -y "$pkg" &>/dev/null && ok "$pkg" || fail "$pkg" ;;
    *) fail "$pkg (unknown pkg manager)" ;;
  esac
}

pip_install() {
  pip3 show "$1" &>/dev/null && { skip "$1 (pip)"; return; }
  pip3 install "$1" &>/dev/null && ok "$1 (pip)" || fail "$1 (pip)"
}

git_install() {
  local repo="$1" dest="$2"
  mkdir -p "$LAB_DIR"
  [[ -d "$dest" ]] && { skip "$dest"; return; }
  git clone --depth=1 "$repo" "$dest" &>/dev/null && ok "$dest" || fail "$dest"
}

bootstrap() {
  say "Installation des dépendances"
  case "$PKG" in
    apt) apt update -y &>/dev/null; apt install -y python3 python3-pip git curl wget jq fzf &>/dev/null ;;
    pacman) pacman -Sy --noconfirm &>/dev/null; pacman -S --noconfirm python python-pip git curl wget jq fzf &>/dev/null ;;
    dnf) dnf install -y python3 python3-pip git curl wget jq fzf &>/dev/null ;;
  esac
}

install_module() {
  local module="$1"
  say "Module : $module"

  local count
  count=$(jq ".modules[\"$module\"].tools | length" "$TOOLS_JSON")

  for i in $(seq 0 $((count-1))); do
    local name type
    name=$(jq -r ".modules[\"$module\"].tools[$i].name" "$TOOLS_JSON")
    type=$(jq -r ".modules[\"$module\"].tools[$i].type" "$TOOLS_JSON")

    case "$type" in
      binary)
        for p in $(jq -r ".modules[\"$module\"].tools[$i].install.pkg[]" "$TOOLS_JSON"); do
          pkg_install "$p"
        done ;;
      python)
        for p in $(jq -r ".modules[\"$module\"].tools[$i].install.pip[]" "$TOOLS_JSON"); do
          pip_install "$p"
        done ;;
      git)
        git_install \
          "$(jq -r ".modules[\"$module\"].tools[$i].install.git" "$TOOLS_JSON")" \
          "$(jq -r ".modules[\"$module\"].tools[$i].install.dest" "$TOOLS_JSON")"
        ;;
    esac
  done
}

menu() {
  clear
  echo -e "${CYN}REDTeam – Installateur d'outils${NC}"
  echo
  jq -r '.modules | keys[]' "$TOOLS_JSON"
  echo
  read -rp "Module (ou 'all') : " mod

  [[ "$mod" == "all" ]] && {
    for m in $(jq -r '.modules | keys[]' "$TOOLS_JSON"); do install_module "$m"; done
    return
  }

  install_module "$mod"
}

summary() {
  echo
  echo "Installés : $INSTALLED"
  echo "Ignorés   : $SKIPPED"
  echo "Échecs    : $FAILED"
}

require_root
detect_pkg
bootstrap
menu
summary

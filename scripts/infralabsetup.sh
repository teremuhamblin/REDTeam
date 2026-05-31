#!/usr/bin/env bash
# ===================================================================
#  🔥 REDTeam – Offensive Security Lab Provisioner
#  Version: 1.1
#  Project: https://github.com/teremuhamblin/REDTeam
#
#  Installe un environnement complet pour :
#   - Reconnaissance (active/passive)
#   - Initial Access
#   - Lateral Movement
#   - Persistence
#   - Outils auxiliaires (OpSec, reporting, utils)
#   - Setup d’un lab local simulé
#
#  Compatible : Debian / Ubuntu / Kali / Parrot / Arch / Fedora
# ===================================================================

set -euo pipefail

# ---------------------- Colors ----------------------
RED="\033[0;31m"; GRN="\033[0;32m"; YLW="\033[1;33m"
BLU="\033[0;34m"; CYN="\033[0;36m"; NC="\033[0m"

# ---------------------- Globals ----------------------
LOGFILE="${LOGFILE:-$HOME/redteam-lab-install.log}"
LAB_DIR="/opt/redteam-lab"
WORK_DIR="${WORK_DIR:-/tmp/redteam_workdir}"
INSTALLED=0; SKIPPED=0; FAILED=0
declare -ga FAILED_TOOLS=()

say() { echo -e "${BLU}[*]${NC} $*"; }
ok() { echo -e "${GRN}[✓]${NC} $*"; INSTALLED=$((INSTALLED+1)); }
skip() { echo -e "${YLW}[~]${NC} $*"; SKIPPED=$((SKIPPED+1)); }
fail() { echo -e "${RED}[✗]${NC} $*"; FAILED=$((FAILED+1)); FAILED_TOOLS+=("$1"); echo "FAIL: $*" >>"$LOGFILE"; }

# ---------------------- Root check ----------------------
require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Run as root: sudo bash $0${NC}"
        exit 1
    fi
}

# ---------------------- Distro detection ----------------------
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "${ID,,}" in
            kali|debian|ubuntu|parrot|linuxmint|pop) PKG="apt" ;;
            arch|manjaro|endeavouros) PKG="pacman" ;;
            fedora|rhel|centos|rocky|almalinux) PKG="dnf" ;;
            *) PKG="unknown" ;;
        esac
    fi
    echo -e "${CYN}[i]${NC} Package manager: $PKG"
}

# ---------------------- Package install ----------------------
pkg_install() {
    local pkg="$1"
    case "$PKG" in
        apt)
            dpkg -s "$pkg" &>/dev/null && { skip "$pkg"; return; }
            apt install -y "$pkg" &>/dev/null && ok "$pkg" || fail "$pkg"
            ;;
        pacman)
            pacman -Qi "$pkg" &>/dev/null && { skip "$pkg"; return; }
            pacman -S --noconfirm --needed "$pkg" &>/dev/null && ok "$pkg" || fail "$pkg"
            ;;
        dnf)
            rpm -q "$pkg" &>/dev/null && { skip "$pkg"; return; }
            dnf install -y "$pkg" &>/dev/null && ok "$pkg" || fail "$pkg"
            ;;
        *)
            fail "$pkg (unknown pkg manager)"
            ;;
    esac
}

install_pip() {
    local pkg="$1"
    pip3 show "$pkg" &>/dev/null && { skip "$pkg"; return; }
    pip3 install "$pkg" &>/dev/null && ok "$pkg (pip)" || fail "$pkg (pip)"
}

install_git() {
    local repo="$1" dst="$2"
    mkdir -p "$LAB_DIR"
    if [[ -d "$LAB_DIR/$dst" ]]; then skip "$dst"; return; fi
    git clone --depth=1 "$repo" "$LAB_DIR/$dst" &>/dev/null && ok "$dst" || fail "$dst"
}

# ---------------------- Bootstrap ----------------------
bootstrap_basics() {
    say "Installing base dependencies"
    case "$PKG" in
        apt)
            apt update -y &>/dev/null
            apt install -y python3 python3-pip git curl wget fzf &>/dev/null
            ;;
        pacman)
            pacman -Sy --noconfirm &>/dev/null
            pacman -S --noconfirm python python-pip git curl wget fzf &>/dev/null
            ;;
        dnf)
            dnf install -y python3 python3-pip git curl wget fzf &>/dev/null
            ;;
    esac
}

# ---------------------- REDTEAM MODULES ----------------------

install_recon() {
    say "Installing Reconnaissance tools"
    install_pip "arjun"
    install_git "https://github.com/s0md3v/XSStrike.git" "XSStrike"
    install_git "https://github.com/projectdiscovery/nuclei-templates.git" "nuclei-templates"
}

install_initial_access() {
    say "Installing Initial Access tools"
    install_pip "impacket"
    install_git "https://github.com/r0oth3x49/ghauri.git" "ghauri"
}

install_lateral_movement() {
    say "Installing Lateral Movement tools"
    pkg_install "evil-winrm"
    install_pip "netexec"
    install_git "https://github.com/GhostPack/Rubeus.git" "Rubeus"
}

install_persistence() {
    say "Installing Persistence tools"
    install_git "https://github.com/BC-SECURITY/Empire.git" "Empire"
}

install_utils() {
    say "Installing Utility tools"
    pkg_install "jq"
    pkg_install "nmap"
    pkg_install "whois"
    pkg_install "dnsutils"
}

# ---------------------- NEW MODULE: LOCAL LAB SETUP ----------------------
install_local_lab() {
    say "Setting up local simulated lab environment"
    mkdir -p "$WORK_DIR"
    ok "Local lab directory created at $WORK_DIR"
    echo "Lab setup terminé (simulé)." >> "$LOGFILE"
}

# ---------------------- TUI ----------------------
menu() {
    clear
    echo -e "${CYN}REDTEAM LAB SETUP — Select modules:${NC}"
    local options=(
        "Reconnaissance"
        "Initial Access"
        "Lateral Movement"
        "Persistence"
        "Utilities"
        "Local Lab Setup"
        "FULL LAB"
        "Quit"
    )
    local choice
    choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="Modules > ")

    case "$choice" in
        "Reconnaissance") install_recon ;;
        "Initial Access") install_initial_access ;;
        "Lateral Movement") install_lateral_movement ;;
        "Persistence") install_persistence ;;
        "Utilities") install_utils ;;
        "Local Lab Setup") install_local_lab ;;
        "FULL LAB")
            install_recon
            install_initial_access
            install_lateral_movement
            install_persistence
            install_utils
            install_local_lab
            ;;
        "Quit") exit 0 ;;
    esac
}

# ---------------------- Summary ----------------------
print_summary() {
    echo
    echo "============================================="
    echo -e "  Installed: ${GRN}$INSTALLED${NC}"
    echo -e "  Skipped:   ${YLW}$SKIPPED${NC}"
    echo -e "  Failed:    ${RED}$FAILED${NC}"
    echo "============================================="
    ((FAILED>0)) && echo -e "${RED}Failed:${NC} ${FAILED_TOOLS[*]}"
}

# ---------------------- Main ----------------------
require_root
detect_distro
bootstrap_basics
menu
print_summary

#!/usr/bin/env bash
# ===================================================================
#  🔥 REDTeam CLI – redteamctl
#  Projet : https://github.com/Teremu/REDTeam
#
#  Point d'entrée officiel pour :
#   - rtops (core Python)
#   - outils (tools.json, install)
#   - lab (infralabsetup, workdir)
#   - rapports (reports/)
#   - docs (opsec, RoE, méthodo)
#   - scénarios de cyber-range (range/)
# ===================================================================

set -euo pipefail

# ---------------------- Couleurs ----------------------
RED="\033[0;31m"; GRN="\033[0;32m"; YLW="\033[1;33m"
BLU="\033[0;34m"; CYN="\033[0;36m"; MAG="\033[0;35m"; NC="\033[0m"

# ---------------------- Paths -------------------------
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"
DOCS_DIR="$ROOT_DIR/docs"
RANGE_DIR="$ROOT_DIR/range"
REPORTS_DIR="$ROOT_DIR/reports"
RTOPS_DIR="$ROOT_DIR/rtops"
TOOLS_JSON="$ROOT_DIR/tools.json"

LAB_DIR="/opt/redteam-lab"
WORK_DIR="${WORK_DIR:-/tmp/redteam_workdir}"

# ---------------------- Helpers -----------------------
log_info()  { echo -e "${BLU}[*]${NC} $*"; }
log_ok()    { echo -e "${GRN}[✓]${NC} $*"; }
log_warn()  { echo -e "${YLW}[!]${NC} $*"; }
log_err()   { echo -e "${RED}[✗]${NC} $*"; }

usage() {
  cat <<EOF
${CYN}REDTeam CLI – redteamctl${NC}

Usage:
  redteamctl <commande> [options]

Commandes principales:
  rtops           Lancer le core Python rtops (CLI offensif)
  tools           Gérer les outils (tools.json, install, liste)
  lab             Gérer le lab local / infra d'entraînement
  reports         Générer ou lister les rapports
  docs            Afficher les docs clés (opsec, RoE, méthodo)
  range           Gérer les scénarios de cyber-range
  version         Afficher la version du projet
  help            Afficher cette aide

Exemples:
  redteamctl rtops recon passive
  redteamctl tools install all
  redteamctl lab setup
  redteamctl reports generate engagement-001
  redteamctl docs opsec
  redteamctl range list

EOF
}

# ---------------------- Checks ------------------------
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { log_err "Commande requise manquante: $1"; exit 1; }
}

require_file() {
  [[ -f "$1" ]] || { log_err "Fichier manquant: $1"; exit 1; }
}

# ---------------------- Subcommand: rtops -------------
cmd_rtops() {
  require_cmd python3
  require_file "$RTOPS_DIR/cli.py"

  if [[ $# -eq 0 ]]; then
    log_info "Lancement de rtops (mode interactif si implémenté)..."
    python3 "$RTOPS_DIR/cli.py"
  else
    log_info "rtops $*"
    python3 "$RTOPS_DIR/cli.py" "$@"
  fi
}

# ---------------------- Subcommand: tools -------------
cmd_tools() {
  require_cmd jq
  require_file "$TOOLS_JSON"

  local action="${1:-help}"
  shift || true

  case "$action" in
    list)
      log_info "Modules disponibles dans tools.json :"
      jq -r '.modules | keys[]' "$TOOLS_JSON"
      ;;
    show)
      local module="${1:-}"
      if [[ -z "$module" ]]; then
        log_err "Usage: redteamctl tools show <module>"
        exit 1
      fi
      log_info "Outils du module: $module"
      jq -r ".modules[\"$module\"].tools[].name" "$TOOLS_JSON"
      ;;
    install)
      local module="${1:-all}"
      require_cmd sudo
      require_cmd bash
      require_file "$SCRIPTS_DIR/redteam-tools-install.sh"

      if [[ "$module" == "all" ]]; then
        log_info "Installation de tous les modules d'outils..."
        sudo bash "$SCRIPTS_DIR/redteam-tools-install.sh" <<< "all"
      else
        log_info "Installation du module: $module"
        sudo bash "$SCRIPTS_DIR/redteam-tools-install.sh" <<< "$module"
      fi
      ;;
    help|*)
      cat <<EOF
Usage: redteamctl tools <action> [options]

Actions:
  list                 Lister les modules d'outils
  show <module>        Lister les outils d'un module
  install <module>     Installer un module (ou 'all')

Exemples:
  redteamctl tools list
  redteamctl tools show recon
  redteamctl tools install recon
  redteamctl tools install all
EOF
      ;;
  esac
}

# ---------------------- Subcommand: lab ---------------
cmd_lab() {
  local action="${1:-help}"
  shift || true

  case "$action" in
    setup)
      require_cmd sudo
      require_file "$SCRIPTS_DIR/infralabsetup.sh"
      log_info "Setup du lab d'infra (infralabsetup.sh)..."
      sudo bash "$SCRIPTS_DIR/infralabsetup.sh"
      ;;
    workdir)
      log_info "Création / vérification du workdir: $WORK_DIR"
      mkdir -p "$WORK_DIR"
      log_ok "Workdir prêt: $WORK_DIR"
      ;;
    info)
      echo -e "${MAG}Lab info:${NC}"
      echo "  LAB_DIR  : $LAB_DIR"
      echo "  WORK_DIR : $WORK_DIR"
      echo "  RANGE    : $RANGE_DIR"
      ;;
    help|*)
      cat <<EOF
Usage: redteamctl lab <action>

Actions:
  setup        Lancer le script d'installation du lab (infralabsetup.sh)
  workdir      Préparer le répertoire de travail local
  info         Afficher les chemins du lab

Exemples:
  redteamctl lab setup
  redteamctl lab workdir
  redteamctl lab info
EOF
      ;;
  esac
}

# ---------------------- Subcommand: reports -----------
cmd_reports() {
  local action="${1:-help}"
  shift || true

  case "$action" in
    generate)
      local engagement="${1:-engagement-001}"
      require_file "$SCRIPTS_DIR/generate_reports.sh"
      log_info "Génération des rapports pour: $engagement"
      bash "$SCRIPTS_DIR/generate_reports.sh" "$engagement"
      ;;
    list)
      log_info "Templates de rapports disponibles:"
      find "$REPORTS_DIR/templates" -maxdepth 1 -type f -name "*.md" -printf "  - %f\n"
      ;;
    help|*)
      cat <<EOF
Usage: redteamctl reports <action> [options]

Actions:
  generate <id>    Générer un set de rapports pour un engagement
  list             Lister les templates de rapports

Exemples:
  redteamctl reports generate engagement-001
  redteamctl reports list
EOF
      ;;
  esac
}

# ---------------------- Subcommand: docs --------------
cmd_docs() {
  local topic="${1:-help}"

  case "$topic" in
    opsec)
      require_file "$DOCS_DIR/opsec.md"
      log_info "Affichage de docs/opsec.md"
      ${PAGER:-less} "$DOCS_DIR/opsec.md"
      ;;
    roe|rules)
      require_file "$DOCS_DIR/rules-of-engagement.md"
      log_info "Affichage de docs/rules-of-engagement.md"
      ${PAGER:-less} "$DOCS_DIR/rules-of-engagement.md"
      ;;
    methodology)
      require_file "$DOCS_DIR/methodology.md"
      log_info "Affichage de docs/methodology.md"
      ${PAGER:-less} "$DOCS_DIR/methodology.md"
      ;;
    arch|architecture)
      require_file "$DOCS_DIR/architecture.md"
      log_info "Affichage de docs/architecture.md"
      ${PAGER:-less} "$DOCS_DIR/architecture.md"
      ;;
    help|*)
      cat <<EOF
Usage: redteamctl docs <topic>

Topics:
  opsec           Règles d'OpSec
  roe | rules     Rules of Engagement
  methodology     Méthodologie d'engagement
  arch            Architecture du framework

Exemples:
  redteamctl docs opsec
  redteamctl docs roe
  redteamctl docs methodology
EOF
      ;;
  esac
}

# ---------------------- Subcommand: range -------------
cmd_range() {
  local action="${1:-help}"
  shift || true

  case "$action" in
    list)
      if [[ -d "$RANGE_DIR/scenarios" ]]; then
        log_info "Scénarios disponibles:"
        find "$RANGE_DIR/scenarios" -maxdepth 1 -mindepth 1 -type d -printf "  - %f\n"
      else
        log_warn "Aucun dossier range/scenarios trouvé."
      fi
      ;;
    show)
      local scenario="${1:-}"
      if [[ -z "$scenario" ]]; then
        log_err "Usage: redteamctl range show <scenario>"
        exit 1
      fi
      local path="$RANGE_DIR/scenarios/$scenario/README.md"
      require_file "$path"
      log_info "Affichage du scénario: $scenario"
      ${PAGER:-less} "$path"
      ;;
    help|*)
      cat <<EOF
Usage: redteamctl range <action> [options]

Actions:
  list              Lister les scénarios de cyber-range
  show <scenario>   Afficher le README d'un scénario

Exemples:
  redteamctl range list
  redteamctl range show scenario_01_ad_breach
EOF
      ;;
  esac
}

# ---------------------- Subcommand: version -----------
cmd_version() {
  if [[ -f "$ROOT_DIR/tools.json" ]]; then
    local v
    v=$(jq -r '.version // "unknown"' "$ROOT_DIR/tools.json" 2>/dev/null || echo "unknown")
    echo -e "${CYN}REDTeam version:${NC} $v"
  else
    echo -e "${CYN}REDTeam version:${NC} (tools.json manquant)"
  fi
}

# ---------------------- Main --------------------------
main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    rtops)    cmd_rtops "$@" ;;
    tools)    cmd_tools "$@" ;;
    lab)      cmd_lab "$@" ;;
    reports)  cmd_reports "$@" ;;
    docs)     cmd_docs "$@" ;;
    range)    cmd_range "$@" ;;
    version)  cmd_version ;;
    help|*)   usage ;;
  esac
}

main "$@"

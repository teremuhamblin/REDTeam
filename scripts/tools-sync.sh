#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_JSON="$ROOT_DIR/tools.json"

jq '.modules | keys' "$TOOLS_JSON"

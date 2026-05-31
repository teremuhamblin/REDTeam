#!/usr/bin/env bash
# Génération simple de rapport à partir d'un template
TEMPLATE="reports/templates/technical_report.md"
OUT="reports/report_$(date +%Y%m%d_%H%M%S).md"
if [ -f "$TEMPLATE" ]; then
  cp "$TEMPLATE" "$OUT"
  echo "Rapport généré: $OUT"
else
  echo "Template introuvable: $TEMPLATE"
  exit 1
fi

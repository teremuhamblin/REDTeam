#!/usr/bin/env bash
# Script minimal de setup d'un lab local (simulé)
set -e
echo "Création du répertoire de travail..."
mkdir -p "${WORK_DIR:-/tmp/redteam_workdir}"
echo "Lab setup terminé (simulé)."

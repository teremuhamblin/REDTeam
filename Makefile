# Makefile pour REDTeam
PYTHON ?= python3
PIP ?= pip
VENV_DIR ?= .venv
POETRY ?= poetry

.PHONY: help venv install install-poetry lint format test build package run docs clean docker

help:
	@echo "Targets disponibles:"
	@echo "  venv             -> créer un environnement virtuel dans $(VENV_DIR)"
	@echo "  install          -> installer les dépendances (poetry si présent, sinon pip)"
	@echo "  install-poetry   -> installer poetry si absent"
	@echo "  lint             -> lancer ruff et flake8"
	@echo "  format           -> formater le code avec black"
	@echo "  test             -> exécuter pytest"
	@echo "  build            -> construire la distribution (sdist + wheel)"
	@echo "  package          -> créer un package wheel"
	@echo "  run              -> exécuter le CLI rtops"
	@echo "  docs             -> générer la doc Sphinx si configuré"
	@echo "  clean            -> nettoyer artefacts build et caches"
	@echo "  docker           -> construire image Docker (si Dockerfile présent)"

venv:
	@echo "Création d'un environnement virtuel dans $(VENV_DIR)"
	$(PYTHON) -m venv $(VENV_DIR)
	@echo "Activez-le avec: source $(VENV_DIR)/bin/activate"

install:
	@if command -v $(POETRY) >/dev/null 2>&1; then \
		echo "Installation via poetry..."; \
		$(POETRY) install; \
	else \
		if [ -f "requirements.txt" ]; then \
			echo "Installation via pip..."; \
			$(PIP) install -r requirements.txt; \
		else \
			echo "requirements.txt introuvable."; \
			exit 1; \
		fi \
	fi

install-poetry:
	@echo "Installation de poetry (utilisateur local)..."
	@python3 -m pip install --user poetry
	@echo "Ajoutez ~/.local/bin à votre PATH si nécessaire."

lint:
	@echo "Lancement des linters..."
	@if command -v ruff >/dev/null 2>&1; then \
		ruff check .; \
	else \
		echo "ruff non installé. Ignoré."; \
	fi
	@if command -v flake8 >/dev/null 2>&1; then \
		flake8; \
	else \
		echo "flake8 non installé. Ignoré."; \
	fi

format:
	@echo "Formatage du code avec black..."
	@if command -v black >/dev/null 2>&1; then \
		black .; \
	else \
		echo "black non installé. Ignoré."; \
	fi

test:
	@echo "Exécution des tests..."
	@if command -v pytest >/dev/null 2>&1; then \
		pytest -q; \
	else \
		echo "pytest non installé. Installez via pip."; \
	fi

build:
	@echo "Construction des artefacts..."
	@if command -v $(POETRY) >/dev/null 2>&1; then \
		$(POETRY) build; \
	else \
		python -m build; \
	fi

package:
	@echo "Création du package wheel..."
	@if command -v $(POETRY) >/dev/null 2>&1; then \
		$(POETRY) build -f wheel; \
	else \
		python -m build --wheel; \
	fi

run:
	@echo "Exécution du CLI rtops..."
	@$(PYTHON) -m rtops.cli

docs:
	@echo "Génération de la documentation (Sphinx)..."
	@if command -v sphinx-build >/dev/null 2>&1 && [ -d "docs" ]; then \
		sphinx-build -b html docs docs/_build/html; \
		echo "Docs générées dans docs/_build/html"; \
	else \
		echo "Sphinx non installé ou dossier docs manquant."; \
	fi

clean:
	@echo "Nettoyage des artefacts..."
	@rm -rf build/ dist/ *.egg-info .pytest_cache .mypy_cache .cache docs/_build htmlcov
	@find . -type d -name "__pycache__" -exec rm -rf {} +
	@echo "Nettoyage terminé."

docker:
	@echo "Construction d'une image Docker (Dockerfile requis)..."
	@if [ -f Dockerfile ]; then \
		docker build -t redteam:latest .; \
	else \
		echo "Dockerfile introuvable."; \
	fi

.PHONY: install dev test lint format

install:
\tpython -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt && pip install -e .

dev:
\tpip install -r requirements-dev.txt

test:
\tpytest

lint:
\tflake8 rtops

format:
\tblack rtops

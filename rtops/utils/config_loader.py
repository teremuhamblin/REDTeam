import os
from pathlib import Path
import yaml

def load_config(path: str | None):
    if path and Path(path).exists():
        with open(path, "r", encoding="utf-8") as f:
            return yaml.safe_load(f)
    # fallback to environment variables minimal
    return {
        "env": os.getenv("RTOPS_ENV", "lab"),
        "work_dir": os.getenv("WORK_DIR", "/tmp/redteam_workdir"),
    }

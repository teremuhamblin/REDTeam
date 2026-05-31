import json
from pathlib import Path

TOOLS_FILE = Path(__file__).resolve().parents[2] / "tools.json"

def load_tools():
    with TOOLS_FILE.open("r", encoding="utf-8") as f:
        return json.load(f)

def list_modules():
    return list(load_tools().get("modules", {}).keys())

def list_tools(module):
    data = load_tools()
    return data["modules"].get(module, {}).get("tools", [])

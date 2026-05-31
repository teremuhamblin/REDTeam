"""Enumeration SMB simulée (lab only)."""

def enumerate_smb(target: str):
    return {"target": target, "shares": ["Public", "Secrets"]}

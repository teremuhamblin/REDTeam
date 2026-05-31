"""Module de reconnaissance passive minimal (lab only)."""

def run(target: str):
    # Simule une collecte passive
    data = {
        "target": target,
        "whois": "whois-simulated",
        "dns": ["1.2.3.4"],
    }
    return data

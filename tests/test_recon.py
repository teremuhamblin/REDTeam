from rtops.recon.passive_recon import run as passive_run

def test_passive_recon_basic():
    res = passive_run("example.com")
    assert res["target"] == "example.com"
    assert "whois" in res

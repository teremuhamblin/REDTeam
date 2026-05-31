from rtops.utils.config_loader import load_config

def test_load_config_defaults():
    cfg = load_config(None)
    assert "env" in cfg
    assert "work_dir" in cfg

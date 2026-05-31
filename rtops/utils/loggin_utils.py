import logging

def setup_logging(level="INFO"):
    logging.basicConfig(level=getattr(logging, level))
    return logging.getLogger("rtops")

"""Filesystem locations for configuration, logs, and collected data."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LOG_DIR = ROOT / "logs"
DATA_DIR = ROOT / "data"
REPORTS_DIR = DATA_DIR / "reports"
COLLECTED_DIR = DATA_DIR / "collected"
ML_DIR = DATA_DIR / "ml"


def ensure_dir(path: Path) -> Path:
    path.mkdir(parents=True, exist_ok=True)
    return path


def log_path(filename: str) -> str:
    return str(ensure_dir(LOG_DIR) / filename)


def report_path(filename: str) -> str:
    return str(ensure_dir(REPORTS_DIR) / filename)

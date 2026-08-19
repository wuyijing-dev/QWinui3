#!/usr/bin/env python3
"""Run the QWinUI3 Gallery from Python (same QML as src/gallery).

  python examples/python-gallery/main.py
  python examples/python-gallery/main.py --smoke
  python examples/python-gallery/main.py --binding pyqt6
"""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "python"))

from qwinui3_gallery.main import main  # noqa: E402

if __name__ == "__main__":
    raise SystemExit(main())

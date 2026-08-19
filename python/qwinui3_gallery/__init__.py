"""QWinUI3 Gallery loaded from Python (PySide6 / PyQt6).

Ports src/gallery/main.cpp plus GraphicsBackend, GalleryLanguage, and
DemoTreeModel. Gallery QML is copied from src/gallery into a filesystem
QWinUI3.Gallery module at startup.
"""

from .main import main

__all__ = ["main"]

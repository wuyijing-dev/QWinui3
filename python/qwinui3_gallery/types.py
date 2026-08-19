"""Import Gallery Python types so @QmlElement / @QmlSingleton register on QWinUI3.Gallery."""

from __future__ import annotations

from qwinui3 import _qt

from . import demo_tree_model as _demo_tree_model  # noqa: F401
from . import gallery_language as _gallery_language  # noqa: F401
from . import graphics_backend as _graphics_backend  # noqa: F401


def register_types(_engine) -> None:
    """Ensure decorated Gallery types are imported before QML load."""
    _qt.init()
    _demo_tree_model  # noqa: B018
    _gallery_language  # noqa: B018
    _graphics_backend  # noqa: B018

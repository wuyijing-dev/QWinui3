"""Python port of QWinUI3::Compat::Rhi (QtCompatRhi.cpp)."""

from __future__ import annotations

import os
import sys

from qwinui3 import _qt

_DEFAULT = "opengl"


def normalize(name: str) -> str:
    key = name.strip().lower()
    if key in ("gl", "opengl", "open gl"):
        return "opengl"
    if key in ("vk", "vulkan"):
        return "vulkan"
    if key in ("d3d", "dx11", "d3d11", "direct3d11"):
        return "d3d11"
    if key in ("dx12", "d3d12", "direct3d12"):
        return "d3d12"
    if key == "metal":
        return "metal"
    return ""


def platform_backends() -> list[str]:
    out = ["opengl", "vulkan"]
    if sys.platform == "win32":
        out.extend(["d3d11", "d3d12"])
    elif sys.platform == "darwin":
        out.append("metal")
    return out


def coerce_available(backend: str, fallback: str = "") -> str:
    available = platform_backends()
    if backend and backend in available:
        return backend
    if fallback and fallback in available:
        return fallback
    if "opengl" in available:
        return "opengl"
    return available[0] if available else _DEFAULT


def graphics_api_for(backend: str):
    api = _qt.QtQuick.QSGRendererInterface.GraphicsApi
    return {
        "opengl": api.OpenGL,
        "vulkan": api.Vulkan,
        "d3d11": api.Direct3D11,
        "d3d12": api.Direct3D12,
        "metal": api.Metal,
    }.get(backend)


def apply(backend: str) -> str:
    chosen = coerce_available(backend)
    os.environ["QSG_RHI_BACKEND"] = chosen
    api = graphics_api_for(chosen)
    if api is not None:
        _qt.QtQuick.QQuickWindow.setGraphicsApi(api)
    if sys.platform == "win32":
        os.environ.pop("QT_QPA_DISABLE_REDIRECTION_SURFACE", None)

    fmt = _qt.QtGui.QSurfaceFormat.defaultFormat()
    fmt.setAlphaBufferSize(0)
    if chosen == "opengl":
        fmt.setRenderableType(_qt.QtGui.QSurfaceFormat.RenderableType.OpenGL)
    _qt.QtGui.QSurfaceFormat.setDefaultFormat(fmt)
    _qt.QtQuick.QQuickWindow.setDefaultAlphaBuffer(False)
    return chosen

"""Python port of QWinUI3::Compat::Rhi (QtCompatRhi.cpp)."""

from __future__ import annotations

import ctypes
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


def fallback_order() -> list[str]:
    if sys.platform == "win32":
        return ["d3d11", "opengl", "vulkan", "d3d12"]
    if sys.platform.startswith("linux") or sys.platform.startswith("freebsd"):
        return ["vulkan", "opengl"]
    if sys.platform == "darwin":
        return ["metal", "opengl", "vulkan"]
    return ["opengl", "vulkan"]


def _skip_probe() -> bool:
    return os.environ.get("QWINUI3_RHI_SKIP_PROBE", "").strip() not in (
        "",
        "0",
        "false",
        "False",
    )


def _is_headless_qpa() -> bool:
    qpa = os.environ.get("QT_QPA_PLATFORM", "").strip().lower()
    return qpa in ("offscreen", "minimal", "vnc", "null", "minimalegl")


def _probe_vulkan() -> bool:
    if _is_headless_qpa():
        return False
    if sys.platform == "win32":
        names = ["vulkan-1.dll"]
    elif sys.platform == "darwin":
        names = ["libvulkan.dylib", "vulkan"]
    else:
        names = ["libvulkan.so.1", "libvulkan.so", "vulkan"]

    lib = None
    for name in names:
        try:
            lib = ctypes.CDLL(name)
            break
        except OSError:
            continue
    if lib is None:
        return False
    return hasattr(lib, "vkGetInstanceProcAddr") or hasattr(lib, "vkCreateInstance")


def _probe_d3d11() -> bool:
    if sys.platform != "win32":
        return False
    try:
        lib = ctypes.WinDLL("d3d11.dll")
    except OSError:
        return False
    return hasattr(lib, "D3D11CreateDevice")


def _probe_d3d12() -> bool:
    if sys.platform != "win32":
        return False
    try:
        lib = ctypes.WinDLL("d3d12.dll")
    except OSError:
        return False
    return hasattr(lib, "D3D12CreateDevice")


def is_runtime_supported(backend: str) -> bool:
    key = normalize(backend)
    if not key or key not in platform_backends():
        return False
    if _skip_probe():
        return True
    if key == "opengl":
        return True
    if key == "vulkan":
        return _probe_vulkan()
    if key == "d3d11":
        return _probe_d3d11()
    if key == "d3d12":
        return _probe_d3d12()
    if key == "metal":
        return sys.platform == "darwin"
    return False


def coerce_available(backend: str, fallback: str = "") -> str:
    available = platform_backends()
    requested = normalize(backend)
    fb = normalize(fallback)

    def accept(b: str) -> bool:
        return bool(b) and b in available and is_runtime_supported(b)

    if accept(requested):
        return requested
    if accept(fb):
        return fb
    for b in fallback_order():
        if accept(b):
            return b
    for b in fallback_order():
        if b in available:
            return b
    if "opengl" in available:
        return "opengl"
    return available[0] if available else _DEFAULT


def default_backend() -> str:
    return coerce_available("", "")


def preferred_platform_backend() -> str:
    """Soft OS default with no runtime probe (Bootstrap cold path)."""
    available = platform_backends()
    for b in fallback_order():
        if b in available:
            return b
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


def apply_direct(backend: str) -> str:
    """Apply without coerce/probe — match C++ Compat::Rhi::applyDirect."""
    chosen = normalize(backend)
    if not chosen or chosen not in platform_backends():
        chosen = preferred_platform_backend()
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


def apply(backend: str) -> str:
    return apply_direct(coerce_available(backend))

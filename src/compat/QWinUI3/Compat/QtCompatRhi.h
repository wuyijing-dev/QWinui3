#pragma once

#include "QtCompatVersion.h"

#include <QString>
#include <QStringList>
#include <QSGRendererInterface>

namespace QWinUI3::Compat::Rhi {

/// Normalize user/CLI/env backend names to canonical keys:
/// opengl | vulkan | d3d11 | d3d12 | metal (empty if unknown).
QString normalize(const QString &name);

/// Map a canonical backend name to QSGRendererInterface::GraphicsApi.
/// Returns Unknown for unsupported / unavailable APIs (e.g. d3d12 on Qt < 6.6).
QSGRendererInterface::GraphicsApi graphicsApiFor(const QString &backend);

/// Backends available on this OS *and* this Qt build (compile-time / OS list).
QStringList platformBackends();

/// Preferred try-order for this OS (defaults first). Filtered by platformBackends later.
QStringList fallbackOrder();

/// Platform ship default after runtime probe (Windows d3d11, Linux vulkan, …).
QString defaultBackend();

/// Lightweight runtime check (Vulkan ICD, D3D11 DLL, offscreen QPA, …).
/// Set QWINUI3_RHI_SKIP_PROBE=1 to treat every platformBackends() entry as supported.
bool isRuntimeSupported(const QString &backend);

/// Apply QSG_RHI_BACKEND + QQuickWindow::setGraphicsApi (+ surface format tweaks).
/// Resolves via coerceAvailable (probe + fallback chain).
void apply(const QString &backend);

/// Prefer @p backend when supported; else @p fallback; else walk fallbackOrder().
QString coerceAvailable(const QString &backend, const QString &fallback = QString());

/// Map QSGRendererInterface::GraphicsApi → canonical backend key (empty if unknown).
QString backendForGraphicsApi(QSGRendererInterface::GraphicsApi api);

/// Human-readable label for a canonical backend key (OpenGL, Vulkan, …).
QString displayName(const QString &backend);

} // namespace QWinUI3::Compat::Rhi

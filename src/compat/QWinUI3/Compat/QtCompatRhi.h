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

/// Backends available on this OS *and* this Qt build.
QStringList platformBackends();

/// Apply QSG_RHI_BACKEND + QQuickWindow::setGraphicsApi (+ surface format tweaks).
/// Safe no-op for Unknown APIs.
void apply(const QString &backend);

/// If @p backend is unavailable, fall back to a safe default for the platform.
QString coerceAvailable(const QString &backend, const QString &fallback = QString());

/// Map QSGRendererInterface::GraphicsApi → canonical backend key (empty if unknown).
QString backendForGraphicsApi(QSGRendererInterface::GraphicsApi api);

/// Human-readable label for a canonical backend key (OpenGL, Vulkan, …).
QString displayName(const QString &backend);

} // namespace QWinUI3::Compat::Rhi

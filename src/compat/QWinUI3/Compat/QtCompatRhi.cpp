#include "QtCompatRhi.h"

#include <QQuickWindow>
#include <QSurfaceFormat>
#include <QtGui/qguiapplication.h>

namespace QWinUI3::Compat::Rhi {

QString normalize(const QString &name)
{
    const QString key = name.trimmed().toLower();
    if (key == QLatin1String("gl") || key == QLatin1String("opengl")
        || key == QLatin1String("open gl"))
        return QStringLiteral("opengl");
    if (key == QLatin1String("vk") || key == QLatin1String("vulkan"))
        return QStringLiteral("vulkan");
    if (key == QLatin1String("d3d") || key == QLatin1String("dx11")
        || key == QLatin1String("d3d11") || key == QLatin1String("direct3d11"))
        return QStringLiteral("d3d11");
    if (key == QLatin1String("dx12") || key == QLatin1String("d3d12")
        || key == QLatin1String("direct3d12"))
        return QStringLiteral("d3d12");
    if (key == QLatin1String("metal"))
        return QStringLiteral("metal");
    return {};
}

QSGRendererInterface::GraphicsApi graphicsApiFor(const QString &backend)
{
    if (backend == QLatin1String("opengl"))
        return QSGRendererInterface::OpenGL;
    if (backend == QLatin1String("vulkan"))
        return QSGRendererInterface::Vulkan;
    if (backend == QLatin1String("d3d11"))
        return QSGRendererInterface::Direct3D11;
    if (backend == QLatin1String("d3d12")) {
#if QWINUI3_HAVE_RHI_D3D12
        return QSGRendererInterface::Direct3D12;
#else
        return QSGRendererInterface::Unknown;
#endif
    }
    if (backend == QLatin1String("metal"))
        return QSGRendererInterface::Metal;
    return QSGRendererInterface::Unknown;
}

QStringList platformBackends()
{
    QStringList list;
    list << QStringLiteral("opengl") << QStringLiteral("vulkan");
#if defined(Q_OS_WIN)
    list << QStringLiteral("d3d11");
#  if QWINUI3_HAVE_RHI_D3D12
    list << QStringLiteral("d3d12");
#  endif
#elif defined(Q_OS_MACOS)
    list << QStringLiteral("metal");
#endif
    return list;
}

QString coerceAvailable(const QString &backend, const QString &fallback)
{
    const QStringList available = platformBackends();
    if (!backend.isEmpty() && available.contains(backend))
        return backend;
    if (!fallback.isEmpty() && available.contains(fallback))
        return fallback;
    if (available.contains(QStringLiteral("opengl")))
        return QStringLiteral("opengl");
    return available.isEmpty() ? QStringLiteral("opengl") : available.first();
}

QString backendForGraphicsApi(QSGRendererInterface::GraphicsApi api)
{
    switch (api) {
    case QSGRendererInterface::OpenGL:
        return QStringLiteral("opengl");
    case QSGRendererInterface::Vulkan:
        return QStringLiteral("vulkan");
    case QSGRendererInterface::Direct3D11:
        return QStringLiteral("d3d11");
    case QSGRendererInterface::Direct3D12:
        return QStringLiteral("d3d12");
    case QSGRendererInterface::Metal:
        return QStringLiteral("metal");
    default:
        return {};
    }
}

QString displayName(const QString &backend)
{
    if (backend == QLatin1String("opengl"))
        return QStringLiteral("OpenGL");
    if (backend == QLatin1String("vulkan"))
        return QStringLiteral("Vulkan");
    if (backend == QLatin1String("d3d11"))
        return QStringLiteral("D3D11");
    if (backend == QLatin1String("d3d12"))
        return QStringLiteral("D3D12");
    if (backend == QLatin1String("metal"))
        return QStringLiteral("Metal");
    return backend;
}

void apply(const QString &backend)
{
    const QString chosen = coerceAvailable(backend);
    qputenv("QSG_RHI_BACKEND", chosen.toUtf8());

    const auto api = graphicsApiFor(chosen);
    if (api != QSGRendererInterface::Unknown)
        QQuickWindow::setGraphicsApi(api);

#if defined(Q_OS_WIN)
    qunsetenv("QT_QPA_DISABLE_REDIRECTION_SURFACE");
#endif

    QSurfaceFormat format = QSurfaceFormat::defaultFormat();
    format.setAlphaBufferSize(0);
    if (chosen == QLatin1String("opengl"))
        format.setRenderableType(QSurfaceFormat::OpenGL);
    QSurfaceFormat::setDefaultFormat(format);
    QQuickWindow::setDefaultAlphaBuffer(false);
}

} // namespace QWinUI3::Compat::Rhi

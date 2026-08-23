#include "QtCompatRhi.h"

#include <QLibrary>
#include <QQuickWindow>
#include <QSurfaceFormat>
#include <QtGui/qguiapplication.h>

namespace QWinUI3::Compat::Rhi {
namespace {

bool skipProbe()
{
    return qEnvironmentVariableIntValue("QWINUI3_RHI_SKIP_PROBE") != 0;
}

bool isHeadlessQpa()
{
    const QByteArray qpa = qgetenv("QT_QPA_PLATFORM").trimmed().toLower();
    return qpa == "offscreen" || qpa == "minimal" || qpa == "vnc"
            || qpa == "null" || qpa == "minimalegl";
}

bool probeVulkan()
{
    if (isHeadlessQpa())
        return false;

#if defined(Q_OS_WIN)
    QLibrary lib(QStringLiteral("vulkan-1"));
#elif defined(Q_OS_MACOS)
    QLibrary lib(QStringLiteral("vulkan"));
#else
    QLibrary lib(QStringLiteral("vulkan"));
#endif
    if (!lib.load()) {
#if defined(Q_OS_LINUX) || defined(Q_OS_FREEBSD)
        lib.setFileName(QStringLiteral("libvulkan.so.1"));
        if (!lib.load())
            return false;
#else
        return false;
#endif
    }

    using PFN_vkGetInstanceProcAddr = void *(*)(void *, const char *);
    using PFN_vkCreateInstance = qint32 (*)(const void *, const void *, void **);
    using PFN_vkDestroyInstance = void (*)(void *, const void *);
    using PFN_vkEnumeratePhysicalDevices = qint32 (*)(void *, quint32 *, void *);

    auto getProc = reinterpret_cast<PFN_vkGetInstanceProcAddr>(
            lib.resolve("vkGetInstanceProcAddr"));
    if (!getProc)
        return false;

    // vkCreateInstance is exported; resolve via GetInstanceProcAddr(null, …).
    auto createInstance = reinterpret_cast<PFN_vkCreateInstance>(
            getProc(nullptr, "vkCreateInstance"));
    if (!createInstance)
        createInstance = reinterpret_cast<PFN_vkCreateInstance>(
                lib.resolve("vkCreateInstance"));
    if (!createInstance)
        return false;

    // Minimal VkApplicationInfo / VkInstanceCreateInfo (sType only + zeros).
    struct AppInfo {
        quint32 sType;
        const void *pNext;
        const char *pApplicationName;
        quint32 applicationVersion;
        const char *pEngineName;
        quint32 engineVersion;
        quint32 apiVersion;
    };
    AppInfo appInfo{};
    appInfo.sType = 0; // VK_STRUCTURE_TYPE_APPLICATION_INFO
    appInfo.pApplicationName = "QWinUI3";
    appInfo.apiVersion = (1u << 22); // VK_API_VERSION_1_0

    struct CreateInfo {
        quint32 sType;
        const void *pNext;
        quint32 flags;
        const AppInfo *pApplicationInfo;
        quint32 enabledLayerCount;
        const char *const *ppEnabledLayerNames;
        quint32 enabledExtensionCount;
        const char *const *ppEnabledExtensionNames;
    };
    CreateInfo createInfo{};
    createInfo.sType = 1; // VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO
    createInfo.pApplicationInfo = &appInfo;

    void *instance = nullptr;
    if (createInstance(&createInfo, nullptr, &instance) != 0 || !instance)
        return false;

    auto destroyInstance = reinterpret_cast<PFN_vkDestroyInstance>(
            getProc(instance, "vkDestroyInstance"));
    auto enumerate = reinterpret_cast<PFN_vkEnumeratePhysicalDevices>(
            getProc(instance, "vkEnumeratePhysicalDevices"));

    bool ok = false;
    if (enumerate) {
        quint32 count = 0;
        if (enumerate(instance, &count, nullptr) == 0 && count > 0)
            ok = true;
    }

    if (destroyInstance)
        destroyInstance(instance, nullptr);
    return ok;
}

bool probeD3D11()
{
#if !defined(Q_OS_WIN)
    return false;
#else
    QLibrary lib(QStringLiteral("d3d11"));
    if (!lib.load())
        return false;
    // Soft probe: export present. Full device create needs d3d11.h + link.
    return lib.resolve("D3D11CreateDevice") != nullptr;
#endif
}

bool probeD3D12()
{
#if !defined(Q_OS_WIN) || !QWINUI3_HAVE_RHI_D3D12
    return false;
#else
    QLibrary lib(QStringLiteral("d3d12"));
    return lib.load() && lib.resolve("D3D12CreateDevice") != nullptr;
#endif
}

bool probeOpenGL()
{
    // Desktop Qt kits ship OpenGL; headless / offscreen still usually works.
    return true;
}

bool probeMetal()
{
#if defined(Q_OS_MACOS)
    return true;
#else
    return false;
#endif
}

} // namespace

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

QStringList fallbackOrder()
{
#if defined(Q_OS_WIN)
    QStringList order;
    order << QStringLiteral("d3d11") << QStringLiteral("opengl")
          << QStringLiteral("vulkan");
#  if QWINUI3_HAVE_RHI_D3D12
    order << QStringLiteral("d3d12");
#  endif
    return order;
#elif defined(Q_OS_LINUX) || defined(Q_OS_FREEBSD)
    return {QStringLiteral("vulkan"), QStringLiteral("opengl")};
#elif defined(Q_OS_MACOS)
    return {QStringLiteral("metal"), QStringLiteral("opengl"),
            QStringLiteral("vulkan")};
#else
    return {QStringLiteral("opengl"), QStringLiteral("vulkan")};
#endif
}

bool isRuntimeSupported(const QString &backend)
{
    const QString key = normalize(backend);
    if (key.isEmpty() || !platformBackends().contains(key))
        return false;
    if (skipProbe())
        return true;

    if (key == QLatin1String("opengl"))
        return probeOpenGL();
    if (key == QLatin1String("vulkan"))
        return probeVulkan();
    if (key == QLatin1String("d3d11"))
        return probeD3D11();
    if (key == QLatin1String("d3d12"))
        return probeD3D12();
    if (key == QLatin1String("metal"))
        return probeMetal();
    return false;
}

QString coerceAvailable(const QString &backend, const QString &fallback)
{
    const QStringList available = platformBackends();
    const QString requested = normalize(backend);
    const QString fb = normalize(fallback);

    auto accept = [&](const QString &b) -> bool {
        return !b.isEmpty() && available.contains(b) && isRuntimeSupported(b);
    };

    if (accept(requested))
        return requested;
    if (accept(fb))
        return fb;

    for (const QString &b : fallbackOrder()) {
        if (accept(b))
            return b;
    }

    // Probe failed for everything — still pick a compile-time-safe id so Qt can try.
    for (const QString &b : fallbackOrder()) {
        if (available.contains(b))
            return b;
    }
    if (available.contains(QStringLiteral("opengl")))
        return QStringLiteral("opengl");
    return available.isEmpty() ? QStringLiteral("opengl") : available.first();
}

QString defaultBackend()
{
    return coerceAvailable(QString(), QString());
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

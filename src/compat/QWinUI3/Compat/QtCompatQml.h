#pragma once

#include "QtCompatVersion.h"

#include <QString>

namespace QWinUI3::Compat::Qml {

/// QML module "REQUIRES" floor string for qt_standard_project_setup /
/// documentation. Always at least "6.5"; raised when building against newer Qt
/// so tooling sees a coherent floor without blocking older kits at configure.
inline QString requiresVersionString()
{
    // Advertise the minimum we support, not the build kit's exact version.
    return QStringLiteral("6.5");
}

/// Human-readable support range for logs / about screens.
inline QString supportRangeString()
{
    return QStringLiteral("Qt 6.5+ (recommended 6.8 LTS; forward 6.10+)");
}

} // namespace QWinUI3::Compat::Qml

#pragma once

// QWinUI3 Qt version / capability macros.
//
// Floor: Qt 6.5. Recommended: Qt 6.8 LTS. Forward: Qt 6.10+.
// Prefer these macros (or Compat helpers) over scattering #if QT_VERSION in app code.
//
// Capability table (compile-time / CMake):
//   Core Quick / Controls2 / LabsQmlModels | 6.5 | 6.8 | 6.10+
//   RHI Direct3D12 (QWINUI3_HAVE_RHI_D3D12)| 6.6+|  yes |  yes
//   QtQuick.Effects (QWINUI3_HAVE_QUICK_EFFECTS) | probe | yes | yes

#include <QtGlobal>

#define QWINUI3_QT_VERSION_MAJOR QT_VERSION_MAJOR
#define QWINUI3_QT_VERSION_MINOR QT_VERSION_MINOR
#define QWINUI3_QT_VERSION_PATCH QT_VERSION_PATCH

#define QWINUI3_QT_AT_LEAST(major, minor, patch) \
    (QT_VERSION >= QT_VERSION_CHECK(major, minor, patch))

// Minimum we configure against (CMake find_package floor).
#define QWINUI3_QT_MIN_MAJOR 6
#define QWINUI3_QT_MIN_MINOR 5
#define QWINUI3_QT_MIN_PATCH 0

#if !QWINUI3_QT_AT_LEAST(QWINUI3_QT_MIN_MAJOR, QWINUI3_QT_MIN_MINOR, QWINUI3_QT_MIN_PATCH)
#  error "QWinUI3 requires Qt 6.5 or later"
#endif

// Direct3D 12 RHI backend landed in Qt 6.6.
#ifndef QWINUI3_HAVE_RHI_D3D12
#  if QWINUI3_QT_AT_LEAST(6, 6, 0)
#    define QWINUI3_HAVE_RHI_D3D12 1
#  else
#    define QWINUI3_HAVE_RHI_D3D12 0
#  endif
#endif

// QWINUI3_HAVE_QUICK_EFFECTS is injected by CMake when Qt6::QuickEffects is found.
#ifndef QWINUI3_HAVE_QUICK_EFFECTS
#  define QWINUI3_HAVE_QUICK_EFFECTS 0
#endif

namespace QWinUI3::Compat {

inline constexpr int qtVersionMajor() noexcept { return QT_VERSION_MAJOR; }
inline constexpr int qtVersionMinor() noexcept { return QT_VERSION_MINOR; }
inline constexpr int qtVersionPatch() noexcept { return QT_VERSION_PATCH; }

inline constexpr bool hasRhiD3D12() noexcept
{
    return QWINUI3_HAVE_RHI_D3D12 != 0;
}

inline constexpr bool hasQuickEffects() noexcept
{
    return QWINUI3_HAVE_QUICK_EFFECTS != 0;
}

} // namespace QWinUI3::Compat

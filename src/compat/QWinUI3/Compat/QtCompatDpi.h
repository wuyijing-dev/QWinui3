#pragma once

// High-DPI scale-factor rounding — same kit behavior on Qt 6.5 … 6.11+.
//
// Public enum (all supported Qt 6.5+ docs): Round, Ceil, Floor, RoundPreferFloor, PassThrough.
// RoundPreferCeil was never a public enumerator in Qt 6.8 / 6.10 / 6.11 docs — string alias maps to Ceil only.
// Do not reference RoundPreferCeil as an enumerator.

#include <QCoreApplication>
#include <QGuiApplication>
#include <QString>

namespace QWinUI3::Compat::Dpi {

/// Kit default on every supported Qt — fractional DPR / PassThrough.
inline constexpr Qt::HighDpiScaleFactorRoundingPolicy kitPolicy() noexcept
{
    return Qt::HighDpiScaleFactorRoundingPolicy::PassThrough;
}

/// Call before QGuiApplication (no-op if an app instance already exists).
inline void applyKitPolicyEarly()
{
    if (QCoreApplication::instance())
        return;
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(kitPolicy());
}

inline QString policyName(Qt::HighDpiScaleFactorRoundingPolicy policy)
{
    using P = Qt::HighDpiScaleFactorRoundingPolicy;
    switch (policy) {
    case P::PassThrough:
        return QStringLiteral("PassThrough");
    case P::Round:
        return QStringLiteral("Round");
    case P::Ceil:
        return QStringLiteral("Ceil");
    case P::Floor:
        return QStringLiteral("Floor");
    case P::RoundPreferFloor:
        return QStringLiteral("RoundPreferFloor");
    }
    // Unknown / removed enumerator values (e.g. historic RoundPreferCeil numeric):
    // expose as Ceil so UI/diagnostics match the “prefer round-up” alias below.
    return QStringLiteral("Ceil");
}

/// Resolve a policy name. RoundPreferCeil → Ceil (compat alias). Unknown → kitPolicy().
inline Qt::HighDpiScaleFactorRoundingPolicy policyFromName(const QString &name, bool *ok = nullptr)
{
    using P = Qt::HighDpiScaleFactorRoundingPolicy;
    const QString n = name.trimmed();
    auto accept = [&](P p) {
        if (ok)
            *ok = true;
        return p;
    };
    if (n.compare(QLatin1String("PassThrough"), Qt::CaseInsensitive) == 0)
        return accept(P::PassThrough);
    if (n.compare(QLatin1String("Round"), Qt::CaseInsensitive) == 0)
        return accept(P::Round);
    if (n.compare(QLatin1String("Ceil"), Qt::CaseInsensitive) == 0)
        return accept(P::Ceil);
    if (n.compare(QLatin1String("Floor"), Qt::CaseInsensitive) == 0)
        return accept(P::Floor);
    if (n.compare(QLatin1String("RoundPreferFloor"), Qt::CaseInsensitive) == 0)
        return accept(P::RoundPreferFloor);
    // RoundPreferCeil was never in 6.8/6.10/6.11 public docs; keep as Ceil string alias.
    if (n.compare(QLatin1String("RoundPreferCeil"), Qt::CaseInsensitive) == 0)
        return accept(P::Ceil);
    if (ok)
        *ok = false;
    return kitPolicy();
}

} // namespace QWinUI3::Compat::Dpi

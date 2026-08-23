#include <QtTest/qtest.h>
#include <QtCore/QCoreApplication>

#include "QtCompatDpi.h"

using QWinUI3::Compat::Dpi::kitPolicy;
using QWinUI3::Compat::Dpi::policyFromName;
using QWinUI3::Compat::Dpi::policyName;
using Policy = Qt::HighDpiScaleFactorRoundingPolicy;

class TestQtCompatDpi : public QObject {
    Q_OBJECT

private slots:
    void unsetResolvesToKitPolicy()
    {
        QCOMPARE(policyName(Policy::Unset), policyName(kitPolicy()));
        QCOMPARE(policyName(Policy::Unset), QStringLiteral("PassThrough"));
    }

    void knownPoliciesRoundTrip()
    {
        const QList<Policy> known = {
            Policy::PassThrough, Policy::Round, Policy::Ceil,
            Policy::Floor, Policy::RoundPreferFloor,
        };
        for (const Policy p : known) {
            bool ok = false;
            const auto back = policyFromName(policyName(p), &ok);
            QVERIFY2(ok, qPrintable(QStringLiteral("name round-trip ok: %1")
                                       .arg(policyName(p))));
            QCOMPARE(back, p);
        }
    }

    void roundPreferCeilAliasMapsToCeil()
    {
        bool ok = false;
        const auto p = policyFromName(QStringLiteral("RoundPreferCeil"), &ok);
        QVERIFY(ok);
        QCOMPARE(p, Policy::Ceil);
    }

    void unknownNameFallsBackToKitPolicy()
    {
        bool ok = true;
        const auto p = policyFromName(QStringLiteral("NotAPolicy"), &ok);
        QVERIFY(!ok);
        QCOMPARE(p, kitPolicy());
    }
};

QTEST_GUILESS_MAIN(TestQtCompatDpi)
#include "test_qtcompatdpi.moc"

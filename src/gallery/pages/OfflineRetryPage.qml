import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — OfflineBanner + OperationRetry (2.78).

CatalogPage {
    id: page
    title: qsTr("Offline & retry")
    subtitle: qsTr("OfflineBanner (WindowHelper.isOnline) · OperationRetry backoff helpers.")

    property string opLog: qsTr("Idle")

    OperationRetry {
        id: op
        maxAttempts: 4
        baseDelayMs: 300
        onAttempt: function (n) {
            page.opLog = qsTr("Attempt %1").arg(n)
            // Demo: fail until attempt 3
            if (n < 3)
                Qt.callLater(function () { op.fail(qsTr("simulated")) })
            else
                Qt.callLater(function () { op.succeed() })
        }
        onRetryScheduled: function (n, delayMs) {
            page.opLog = qsTr("Retry %1 in %2 ms").arg(n).arg(delayMs)
        }
        onSucceeded: page.opLog = qsTr("Succeeded after %1 attempts").arg(op.attemptCount)
        onFailed: function (err) { page.opLog = qsTr("Failed: %1").arg(err) }
    }

    ControlExample {
        headerText: qsTr("OfflineBanner")
        qmlSource: "OfflineBanner { }\n// WindowHelper.refreshOnlineStatus()"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                text: qsTr("isOnline=%1").arg(WindowHelper.isOnline ? qsTr("yes") : qsTr("no"))
                color: Theme.textPrimary
            }
            OfflineBanner {
                Layout.fillWidth: true
                forceShow: forceOffline.checked
            }
            CheckBox {
                id: forceOffline
                text: qsTr("Force show banner (demo)")
            }
            Button {
                text: qsTr("Refresh online status")
                onClicked: WindowHelper.refreshOnlineStatus()
            }
        }
    }

    ControlExample {
        headerText: qsTr("OperationRetry")
        qmlSource: "OperationRetry { maxAttempts: 4; onAttempt: … }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: page.opLog
                color: Theme.textSecondary
            }
            RowLayout {
                Button {
                    text: qsTr("Start")
                    onClicked: op.start()
                }
                Button {
                    text: qsTr("Reset")
                    onClicked: {
                        op.reset()
                        page.opLog = qsTr("Idle")
                    }
                }
            }
        }
    }
}

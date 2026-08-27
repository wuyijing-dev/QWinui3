import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ToastHost.
//
// Queues toasts; info()/successToast()/errorToast() helpers, newestOnTop, clear().
// Recipe: docs/feedback.md · API: docs/components/ToastHost.md

CatalogPage {
    title: qsTr("ToastHost")
    subtitle: qsTr("Pending queue when maxVisible is full. Recipe: docs/feedback.md.")

    overlay: ToastHost {
        id: host
        width: 360
        placement: ToastHost.BottomRight
        maxVisible: 3
    }

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "// ToastHost — transient ack\n// InfoBar — stays on page\n// docs/feedback.md"
        ColumnLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use ToastHost for non-blocking Saved/Done. Do not toast irreversible confirms (ContentDialog) or form field errors (InfoBar / forms). OS mirror: NotificationBridge.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Placement + queue")
        qmlSource: "ToastHost {\n    placement: ToastHost.TopLeft\n    maxVisible: 3\n}\nhost.setPlacementName(\"bottom-right\")"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Label { text: qsTr("Placement"); color: Theme.textSecondary }
                ComboBox {
                    id: placeBox
                    Layout.preferredWidth: 180
                    model: ["bottom-right", "bottom-center", "bottom-left",
                            "top-right", "top-center", "top-left"]
                    currentIndex: 0
                    onActivated: host.setPlacementName(currentText)
                }
                Switch {
                    text: qsTr("Newest on top")
                    checked: host.newestOnTop
                    onToggled: host.newestOnTop = checked
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("Visible: %1 · Pending: %2 · Total: %3 (extra show() wait until a toast closes)")
                    .arg(host.count).arg(host.pendingCount).arg(host.totalCount)
            }
        }
    }

    ControlExample {
        headerText: qsTr("Priority + dedupe")
        qmlSource: "host.show(msg, sev, title, action, \"sync-id\", priority)\n// same dedupeId replaces in-flight toast"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Fill maxVisible, then enqueue with priority — higher values drain first from pending. Re-show with the same dedupeId updates the visible toast instead of stacking duplicates.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Priority burst")
                    onClicked: {
                        for (var i = 0; i < 4; ++i)
                            host.show(qsTr("Low %1").arg(i), host.severityInformational,
                                      qsTr("Queue"), "", "", 0)
                        host.show(qsTr("High priority"), host.severityWarning,
                                  qsTr("Queue"), "", "", 10)
                    }
                }
                Button {
                    text: qsTr("Dedupe sync")
                    onClicked: {
                        host.show(qsTr("Syncing…"), host.severityInformational,
                                  qsTr("Upload"), "", "upload", 0)
                        host.show(qsTr("Sync complete"), host.severitySuccess,
                                  qsTr("Upload"), "", "upload", 0)
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Enqueue")
        qmlSource: "ToastHost { id: host }\nhost.show(\"Saved\", host.success, \"Done\")"
        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            AccentButton {
                text: qsTr("Info")
                onClicked: host.info(qsTr("Something happened."))
            }
            Button {
                text: qsTr("Success")
                onClicked: host.successToast(qsTr("Your changes were saved."))
            }
            Button {
                text: qsTr("Warning")
                onClicked: host.warningToast(qsTr("Check your connection."))
            }
            Button {
                text: qsTr("Error + action")
                onClicked: host.errorToast(qsTr("Unable to complete the request."), qsTr("Error"), qsTr("Retry"))
            }
            Button {
                text: qsTr("Burst ×5")
                onClicked: {
                    for (var i = 1; i <= 5; ++i)
                        host.info(qsTr("Queued item %1").arg(i), qsTr("Queue"))
                }
            }
            Button {
                text: qsTr("Clear (%1)").arg(host.totalCount)
                onClicked: host.clear()
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ToastHost.
//
// Queues toasts; info()/successToast()/errorToast() helpers, newestOnTop, clear(). API: docs/components/ToastHost.md

CatalogPage {
    title: qsTr("ToastHost")
    subtitle: qsTr("Window-overlay placement, maxVisible stack, and pending queue when full.")

    overlay: ToastHost {
        id: host
        width: 360
        placement: ToastHost.BottomRight
        maxVisible: 3
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

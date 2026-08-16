import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Toast.
//
// Transient notification with Fluent severity icons, HyperlinkButton action, and progress.
// Prefer ToastHost for placement; this page demos severity helpers via a host.

CatalogPage {
    title: qsTr("Toast")
    subtitle: qsTr("Queued toasts on the window overlay; pick corner placement (BottomRight default).")

    overlay: ToastHost {
        id: host
        width: 360
        placement: ToastHost.BottomRight
        maxVisible: 3
    }

    ControlExample {
        headerText: qsTr("Placement")
        qmlSource: "ToastHost {\n    placement: ToastHost.BottomRight\n    maxVisible: 3\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Label { text: qsTr("Corner"); color: Theme.textSecondary }
                ComboBox {
                    id: placeBox
                    Layout.preferredWidth: 180
                    model: [
                        qsTr("Bottom right"),
                        qsTr("Bottom center"),
                        qsTr("Bottom left"),
                        qsTr("Top right"),
                        qsTr("Top center"),
                        qsTr("Top left")
                    ]
                    currentIndex: 0
                    onActivated: {
                        switch (currentIndex) {
                        case 1: host.placement = ToastHost.BottomCenter; break
                        case 2: host.placement = ToastHost.BottomLeft; break
                        case 3: host.placement = ToastHost.TopRight; break
                        case 4: host.placement = ToastHost.TopCenter; break
                        case 5: host.placement = ToastHost.TopLeft; break
                        default: host.placement = ToastHost.BottomRight; break
                        }
                    }
                }
                Label {
                    text: qsTr("Visible %1 · Pending %2").arg(host.count).arg(host.pendingCount)
                    color: Theme.textSecondary
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Show toast")
        qmlSource: "host.info(\"…\")\nhost.success(\"…\")"
        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            AccentButton {
                text: qsTr("Info")
                onClicked: host.info(qsTr("Something happened."), qsTr("Information"))
            }
            Button {
                text: qsTr("Success")
                onClicked: host.success(qsTr("Your changes were saved."), qsTr("Success"))
            }
            Button {
                text: qsTr("Warning")
                onClicked: host.warning(qsTr("Check your connection."), qsTr("Warning"))
            }
            Button {
                text: qsTr("Error")
                onClicked: host.error(qsTr("Unable to complete the request."), qsTr("Error"), qsTr("Retry"))
            }
            Button {
                text: qsTr("With action")
                onClicked: host.success(qsTr("Content copied — hover to pause."), qsTr("Clipboard"), qsTr("View"))
            }
            Button {
                text: qsTr("Burst queue (5)")
                onClicked: {
                    host.info(qsTr("First in queue"), qsTr("1 / 5"))
                    host.success(qsTr("Second"), qsTr("2 / 5"))
                    host.warning(qsTr("Third"), qsTr("3 / 5"))
                    host.error(qsTr("Fourth"), qsTr("4 / 5"))
                    host.info(qsTr("Fifth waits until a slot frees"), qsTr("5 / 5"))
                }
            }
            Button {
                text: qsTr("Clear")
                onClicked: host.clear()
            }
        }
    }
}

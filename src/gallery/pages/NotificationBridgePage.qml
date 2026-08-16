import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — NotificationBridge.
//
// In-app ToastHost + OS notify (Windows balloon / Linux portal).

CatalogPage {
    title: qsTr("NotificationBridge")
    subtitle: qsTr("Mirror ToastHost to Windows tray balloons or Linux portal / notify-send.")

    overlay: Item {
        anchors.fill: parent
        ToastHost {
            id: toasts
            placement: ToastHost.BottomRight
        }
        NotificationBridge {
            id: bridge
            toastHost: toasts
            mirrorToSystem: mirrorToggle.checked
            toastInApp: true
            appName: qsTr("QWinUI3 Gallery")
        }
    }

    ControlExample {
        headerText: qsTr("In-app + system")
        qmlSource: "NotificationBridge {\n    toastHost: toasts\n    mirrorToSystem: true\n}\nbridge.info(qsTr(\"Saved\"), qsTr(\"Document\"))"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Switch {
                id: mirrorToggle
                text: qsTr("Mirror to system notification")
                checked: true
            }

            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Info")
                    onClicked: bridge.info(qsTr("Build finished"), qsTr("CI"))
                }
                Button {
                    text: qsTr("Success")
                    onClicked: bridge.success(qsTr("All checks passed"), qsTr("Ready"))
                }
                Button {
                    text: qsTr("Warning")
                    onClicked: bridge.warning(qsTr("Disk space low"), qsTr("Storage"))
                }
                Button {
                    text: qsTr("Error")
                    onClicked: bridge.error(qsTr("Deploy failed"), qsTr("Pipeline"))
                }
                Button {
                    text: qsTr("System only")
                    onClicked: bridge.notifySystem(qsTr("QWinUI3"), qsTr("Direct OS notify"))
                }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("Windows: tray balloon via Shell_NotifyIcon. Linux: org.freedesktop.Notifications portal, then notify-send.")
            }
        }
    }
}

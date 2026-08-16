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
    subtitle: qsTr("Queues toasts; info()/successToast()/errorToast() helpers, newestOnTop, clear().")

    overlay: ToastHost {
        id: host
        width: 360
        placement: ToastHost.BottomCenter
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
                text: qsTr("Clear (%1)").arg(host.count)
                onClicked: host.clear()
            }
        }
    }
}

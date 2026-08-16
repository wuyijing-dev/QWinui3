import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Toast.
//
// Transient notification with Fluent severity icons, HyperlinkButton action, and progress.
// Prefer ToastHost for placement; this page demos severity helpers via a single-slot host.

CatalogPage {
    title: qsTr("Toast")
    subtitle: qsTr("Transient notification with Fluent severity icons, HyperlinkButton action, and progress.")

    overlay: ToastHost {
        id: host
        width: 360
        placement: ToastHost.BottomCenter
        maxVisible: 1
    }

    ControlExample {
        headerText: qsTr("Show toast")
        qmlSource: "ToastHost {\n    placement: ToastHost.BottomCenter\n}\nhost.success(\"Done\")"
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
        }
    }
}

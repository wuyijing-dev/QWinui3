import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Confirm action.
//
// A modal dialog for confirming actions or collecting input. API: docs/components/Dialog.md

CatalogPage {
    title: qsTr("Dialog")
    subtitle: qsTr("A modal dialog for confirming actions or collecting input.")

    overlay: [
        ContentDialog {
            id: contentDialog
            parent: Overlay.overlay
            anchors.centerIn: Overlay.overlay
            title: qsTr("Confirm action")
            primaryButtonText: qsTr("Confirm")
            closeButtonText: qsTr("Cancel")
            Label {
                text: qsTr("This ContentDialog uses WinUI-style primary/close buttons.")
                wrapMode: Text.Wrap
                color: Theme.textPrimary
            }
        },
        Dialog {
            id: plainDialog
            parent: Overlay.overlay
            anchors.centerIn: Overlay.overlay
            title: qsTr("Dialog")
            standardButtons: Dialog.Ok | Dialog.Cancel
            modal: true
            Label {
                text: qsTr("Standard Dialog with DialogButtonBox.")
                color: Theme.textPrimary
            }
        }
    ]

    ControlExample {
        headerText: qsTr("ContentDialog")
        qmlSource: "ContentDialog {\n    title: \"Confirm action\"\n    primaryButtonText: \"Confirm\"\n    closeButtonText: \"Cancel\"\n}"

        Button {
            text: qsTr("Show ContentDialog")
            highlighted: true
            onClicked: contentDialog.open()
        }
    }

    ControlExample {
        headerText: qsTr("Dialog")
        bordered: false
        qmlSource: "Dialog {\n    title: \"Dialog\"\n    standardButtons: Dialog.Ok | Dialog.Cancel\n    modal: true\n}"

        Button {
            text: qsTr("Show Dialog")
            onClicked: plainDialog.open()
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Confirm action.
//
// A modal dialog for confirming actions or collecting input. API: docs/components/Dialog.md

Page {
    id: page
    padding: 0
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
    }

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

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection

            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("Dialog")
                subtitle: qsTr("A modal dialog for confirming actions or collecting input.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("ContentDialog")
                qmlSource: "ContentDialog {\n    title: \"Confirm action\"\n    primaryButtonText: \"Confirm\"\n    closeButtonText: \"Cancel\"\n}"

                Button {
                    text: qsTr("Show ContentDialog")
                    highlighted: true
                    onClicked: contentDialog.open()
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.bottomMargin: Theme.spacingSection
                headerText: qsTr("Dialog")
                bordered: false
                qmlSource: "Dialog {\n    title: \"Dialog\"\n    standardButtons: Dialog.Ok | Dialog.Cancel\n    modal: true\n}"

                Button {
                    text: qsTr("Show Dialog")
                    onClicked: plainDialog.open()
                }
            }
        }
    }
}

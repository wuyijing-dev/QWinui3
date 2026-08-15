import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

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
        defaultButton: "primary"
        Label {
            text: qsTr("This ContentDialog uses WinUI-style primary/close buttons. Enter activates the default button.")
            wrapMode: Text.Wrap
            color: Theme.textPrimary
        }
    }

    ContentDialog {
        id: threeBtnDialog
        parent: Overlay.overlay
        anchors.centerIn: Overlay.overlay
        title: qsTr("Save changes?")
        primaryButtonText: qsTr("Save")
        secondaryButtonText: qsTr("Don't save")
        closeButtonText: qsTr("Cancel")
        defaultButton: defaultCombo.currentText
        Label {
            text: qsTr("Your document has unsaved changes. Choose which button is the default.")
            wrapMode: Text.Wrap
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
                title: qsTr("ContentDialog")
                subtitle: qsTr("Modal dialog with isOpen, enter/exit motion, and primary / secondary / close actions.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Primary and close")
                qmlSource: "ContentDialog {\n    isOpen: true\n    defaultButton: \"primary\"\n}"

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
                headerText: qsTr("Queue: show / cancel / replaceCurrent")
                qmlSource: "ContentDialogQueue.show(a)\nContentDialogQueue.replaceCurrent(b)"

                RowLayout {
                    spacing: Theme.spacing
                    Button {
                        text: qsTr("Enqueue both")
                        onClicked: {
                            contentDialog.show()
                            threeBtnDialog.show()
                        }
                    }
                    Button {
                        text: qsTr("Cancel second")
                        onClicked: ContentDialogQueue.cancel(threeBtnDialog)
                    }
                    Button {
                        text: qsTr("Replace with three-btn")
                        onClicked: ContentDialogQueue.replaceCurrent(threeBtnDialog)
                    }
                    Button {
                        text: qsTr("Clear queue")
                        onClicked: ContentDialogQueue.clearQueue()
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.bottomMargin: Theme.spacingSection
                headerText: qsTr("Three buttons + DefaultButton")
                qmlSource: "ContentDialog {\n    defaultButton: \"secondary\"\n    …\n}"

                ColumnLayout {
                    spacing: Theme.spacing
                    RowLayout {
                        Label { text: qsTr("Default"); color: Theme.textSecondary }
                        ComboBox {
                            id: defaultCombo
                            model: ["primary", "secondary", "close", "none"]
                            currentIndex: 0
                            Layout.preferredWidth: 140
                        }
                    }
                    Button {
                        text: qsTr("Show three-button dialog")
                        onClicked: threeBtnDialog.isOpen = true
                    }
                }
            }
        }
    }
}

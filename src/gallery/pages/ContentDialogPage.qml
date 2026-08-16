import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Confirm action.
//
// Modal dialog with isOpen, enter/exit motion, and primary / secondary / close actions. API: docs/components/ContentDialog.md

CatalogPage {
    title: qsTr("ContentDialog")
    subtitle: qsTr("Enter animation on by default (WinUI often needs DefaultContentDialogStyle). Result logging, custom buttons, FullSizeDesired.")

    overlay: [
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
        },
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
        },
        ContentDialog {
            id: fullDialog
            parent: Overlay.overlay
            anchors.centerIn: Overlay.overlay
            title: qsTr("Full-size dialog")
            primaryButtonText: qsTr("Done")
            closeButtonText: qsTr("Close")
            fullSizeDesired: true
            defaultButton: "primary"
            Label {
                text: qsTr("fullSizeDesired expands the dialog toward the overlay (WinUI FullSizeDesired).")
                wrapMode: Text.Wrap
                color: Theme.textPrimary
            }
        },
        ContentDialog {
            id: resultDialog
            parent: Overlay.overlay
            anchors.centerIn: Overlay.overlay
            title: qsTr("ContentDialogResult")
            primaryButtonText: qsTr("Primary")
            secondaryButtonText: qsTr("Secondary")
            closeButtonText: qsTr("Close")
            defaultButton: "primary"
            onResultReady: function (r) { resultLog.text = qsTr("Result: %1").arg(r) }
            Label {
                text: qsTr("Closing sets result (none/primary/secondary/close) and emits resultReady.")
                wrapMode: Text.Wrap
                color: Theme.textPrimary
            }
        },
        ContentDialog {
            id: customBtnDialog
            parent: Overlay.overlay
            anchors.centerIn: Overlay.overlay
            title: qsTr("Custom primary button")
            closeButtonText: qsTr("Cancel")
            primaryButton: Button {
                text: qsTr("Save with progress")
                highlighted: true
                onClicked: {
                    customBtnDialog.dialogResult = "primary"
                    customBtnDialog.resultReady("primary")
                    customBtnDialog.accept()
                }
            }
            Label {
                text: qsTr("primaryButton slot replaces the default Primary text button.")
                wrapMode: Text.Wrap
                color: Theme.textPrimary
            }
        },
        ContentDialog {
            id: closingDialog
            parent: Overlay.overlay
            anchors.centerIn: Overlay.overlay
            title: qsTr("Closing cancel")
            primaryButtonText: qsTr("Try close")
            closeButtonText: qsTr("Cancel")
            defaultButton: "primary"
            onClosing: function (args) {
                if (blockClose.checked) {
                    args.cancel = true
                    closingLog.text = qsTr("Closing canceled (args.cancel = true)")
                } else {
                    closingLog.text = qsTr("Closed with result: %1").arg(args.result)
                }
            }
            Label {
                text: qsTr("WinUI Closing: set args.cancel = true to keep the dialog open.")
                wrapMode: Text.Wrap
                color: Theme.textPrimary
            }
        }
    ]

    ControlExample {
        headerText: qsTr("Primary and close")
        qmlSource: "ContentDialog {\n    isOpen: true\n    defaultButton: \"primary\"\n}"

            Button {
                text: qsTr("Show ContentDialog")
                highlighted: true
                onClicked: contentDialog.show()
            }
    }

    ControlExample {
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
                onClicked: threeBtnDialog.show()
            }
            Button {
                text: qsTr("Show fullSizeDesired")
                onClicked: fullDialog.show()
            }
            Button {
                text: qsTr("Show result dialog")
                onClicked: resultDialog.show()
            }
            Button {
                text: qsTr("Show custom primary button")
                onClicked: customBtnDialog.show()
            }
            CheckBox {
                id: blockClose
                text: qsTr("Block close via Closing")
            }
            Button {
                text: qsTr("Show Closing dialog")
                onClicked: closingDialog.show()
            }
            Label {
                id: closingLog
                text: qsTr("Closing: (none yet)")
                color: Theme.textSecondary
            }
            Label {
                id: resultLog
                text: qsTr("Result: (none yet)")
                color: Theme.textSecondary
            }
        }
    }
}

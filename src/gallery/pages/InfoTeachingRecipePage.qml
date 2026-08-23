import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — InfoBar + TeachingTip scenario recipe (form save / tip coach mark).
//
// Feedback patterns: docs/feedback.md (1.34).

CatalogPage {
    id: page
    title: qsTr("InfoBar + TeachingTip recipe")
    subtitle: qsTr("Form InfoBars + coach tip; focus returns to field. Recipe: docs/feedback.md (1.34).")

    property bool tipShown: false

    overlay: InfoBarHost {
        id: bars
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 12
        width: Math.min(520, parent.width - 24)
        maxVisible: 3

        InfoBar {
            id: errorBar
            severity: errorBar.error
            title: qsTr("Validation")
            message: qsTr("Name is required.")
            isOpen: false
        }
        InfoBar {
            id: successBar
            severity: successBar.success
            title: qsTr("Saved")
            message: qsTr("Settings saved.")
            isOpen: false
        }
    }

    ControlExample {
        headerText: qsTr("When to use (1.34)")
        qmlSource: "// InfoBar — page status\n// ToastHost — transient ack\n// TeachingTip — coach mark\n// docs/feedback.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use InfoBar for validation/save on the page. TeachingTip for first-run coaching (closes → focus back to the target). ToastHost for non-blocking acks. ContentDialog for confirms — docs/dialogs-flyouts.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Save settings")
        qmlSource: "InfoBarHost {\n    InfoBar { … }\n}\nTeachingTip { target: field }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            HeaderedTextBox {
                id: nameField
                Layout.fillWidth: true
                header: qsTr("Display name")
                placeholderText: qsTr("Alex")
            }

            Connections {
                target: nameField.field
                function onActiveFocusChanged() {
                    if (nameField.field.activeFocus && !page.tipShown) {
                        page.tipShown = true
                        tip.open()
                    }
                }
            }

            RowLayout {
                spacing: Theme.spacing
                AccentButton {
                    text: qsTr("Save")
                    onClicked: {
                        successBar.isOpen = false
                        errorBar.isOpen = false
                        if (nameField.text.trim().length === 0) {
                            errorBar.isOpen = true
                            return
                        }
                        successBar.message = qsTr("Settings saved for %1.").arg(nameField.text.trim())
                        successBar.isOpen = true
                    }
                }
                Button {
                    text: qsTr("Show tip again")
                    onClicked: {
                        page.tipShown = false
                        tip.open()
                    }
                }
                Button {
                    text: qsTr("Clear bars")
                    onClicked: {
                        errorBar.isOpen = false
                        successBar.isOpen = false
                    }
                }
            }

            TeachingTip {
                id: tip
                target: nameField.field
                title: qsTr("Display name")
                subtitle: qsTr("Enter a name, then Save. Closing this tip returns focus to the field.")
                preferredPlacement: Qt.AlignBottom
                actionText: qsTr("Got it")
                onActionClicked: tip.close()
            }
        }
    }
}

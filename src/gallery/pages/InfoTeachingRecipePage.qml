import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — InfoBar + TeachingTip scenario recipe (form save / tip coach mark).

CatalogPage {
    id: page
    title: qsTr("InfoBar + TeachingTip recipe")
    subtitle: qsTr("Scenario: form validation InfoBarHost stack + TeachingTip coach mark on first focus.")

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
        headerText: qsTr("Save settings")
        qmlSource: "InfoBarHost {\n    InfoBar { … }\n}\nTeachingTip { target: field }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            HeaderedTextBox {
                id: nameField
                Layout.fillWidth: true
                title: qsTr("Display name")
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
            }

            TeachingTip {
                id: tip
                target: nameField
                title: qsTr("Display name")
                subtitle: qsTr("This name appears on your profile and shared devices.")
                preferredPlacement: Qt.AlignBottom
            }
        }
    }
}

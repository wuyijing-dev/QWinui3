import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
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
                title: qsTr("StepBar")
                subtitle: qsTr("Step indicator for wizards. Supports horizontal/vertical orientation.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Wizard steps")
                qmlSource: "StepBar {\n    orientation: \"horizontal\"\n    isInteractive: true\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    RowLayout {
                        Label { text: qsTr("Orientation"); color: Theme.textSecondary }
                        ComboBox {
                            id: orient
                            model: ["horizontal", "vertical"]
                            currentIndex: 0
                            Layout.preferredWidth: 140
                        }
                        CheckBox {
                            id: interactive
                            text: qsTr("Interactive")
                            checked: true
                        }
                    }
                    StepBar {
                        id: steps
                        Layout.fillWidth: true
                        orientation: orient.currentText
                        isInteractive: interactive.checked
                        currentIndex: 1
                        model: [
                            { title: qsTr("Account"), description: qsTr("Sign in") },
                            { title: qsTr("Profile"), description: qsTr("Details") },
                            { title: qsTr("Review"), description: qsTr("Confirm") },
                            { title: qsTr("Done") }
                        ]
                    }
                    RowLayout {
                        spacing: Theme.spacing
                        Button {
                            text: qsTr("Back")
                            enabled: steps.currentIndex > 0
                            onClicked: steps.currentIndex--
                        }
                        AccentButton {
                            text: qsTr("Next")
                            enabled: steps.currentIndex < steps.model.length - 1
                            onClicked: steps.currentIndex++
                        }
                        Label {
                            text: qsTr("Step %1 of %2").arg(steps.currentIndex + 1).arg(steps.model.length)
                            color: Theme.textSecondary
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

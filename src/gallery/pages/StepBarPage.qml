import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — StepBar.
//
// Wizard steps with selectedIndex, next()/previous()/goTo(), and Fluent Accept marks. API: docs/components/StepBar.md

CatalogPage {
    title: qsTr("StepBar")
    subtitle: qsTr("Wizard steps with selectedIndex, next()/previous()/goTo(), and Fluent Accept marks.")

    ControlExample {
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
                selectedIndex: 1
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
                    enabled: steps.selectedIndex > 0
                    onClicked: steps.previous()
                }
                AccentButton {
                    text: qsTr("Next")
                    enabled: steps.selectedIndex < steps.model.length - 1
                    onClicked: steps.next()
                }
                Label {
                    text: qsTr("Step %1 of %2").arg(steps.selectedIndex + 1).arg(steps.model.length)
                    color: Theme.textSecondary
                }
            }
        }
    }
}

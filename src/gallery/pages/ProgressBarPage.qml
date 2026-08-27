import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — ProgressBar (WinUI header / value / Running·Paused·Error).

CatalogPage {
    title: qsTr("ProgressBar")
    subtitle: qsTr("Header, value label, ShowError / ShowPaused — docs/components/ProgressBar.md")

    ControlExample {
        headerText: qsTr("A determinate ProgressBar")
        qmlSource: "ProgressBar {\n    header: \"Downloading update\"\n    showValue: true\n    value: 0.45\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ProgressBar {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Downloading update")
                showValue: true
                value: 0.45
            }
            ProgressBar {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Almost done")
                showValue: true
                value: 0.92
            }
            ProgressBar {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Disabled")
                showValue: true
                value: 0.35
                enabled: false
            }
        }
    }

    ControlExample {
        headerText: qsTr("An indeterminate ProgressBar")
        qmlSource: "ProgressBar { indeterminate: true; header: \"Working…\" }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use indeterminate when the remaining work is unknown. Prefer ProgressRing for compact busy.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            ProgressBar {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                indeterminate: true
                header: qsTr("Working…")
                showValue: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("Progress state — Running / Paused / Error")
        qmlSource: "ProgressBar {\n    indeterminate: true\n    showPaused: true   // or showError\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("WinUI ShowPaused (caution) and ShowError (critical). Paused / Error freeze indeterminate motion.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            ProgressBar {
                id: stateBar
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Sync")
                showValue: true
                indeterminate: true
                showPaused: stateGroup.checkedButton === pausedRb
                showError: stateGroup.checkedButton === errorRb
            }
            ButtonGroup { id: stateGroup }
            RowLayout {
                spacing: Theme.spacingLoose
                RadioButton {
                    id: runningRb
                    text: qsTr("Running")
                    checked: true
                    ButtonGroup.group: stateGroup
                }
                RadioButton {
                    id: pausedRb
                    text: qsTr("Paused")
                    ButtonGroup.group: stateGroup
                }
                RadioButton {
                    id: errorRb
                    text: qsTr("Error")
                    ButtonGroup.group: stateGroup
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("A determinate ProgressBar you can drive")
        qmlSource: "ProgressBar {\n    value: slider.position\n    showValue: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Drag the Slider to change progress. Toggle Paused / Error to recolor the fill.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            ProgressBar {
                id: drivenBar
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Install")
                showValue: true
                from: 0
                to: 100
                value: driveSlider.value
                showPaused: driveState.checkedButton === drivePaused
                showError: driveState.checkedButton === driveError
            }
            Slider {
                id: driveSlider
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                from: 0
                to: 100
                value: 35
                stepSize: 1
                enabled: driveState.checkedButton === driveRunning
            }
            ButtonGroup { id: driveState }
            RowLayout {
                spacing: Theme.spacingLoose
                RadioButton {
                    id: driveRunning
                    text: qsTr("Running")
                    checked: true
                    ButtonGroup.group: driveState
                }
                RadioButton {
                    id: drivePaused
                    text: qsTr("Paused")
                    ButtonGroup.group: driveState
                }
                RadioButton {
                    id: driveError
                    text: qsTr("Error")
                    ButtonGroup.group: driveState
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Track thickness")
        qmlSource: "ProgressBar { trackThickness: 8; value: 0.6 }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ProgressBar {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Default (5px)")
                showValue: true
                value: 0.55
            }
            ProgressBar {
                Layout.preferredWidth: 360
                Layout.fillWidth: true
                header: qsTr("Emphasized (8px)")
                showValue: true
                trackThickness: 8
                value: 0.55
            }
        }
    }
}

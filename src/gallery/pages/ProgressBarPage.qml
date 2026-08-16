import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — ProgressBar.

CatalogPage {
    title: qsTr("ProgressBar")
    subtitle: qsTr("Shows the progress of an operation that has a known duration.")

    ControlExample {
        headerText: qsTr("Determinate ProgressBar")
        qmlSource: "ProgressBar { value: 0.35 }\nProgressBar { value: 0.7 }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            ProgressBar {
                Layout.preferredWidth: 320
                value: 0.35
            }
            ProgressBar {
                Layout.preferredWidth: 320
                value: 0.7
            }
        }
    }

    ControlExample {
        headerText: qsTr("WinUI ShowError / ShowPaused")
        qmlSource: "ProgressBar { value: 0.45; showError: true }\nProgressBar { indeterminate: true; showPaused: true }"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ProgressBar {
                Layout.preferredWidth: 320
                value: 0.45
                showError: true
            }
            ProgressBar {
                Layout.preferredWidth: 320
                value: 0.6
                showPaused: true
            }
            ProgressBar {
                Layout.preferredWidth: 320
                indeterminate: true
                showPaused: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("Indeterminate ProgressBar")
        qmlSource: "ProgressBar {\n    indeterminate: true\n}"

        ProgressBar {
            Layout.preferredWidth: 320
            indeterminate: true
        }
    }
}

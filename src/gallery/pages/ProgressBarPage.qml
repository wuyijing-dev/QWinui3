import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — ProgressBar.
//
// In-place progress — not a toast. Recipe: docs/feedback.md (1.34).

CatalogPage {
    title: qsTr("ProgressBar")
    subtitle: qsTr("In-place progress next to the work — docs/feedback.md (1.34).")

    ControlExample {
        headerText: qsTr("When to use (1.34)")
        qmlSource: "// ProgressBar — known fraction / busy\n// Toast — short ack only\n// docs/feedback.md"
        ColumnLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Keep progress beside the operation. Prefer ProgressRing / ProgressButton for compact or in-button busy. Do not replace progress with a toast.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

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

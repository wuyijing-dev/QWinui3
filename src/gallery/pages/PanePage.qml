import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Pane.
//
// WinUI long-text pattern: constrain Pane width, then Wrap or Trim body text.

CatalogPage {
    title: qsTr("Pane")
    subtitle: qsTr("A padded surface that groups related content. Long text uses Wrap / Trim like WinUI TextBlock.")

    ControlExample {
        headerText: qsTr("Wrap (TextWrapping)")
        qmlSource: "Pane {\n    TextBlock {\n        textWrapping: \"wrap\"\n        text: \"…\"\n    }\n}"

        Pane {
            Layout.fillWidth: true
            TextBlock {
                text: qsTr("This is content inside a Pane. Use panes to visually group related controls and text. When the line is longer than the pane, TextWrapping wraps onto the next lines instead of stretching the surface.")
                textWrapping: "wrap"
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Trim (TextTrimming + MaxLines)")
        qmlSource: "Pane {\n    TextBlock {\n        textTrimming: \"characterEllipsis\"\n        maxLines: 2\n    }\n}"

        Pane {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            TextBlock {
                text: qsTr("Very long pane body that should stay within the pane width. Extra words are trimmed with an ellipsis after MaxLines, matching WinUI TextTrimming CharacterEllipsis.")
                textWrapping: "wrap"
                textTrimming: "characterEllipsis"
                maxLines: 2
                color: Theme.textPrimary
            }
        }
    }
}

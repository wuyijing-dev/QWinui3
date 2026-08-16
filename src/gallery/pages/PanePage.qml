import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Pane.

CatalogPage {
    title: qsTr("Pane")
    subtitle: qsTr("A padded surface that groups related content.")

    ControlExample {
        headerText: qsTr("Basic Pane")
        qmlSource: "Pane {\n    Label {\n        text: \"Pane content\"\n    }\n}"

        Pane {
            Layout.preferredWidth: 320
            Label {
                text: qsTr("This is content inside a Pane. Use panes to visually group related controls and text.")
                wrapMode: Text.Wrap
                width: parent.availableWidth
                color: Theme.textPrimary
            }
        }
    }
}

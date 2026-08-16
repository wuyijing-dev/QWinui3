import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Label.

CatalogPage {
    title: qsTr("Label")
    subtitle: qsTr("A text label for captions and descriptions.")

    ControlExample {
        headerText: qsTr("Typography")
        qmlSource: "Label { text: \"Body\" }\nLabel { text: \"Caption\"; font.pixelSize: 12 }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label { text: qsTr("Body label") }
            Label {
                text: qsTr("Secondary caption")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                text: qsTr("Wrapped label text for longer descriptions that span multiple lines.")
            }
        }
    }
}

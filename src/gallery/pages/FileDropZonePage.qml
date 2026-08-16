import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — FileDropZone.

CatalogPage {
    title: qsTr("FileDropZone")
    subtitle: qsTr("Drag-and-drop target with optional extension filter.")

    ControlExample {
        headerText: qsTr("Drop images")
        qmlSource: "FileDropZone {\n    acceptExtensions: [\".png\", \".jpg\"]\n    onFilesDropped: …\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            FileDropZone {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                title: qsTr("Drop images here")
                subtitle: qsTr("Accepts .png and .jpg")
                acceptExtensions: [".png", ".jpg", ".jpeg", ".webp"]
                onFilesDropped: function (urls) {
                    status.text = qsTr("Dropped %1 file(s):\n%2")
                        .arg(urls.length)
                        .arg(urls.join("\n"))
                }
            }
            Label {
                id: status
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("Waiting for drop…")
            }
        }
    }
}

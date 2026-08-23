import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RecentFiles (2.77).

CatalogPage {
    id: page
    title: qsTr("RecentFiles")
    subtitle: qsTr("Settings-backed recent paths + WindowHelper.addToRecentDocuments.")

    RecentFiles {
        id: recent
        category: "GalleryRecentFilesDemo"
        maxCount: 8
        onChanged: listLabel.text = recent.list().join("\n") || qsTr("(empty)")
    }

    Component.onCompleted: listLabel.text = recent.list().join("\n") || qsTr("(empty)")

    ControlExample {
        headerText: qsTr("Add / clear")
        qmlSource: "RecentFiles { id: recent }\nrecent.add(path)\nrecent.clear()"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                TextField {
                    id: pathField
                    Layout.fillWidth: true
                    placeholderText: qsTr("C:/docs/report.docx")
                    text: qsTr("C:/Users/Public/Documents/demo.txt")
                }
                Button {
                    text: qsTr("Add")
                    onClicked: recent.add(pathField.text)
                }
                Button {
                    text: qsTr("Clear")
                    onClicked: recent.clear()
                }
            }
            Label {
                id: listLabel
                Layout.fillWidth: true
                wrapMode: Text.WrapAnywhere
                color: Theme.textPrimary
                font.pixelSize: Theme.fontCaption
            }
        }
    }
}

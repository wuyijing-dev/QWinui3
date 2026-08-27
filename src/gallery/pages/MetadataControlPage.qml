import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — MetadataControl.
//
// Label/value pairs with symbol: FluentIcons.* on MetadataItem. API: docs/components/MetadataControl.md

CatalogPage {
    title: qsTr("MetadataControl")
    subtitle: qsTr("Label/value pairs with symbol: FluentIcons.* on MetadataItem.")

    ControlExample {
        headerText: qsTr("Vertical")
        qmlSource: "MetadataControl {\n    header: \"File info\"\n    MetadataItem { … }\n}"
        ContentCard {
            Layout.fillWidth: true
            Layout.maximumWidth: 420
            MetadataControl {
                width: parent ? parent.width : 280
                header: qsTr("File info")
                orientation: Qt.Vertical
                MetadataItem {
                    label: qsTr("Author")
                    value: qsTr("Ada Lovelace")
                    symbol: FluentIcons.Contact
                }
                MetadataItem {
                    label: qsTr("Created")
                    value: "2026-08-09"
                    symbol: FluentIcons.Calendar
                }
                MetadataItem {
                    label: qsTr("Type")
                    value: qsTr("PNG image")
                    symbol: FluentIcons.Photo
                }
                MetadataItem {
                    label: qsTr("Size")
                    value: "MB"
                    secondary: qsTr("Compressed")
                    symbol: FluentIcons.Document
                    valueColor: Theme.accent
                }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Horizontal rows")
        qmlSource: "MetadataControl {\n    orientation: Qt.Horizontal\n}"
        ContentCard {
            Layout.fillWidth: true
            Layout.maximumWidth: 560
            MetadataControl {
                width: parent ? parent.width : 320
                orientation: Qt.Horizontal
                MetadataItem { label: qsTr("Status"); value: qsTr("Published") }
                MetadataItem { label: qsTr("Owner"); value: qsTr("Design team") }
                MetadataItem { label: qsTr("Revision"); value: "14" }
            }
        }
    }
}

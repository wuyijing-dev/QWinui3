import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — ToolBar.
//
// A container for command buttons and related controls. API: docs/components/ToolBar.md

CatalogPage {
    title: qsTr("ToolBar")
    subtitle: qsTr("A container for command buttons and related controls.")

    ControlExample {
        headerText: qsTr("With ToolButtons")
        qmlSource: "ToolBar {\n    ToolButton { text: \"\\uE8A7\" }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            ToolBar {
                Layout.fillWidth: true
                RowLayout {
                    anchors.fill: parent
                    ToolButton {
                        text: "\uE8C8"
                        font.family: Theme.fontFamilyIcon
                        onClicked: status.text = qsTr("Copy")
                    }
                    ToolButton {
                        text: "\uE77F"
                        font.family: Theme.fontFamilyIcon
                        onClicked: status.text = qsTr("Cut")
                    }
                    ToolButton {
                        text: "\uE77B"
                        font.family: Theme.fontFamilyIcon
                        onClicked: status.text = qsTr("Paste")
                    }
                    ToolSeparator {}
                    ToolButton {
                        text: "\uE74D"
                        font.family: Theme.fontFamilyIcon
                        onClicked: status.text = qsTr("Delete")
                    }
                    Item { Layout.fillWidth: true }
                    Label {
                        text: qsTr("Document")
                        color: Theme.textSecondary
                        Layout.rightMargin: 8
                    }
                }
            }
            Label {
                id: status
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
        }
    }
}

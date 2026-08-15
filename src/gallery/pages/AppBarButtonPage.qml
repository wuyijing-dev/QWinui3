import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("AppBarButton")
                subtitle: qsTr("An icon-and-label command button for app bars and tool strips.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Commands")
                qmlSource: "AppBarButton {\n    iconGlyph: \"\\uE8C8\"\n    text: \"Copy\"\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    RowLayout {
                        spacing: Theme.spacingLoose
                        AppBarButton {
                            iconGlyph: "\uE8C8"
                            text: qsTr("Copy")
                            onClicked: status.text = qsTr("Copy")
                        }
                        AppBarButton {
                            iconGlyph: "\uE77F"
                            text: qsTr("Cut")
                            onClicked: status.text = qsTr("Cut")
                        }
                        AppBarButton {
                            iconGlyph: "\uE74D"
                            text: qsTr("Delete")
                            onClicked: status.text = qsTr("Delete")
                        }
                        AppBarButton {
                            iconGlyph: "\uE713"
                            text: qsTr("Save")
                            highlighted: true
                            onClicked: status.text = qsTr("Save")
                        }
                    }
                    Label {
                        id: status
                        text: qsTr("Ready")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

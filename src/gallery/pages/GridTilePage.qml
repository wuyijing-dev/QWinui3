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
                title: qsTr("GridTile")
                subtitle: qsTr("A selectable grid card with glyph or image, title, subtitle, and badge.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Selection")
                qmlSource: "GridTile {\n    title: \"Photos\"\n    isSelected: true\n    badgeText: \"New\"\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    Label {
                        id: tileStatus
                        text: qsTr("Toggle tiles to select")
                        color: Theme.textSecondary
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacingLoose
                        GridTile {
                            title: qsTr("Photos")
                            subtitle: qsTr("128 items")
                            glyph: "\uE91B"
                            isSelected: true
                            badgeText: qsTr("New")
                            onToggled: tileStatus.text = qsTr("Photos selected: %1").arg(checked)
                        }
                        GridTile {
                            title: qsTr("Music")
                            subtitle: qsTr("24 playlists")
                            glyph: "\uE8D6"
                            badgeText: "24"
                            onToggled: tileStatus.text = qsTr("Music selected: %1").arg(checked)
                        }
                        GridTile {
                            title: qsTr("Documents")
                            subtitle: qsTr("Recent")
                            glyph: "\uE8A5"
                            onToggled: tileStatus.text = qsTr("Documents selected: %1").arg(checked)
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

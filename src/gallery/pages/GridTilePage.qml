import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — GridTile.
//
// Selectable grid card with symbol, badge, check mark, and press scale. API: docs/components/GridTile.md

CatalogPage {
    title: qsTr("GridTile")
    subtitle: qsTr("Selectable grid card with symbol, badge, check mark, and press scale.")

    ControlExample {
        headerText: qsTr("Selection")
        qmlSource: "GridTile {\n    title: \"Photos\"\n    symbol: FluentIcons.Photo\n    isSelected: true\n}"
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
                    symbol: FluentIcons.Photo
                    isSelected: true
                    badgeText: qsTr("New")
                    onToggled: tileStatus.text = qsTr("Photos selected: %1").arg(checked)
                }
                GridTile {
                    title: qsTr("Music")
                    subtitle: qsTr("24 playlists")
                    symbol: FluentIcons.Volume
                    badgeText: "24"
                    onToggled: tileStatus.text = qsTr("Music selected: %1").arg(checked)
                }
                GridTile {
                    title: qsTr("Documents")
                    subtitle: qsTr("Recent")
                    symbol: FluentIcons.Document
                    onToggled: tileStatus.text = qsTr("Documents selected: %1").arg(checked)
                }
            }
        }
    }
}

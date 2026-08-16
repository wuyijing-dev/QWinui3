import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — FontIcon.

CatalogPage {
    title: qsTr("FontIcon")
    subtitle: qsTr("Use FluentIcons names — no raw \\uE… escapes. symbol: FluentIcons.Home or symbol: \"Save\".")

    ControlExample {
        headerText: qsTr("FluentIcons character class")
        qmlSource: "FontIcon { symbol: FluentIcons.Home }\nIconButton { symbol: \"Search\" }"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            FontIcon { symbol: FluentIcons.Home; fontSize: 16; toolTipText: qsTr("Home") }
            FontIcon { symbol: FluentIcons.Search; fontSize: 20; iconColor: Theme.accent; toolTipText: qsTr("Search") }
            FontIcon { symbol: FluentIcons.Favorite; fontSize: 28; iconColor: Theme.systemCaution }
            FontIcon { symbol: FluentIcons.Accept; fontSize: 32; iconColor: Theme.systemSuccess; fontWeight: Theme.fontWeightSemiBold }
            FontIcon { symbol: FluentIcons.ChromeClose; fontSize: 20; enabled: false }
            FontIcon { symbol: "ChevronRight"; fontSize: 20; mirrorGlyph: true; toolTipText: qsTr("Mirrored") }
            IconButton { symbol: FluentIcons.Settings; toolTipText: qsTr("Settings") }
            IconButton { symbol: "Refresh"; highlighted: true; toolTipText: qsTr("Refresh") }
        }
    }
    ControlExample {
        headerText: qsTr("Common symbols")
        qmlSource: "FontIcon { symbol: FluentIcons.Settings }"
        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Repeater {
                model: [
                    { symbol: FluentIcons.Home, n: qsTr("Home") },
                    { symbol: FluentIcons.Settings, n: qsTr("Settings") },
                    { symbol: FluentIcons.Search, n: qsTr("Search") },
                    { symbol: FluentIcons.OtherUser, n: qsTr("Person") },
                    { symbol: FluentIcons.Folder, n: qsTr("Folder") },
                    { symbol: FluentIcons.Delete, n: qsTr("Delete") },
                    { symbol: FluentIcons.Edit, n: qsTr("Edit") },
                    { symbol: FluentIcons.Refresh, n: qsTr("Refresh") }
                ]
                Column {
                    required property var modelData
                    spacing: 4
                    FontIcon {
                        anchors.horizontalCenter: parent.horizontalCenter
                        symbol: modelData.symbol
                        fontSize: 22
                        iconColor: Theme.textPrimary
                        toolTipText: modelData.n
                        accessibleName: modelData.n
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.n
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                    }
                }
            }
        }
    }
}

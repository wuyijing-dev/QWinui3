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
                title: qsTr("FontIcon")
                subtitle: qsTr("Use FluentIcons names — no raw \\uE… escapes. icon: FluentIcons.Home or icon: \"Save\".")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("FluentIcons character class")
                qmlSource: "FontIcon { icon: FluentIcons.Home }\nIconButton { icon: \"Search\" }"
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    FontIcon { icon: FluentIcons.Home; fontSize: 16; toolTipText: qsTr("Home") }
                    FontIcon { icon: FluentIcons.Search; fontSize: 20; iconColor: Theme.accent; toolTipText: qsTr("Search") }
                    FontIcon { icon: FluentIcons.Favorite; fontSize: 28; iconColor: Theme.systemCaution }
                    FontIcon { icon: FluentIcons.Accept; fontSize: 32; iconColor: Theme.systemSuccess; fontWeight: Theme.fontWeightSemiBold }
                    FontIcon { icon: FluentIcons.ChromeClose; fontSize: 20; enabled: false }
                    FontIcon { icon: "ChevronRight"; fontSize: 20; mirrorGlyph: true; toolTipText: qsTr("Mirrored") }
                    IconButton { icon: FluentIcons.Settings; toolTipText: qsTr("Settings") }
                    IconButton { icon: "Refresh"; highlighted: true; toolTipText: qsTr("Refresh") }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Common symbols")
                qmlSource: "FontIcon { icon: FluentIcons.Settings }"
                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    Repeater {
                        model: [
                            { icon: FluentIcons.Home, n: qsTr("Home") },
                            { icon: FluentIcons.Settings, n: qsTr("Settings") },
                            { icon: FluentIcons.Search, n: qsTr("Search") },
                            { icon: FluentIcons.OtherUser, n: qsTr("Person") },
                            { icon: FluentIcons.Folder, n: qsTr("Folder") },
                            { icon: FluentIcons.Delete, n: qsTr("Delete") },
                            { icon: FluentIcons.Edit, n: qsTr("Edit") },
                            { icon: FluentIcons.Refresh, n: qsTr("Refresh") }
                        ]
                        Column {
                            required property var modelData
                            spacing: 4
                            FontIcon {
                                anchors.horizontalCenter: parent.horizontalCenter
                                icon: modelData.icon
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

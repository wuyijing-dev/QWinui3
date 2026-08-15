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
                subtitle: qsTr("Fluent glyph with symbol alias, weight, and optional tooltip.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Sizes and colors")
                qmlSource: "FontIcon {\n    symbol: \"\\uE8A7\"\n    toolTipText: \"Home\"\n}"
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    FontIcon { glyph: "\uE8A7"; fontSize: 16; toolTipText: qsTr("Home") }
                    FontIcon { glyph: "\uE721"; fontSize: 20; iconColor: Theme.accent; toolTipText: qsTr("Search") }
                    FontIcon { glyph: "\uE734"; fontSize: 28; iconColor: Theme.systemCaution }
                    FontIcon { glyph: "\uE73E"; fontSize: 32; iconColor: Theme.systemSuccess; fontWeight: Theme.fontWeightSemiBold }
                    FontIcon { glyph: "\uE711"; fontSize: 20; enabled: false }
                    FontIcon { symbol: "\uE76C"; fontSize: 20; mirrorGlyph: true; toolTipText: qsTr("Mirrored") }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Common glyphs")
                qmlSource: "FontIcon { glyph: \"\\uE80F\" }"
                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    Repeater {
                        model: [
                            { g: "\uE80F", n: qsTr("Home") },
                            { g: "\uE713", n: qsTr("Settings") },
                            { g: "\uE721", n: qsTr("Search") },
                            { g: "\uE8BD", n: qsTr("Person") },
                            { g: "\uE8A5", n: qsTr("Folder") },
                            { g: "\uE74D", n: qsTr("Delete") },
                            { g: "\uE70F", n: qsTr("Edit") },
                            { g: "\uE72C", n: qsTr("Refresh") }
                        ]
                        Column {
                            required property var modelData
                            spacing: 4
                            FontIcon {
                                anchors.horizontalCenter: parent.horizontalCenter
                                glyph: modelData.g
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

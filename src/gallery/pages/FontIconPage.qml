import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — FontIcon / FluentIcons catalog.

CatalogPage {
    id: page
    title: qsTr("FontIcon")
    subtitle: qsTr("All FluentIcons symbols. Prefer symbol: FluentIcons.Home — not raw \\uE… escapes.")

    readonly property var allNames: FluentIcons.names()
    readonly property var filteredNames: {
        var q = filterBox.text.trim().toLowerCase()
        var src = allNames
        if (!q.length)
            return src
        var out = []
        for (var i = 0; i < src.length; ++i) {
            if (String(src[i]).toLowerCase().indexOf(q) >= 0)
                out.push(src[i])
        }
        return out
    }

    ControlExample {
        headerText: qsTr("Usage")
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
        headerText: qsTr("All symbols (%1)").arg(page.filteredNames.length)
        qmlSource: "FontIcon { symbol: FluentIcons.Save }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            SearchBox {
                id: filterBox
                Layout.fillWidth: true
                Layout.maximumWidth: 360
                placeholderText: qsTr("Filter by name…")
            }

            Label {
                visible: page.filteredNames.length === 0
                text: qsTr("No symbols match “%1”.").arg(filterBox.text)
                color: Theme.textSecondary
            }

            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacingLoose
                Repeater {
                    model: page.filteredNames
                    delegate: Item {
                        id: cell
                        required property string modelData
                        width: 88
                        height: 76

                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            FontIcon {
                                anchors.horizontalCenter: parent.horizontalCenter
                                symbol: cell.modelData
                                fontSize: 22
                                iconColor: Theme.textPrimary
                                toolTipText: cell.modelData
                                accessibleName: cell.modelData
                            }
                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 80
                                horizontalAlignment: Text.AlignHCenter
                                text: cell.modelData
                                elide: Text.ElideRight
                                color: Theme.textSecondary
                                font.pixelSize: Theme.fontCaption
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            ToolTip.visible: containsMouse
                            ToolTip.text: qsTr("FluentIcons.%1").arg(cell.modelData)
                            ToolTip.delay: 400
                        }
                    }
                }
            }
        }
    }
}

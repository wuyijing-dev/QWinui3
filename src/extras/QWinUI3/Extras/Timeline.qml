import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Vertical timeline. model: [{ title, subtitle?, time?, glyph?, color?, active? }]
T.Control {
    id: root

    property var model: []
    property int currentIndex: -1
    property real railWidth: 2
    property real nodeSize: 12
    property bool isInteractive: true
    signal itemClicked(int index)

    padding: 8
    spacing: Theme.spacingLoose
    implicitWidth: 320
    implicitHeight: list.implicitHeight + topPadding + bottomPadding
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    contentItem: Column {
        id: list
        width: root.availableWidth
        spacing: 0

        Repeater {
            model: root.model
            Item {
                id: row
                required property var modelData
                required property int index
                width: list.width
                height: Math.max(40, contentCol.implicitHeight + 16)

                readonly property bool isLast: index === (root.model.length - 1)
                readonly property bool isActive: modelData.active === true
                                                || index === root.currentIndex
                                                || (root.currentIndex < 0 && index === 0)
                readonly property color nodeColor: modelData.color || Theme.accent

                TapHandler {
                    enabled: root.isInteractive
                    onTapped: {
                        root.currentIndex = index
                        root.itemClicked(index)
                    }
                }

                Rectangle {
                    visible: !row.isLast
                    x: root.nodeSize / 2 - root.railWidth / 2
                    y: root.nodeSize
                    width: root.railWidth
                    height: parent.height - root.nodeSize
                    color: row.isActive ? Qt.rgba(row.nodeColor.r, row.nodeColor.g, row.nodeColor.b, 0.45)
                                        : Theme.strokeDivider
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionNormal)
                        }
                    }
                }

                Rectangle {
                    width: root.nodeSize
                    height: root.nodeSize
                    radius: width / 2
                    color: row.isActive ? row.nodeColor : Theme.fillSubtle
                    border.width: 2
                    border.color: row.isActive ? Theme.bgLayer : Theme.strokeControl
                    y: 4
                    scale: row.isActive ? 1 : 0.9
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionNormal)
                        }
                    }
                    Behavior on scale {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.duration(Theme.motionNormal)
                            easing.type: Theme.easingEnter
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: !!(modelData.glyph)
                        text: modelData.glyph || ""
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: 8
                        color: row.isActive ? Theme.textOnAccent : Theme.textSecondary
                    }
                }

                Column {
                    id: contentCol
                    x: root.nodeSize + 12
                    width: parent.width - x
                    spacing: 2
                    opacity: row.isActive ? 1 : 0.72
                    Behavior on opacity {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.duration(Theme.motionFast)
                        }
                    }
                    Text {
                        visible: !!(modelData.time)
                        text: modelData.time || ""
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                    }
                    Text {
                        width: parent.width
                        text: modelData.title || ""
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        font.weight: row.isActive ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                        color: Theme.textPrimary
                        wrapMode: Text.Wrap
                    }
                    Text {
                        visible: !!(modelData.subtitle)
                        width: parent.width
                        text: modelData.subtitle || ""
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                        wrapMode: Text.Wrap
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: root.nodeSize + 8
                    radius: Theme.cornerControl
                    color: root.isInteractive && rowHover.hovered ? Theme.fillSubtleSecondary : "transparent"
                    z: -1
                    HoverHandler { id: rowHover; enabled: root.isInteractive }
                }
            }
        }
    }

    background: Item {}
}

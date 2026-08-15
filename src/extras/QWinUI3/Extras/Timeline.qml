import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Vertical timeline. model: [{ title, subtitle?, time?, symbol?, glyph?, color?, active? }]
T.Control {
    id: root

    property var model: []
    property int currentIndex: -1
    property alias selectedIndex: root.currentIndex
    property real railWidth: 2
    property real nodeSize: 12
    property bool isInteractive: true
    signal itemClicked(int index)
    signal selectionChanged(int index)

    onCurrentIndexChanged: selectionChanged(currentIndex)

    function select(index) {
        if (index < 0 || index >= (model ? model.length : 0))
            return
        currentIndex = index
        itemClicked(index)
    }

    function next() {
        if (currentIndex < (model ? model.length : 0) - 1)
            select(currentIndex + 1)
    }
    function previous() {
        if (currentIndex > 0)
            select(currentIndex - 1)
    }

    padding: 8
    spacing: Theme.spacingLoose
    implicitWidth: 320
    implicitHeight: list.implicitHeight + topPadding + bottomPadding
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    focusPolicy: isInteractive ? Qt.StrongFocus : Qt.NoFocus
    activeFocusOnTab: isInteractive
    Accessible.role: Accessible.List
    Accessible.name: qsTr("Timeline")
    Keys.onDownPressed: next()
    Keys.onUpPressed: previous()

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
                readonly property string _glyph: IconSource.resolve(
                        (typeof modelData === "object" && modelData) ? (modelData.symbol || "") : "",
                        (typeof modelData === "object" && modelData) ? (modelData.glyph || "") : "")
                readonly property real _node: _glyph.length ? Math.max(root.nodeSize, 20) : root.nodeSize

                TapHandler {
                    enabled: root.isInteractive
                    onTapped: root.select(index)
                }

                Rectangle {
                    visible: !row.isLast
                    x: row._node / 2 - root.railWidth / 2
                    y: row._node
                    width: root.railWidth
                    height: parent.height - row._node
                    color: index < root.currentIndex || row.isActive
                           ? Qt.rgba(row.nodeColor.r, row.nodeColor.g, row.nodeColor.b, 0.45)
                           : Theme.strokeDivider
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionNormal)
                        }
                    }
                }

                Rectangle {
                    width: row._node
                    height: row._node
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
                        visible: row._glyph.length > 0
                        text: row._glyph
                        font.family: Theme.fontFamilyIcon
                        font.pixelSize: Math.max(8, row._node * 0.45)
                        color: row.isActive ? Theme.textOnAccent : Theme.textSecondary
                    }
                }

                Column {
                    id: contentCol
                    x: row._node + 12
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
                    anchors.leftMargin: row._node + 8
                    radius: Theme.cornerControl
                    color: root.isInteractive && rowHover.hovered ? Theme.fillSubtleSecondary : "transparent"
                    border.width: root.activeFocus && row.isActive ? 1 : 0
                    border.color: Theme.focusOuter
                    z: -1
                    HoverHandler { id: rowHover; enabled: root.isInteractive }
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                }
            }
        }
    }

    background: Item {}
}

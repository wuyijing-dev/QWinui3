import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// Multi-segment meter / stacked progress (e.g. disk usage).
// segments: [{ value: number, color: color, label?: string }]
T.Control {
    id: root

    property var segments: []
    property real maximum: 100
    property real trackHeight: 8
    property bool showLegend: false
    property bool interactive: true
    property int hoverIndex: -1
    property string header: ""
    property bool showRemaining: false
    property string remainingLabel: qsTr("Free")
    property color remainingColor: Theme.dark ? "#15FFFFFF" : "#0F000000"

    signal segmentClicked(int index, real value)

    implicitWidth: 240
    implicitHeight: {
        var h = trackHeight
        if (header.length)
            h += Theme.fontBody + 8
        if (showLegend)
            h += 28
        return h
    }
    padding: 0

    readonly property real total: {
        var s = 0
        var segs = segments || []
        for (var i = 0; i < segs.length; ++i)
            s += Math.max(0, Number(segs[i].value) || 0)
        return s
    }

    readonly property real remaining: Math.max(0, maximum - total)

    contentItem: Column {
        spacing: 8

        Text {
            visible: root.header.length > 0
            width: parent.width
            text: root.header
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: root.enabled ? Theme.textPrimary : Theme.textDisabled
        }

        Item {
            width: parent.width
            height: root.trackHeight

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: Theme.dark ? "#15FFFFFF" : "#0F000000"
            }

            Row {
                id: barRow
                anchors.fill: parent
                spacing: 1
                clip: true

                Repeater {
                    model: root.segments
                    Rectangle {
                        id: seg
                        required property var modelData
                        required property int index
                        height: barRow.height
                        width: {
                            var max = Math.max(root.maximum, root.total, 1)
                            return Math.max(0, (Number(modelData.value) || 0) / max * barRow.width)
                        }
                        radius: index === 0 ? height / 2 : 0
                        color: modelData.color || Theme.accent
                        opacity: root.hoverIndex < 0 || root.hoverIndex === index ? 1 : 0.45
                        scale: root.hoverIndex === index ? 1.08 : 1
                        transformOrigin: Item.Center
                        Behavior on width {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.duration(Theme.motionSlow)
                                easing.type: Theme.easingStandard
                            }
                        }
                        Behavior on opacity {
                            enabled: !Theme.reducedMotion
                            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                        Behavior on scale {
                            enabled: !Theme.reducedMotion
                            NumberAnimation {
                                duration: Theme.duration(Theme.motionFast)
                                easing.type: Theme.easingStandard
                            }
                        }
                        ToolTip.visible: ma.containsMouse && (modelData.label || "").length > 0
                        ToolTip.text: (modelData.label || "") + " · " + (Number(modelData.value) || 0)
                        MouseArea {
                            id: ma
                            anchors.fill: parent
                            hoverEnabled: root.interactive
                            enabled: root.interactive
                            onEntered: root.hoverIndex = index
                            onExited: if (root.hoverIndex === index) root.hoverIndex = -1
                            onClicked: root.segmentClicked(index, Number(modelData.value) || 0)
                        }
                    }
                }
            }
        }

        Flow {
            visible: root.showLegend
            width: parent.width
            spacing: 12
            Repeater {
                model: root.segments
                Row {
                    required property var modelData
                    required property int index
                    spacing: 6
                    opacity: root.hoverIndex < 0 || root.hoverIndex === index ? 1 : 0.5
                    Behavior on opacity {
                        enabled: !Theme.reducedMotion
                        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                    }
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 2
                        anchors.verticalCenter: parent.verticalCenter
                        color: modelData.color || Theme.accent
                        scale: root.hoverIndex === index ? 1.2 : 1
                        Behavior on scale {
                            enabled: !Theme.reducedMotion
                            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                    }
                    Text {
                        text: (modelData.label || "") + (modelData.label ? " · " : "")
                              + (Number(modelData.value) || 0)
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        font.weight: root.hoverIndex === index ? Theme.fontWeightSemiBold
                                                              : Theme.fontWeightRegular
                        color: root.hoverIndex === index ? Theme.textPrimary : Theme.textSecondary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: root.interactive
                        enabled: root.interactive
                        onEntered: root.hoverIndex = index
                        onExited: if (root.hoverIndex === index) root.hoverIndex = -1
                        onClicked: root.segmentClicked(index, Number(modelData.value) || 0)
                    }
                }
            }
            Row {
                visible: root.showRemaining && root.remaining > 0
                spacing: 6
                Rectangle {
                    width: 8
                    height: 8
                    radius: 2
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.remainingColor
                    border.width: 1
                    border.color: Theme.strokeControl
                }
                Text {
                    text: root.remainingLabel + " · " + Math.round(root.remaining)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    background: Item {}
}

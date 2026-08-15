import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// MeterBar — Multi-segment stacked meter (e.g. disk usage).
//
//   MeterBar {
//       id: meter
//       value: 64
//       minimum: 0
//       maximum: 100
//   }
//   // --- API ---
//   // meter.value / levels
//
// @notes
//   Segmented meter / progress levels; value within minimum..maximum.

T.Control {
    id: root

    // Meter / stacked segment descriptors
    property var segments: []
    // Maximum value
    property real maximum: 100
    // Meter track height
    property real trackHeight: 8
    // Show chart legend
    property bool showLegend: false
    // Enable hover / click interaction
    property bool interactive: true
    // Hovered item index
    property int hoverIndex: -1
    // Header label above the control
    property string header: ""
    // Show remaining segment
    property bool showRemaining: false
    // Label for remaining segment
    property string remainingLabel: qsTr("Free")
    // Color for remaining segment
    property color remainingColor: Theme.dark ? "#15FFFFFF" : "#0F000000"
    // Show total column
    property bool showTotal: false

    // Emitted when a segment is clicked
    signal segmentClicked(int index, real value)

    implicitWidth: 240
    implicitHeight: {
        var h = trackHeight
        if (header.length || showTotal)
            h += Theme.fontBody + 8
        if (showLegend)
            h += 28
        return h
    }
    padding: 0
    Accessible.role: Accessible.ProgressBar
    Accessible.name: header.length ? header : qsTr("Meter")
    Accessible.description: qsTr("%1 of %2").arg(Math.round(total)).arg(Math.round(maximum))

    // Sum of segment values
    readonly property real total: {
        var s = 0
        var segs = segments || []
        for (var i = 0; i < segs.length; ++i)
            s += Math.max(0, Number(segs[i].value) || 0)
        return s
    }

    // Remaining count / time
    readonly property real remaining: Math.max(0, maximum - total)

    contentItem: Column {
        spacing: 8

        Row {
            visible: root.header.length > 0 || root.showTotal
            width: parent.width
            spacing: 8
            Text {
                visible: root.header.length > 0
                text: root.header
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: root.enabled ? Theme.textPrimary : Theme.textDisabled
                width: parent.width - (root.showTotal ? totalLabel.implicitWidth + 8 : 0)
                elide: Text.ElideRight
            }
            Item { width: 1; height: 1; visible: root.header.length === 0 }
            Text {
                id: totalLabel
                visible: root.showTotal
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("%1 / %2").arg(Math.round(root.total)).arg(Math.round(root.maximum))
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
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
                Item {
                    id: legendItem
                    required property var modelData
                    required property int index
                    implicitWidth: legendRow.implicitWidth
                    implicitHeight: legendRow.implicitHeight
                    opacity: root.hoverIndex < 0 || root.hoverIndex === index ? 1 : 0.5
                    Behavior on opacity {
                        enabled: !Theme.reducedMotion
                        NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                    }

                    RowLayout {
                        id: legendRow
                        spacing: 6
                        Rectangle {
                            Layout.preferredWidth: 8
                            Layout.preferredHeight: 8
                            Layout.alignment: Qt.AlignVCenter
                            radius: 2
                            color: legendItem.modelData.color || Theme.accent
                            scale: root.hoverIndex === legendItem.index ? 1.2 : 1
                            Behavior on scale {
                                enabled: !Theme.reducedMotion
                                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                        }
                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: (legendItem.modelData.label || "")
                                  + (legendItem.modelData.label ? " · " : "")
                                  + (Number(legendItem.modelData.value) || 0)
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontCaption
                            font.weight: root.hoverIndex === legendItem.index
                                         ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                            color: root.hoverIndex === legendItem.index
                                   ? Theme.textPrimary : Theme.textSecondary
                        }
                    }

                    HoverHandler {
                        enabled: root.interactive
                        onHoveredChanged: {
                            if (hovered)
                                root.hoverIndex = legendItem.index
                            else if (root.hoverIndex === legendItem.index)
                                root.hoverIndex = -1
                        }
                    }
                    TapHandler {
                        enabled: root.interactive
                        onTapped: root.segmentClicked(legendItem.index,
                                                      Number(legendItem.modelData.value) || 0)
                    }
                }
            }
            Item {
                visible: root.showRemaining && root.remaining > 0
                implicitWidth: remainRow.implicitWidth
                implicitHeight: remainRow.implicitHeight
                RowLayout {
                    id: remainRow
                    spacing: 6
                    Rectangle {
                        Layout.preferredWidth: 8
                        Layout.preferredHeight: 8
                        Layout.alignment: Qt.AlignVCenter
                        radius: 2
                        color: root.remainingColor
                        border.width: 1
                        border.color: Theme.strokeControl
                    }
                    Text {
                        Layout.alignment: Qt.AlignVCenter
                        text: root.remainingLabel + " · " + Math.round(root.remaining)
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                    }
                }
            }
        }
    }

    background: Item {}
}

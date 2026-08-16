import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// AnnotatedScrollBar — Scroll area with a value label on the vertical scrollbar.
//
//   AnnotatedScrollBar {
//       id: scroll
//       anchors.fill: parent
//       // string[] (even spacing) OR [{ content|text, scrollOffset }]
//       // scrollOffset: 0..1 normalized, or >=1 absolute contentY
//       labels: [
//           { content: "Intro", scrollOffset: 0 },
//           { content: "Body", scrollOffset: 0.45 },
//           { content: "End", scrollOffset: 0.9 }
//       ]
//       labelFormat: "%1%"
//       alwaysShowLabel: false
//       Column {
//           width: scroll.flickable.width
//           Repeater {
//               model: 40
//               Label { text: "Row " + (index + 1); height: 36 }
//           }
//       }
//   }
//
//   // --- API ---
//   // read:  scroll.scrollPosition, scroll.currentLabel, scroll.detailLabel, scroll.activeLabelIndex
//   // write: scroll.contentY = …  or  scroll.jumpToLabel(index)
//   // size:  scroll.contentWidth / contentHeight / flickable
//
// @notes
//   Place tall content as children (default property → Flickable).
//   Vertical ScrollBar is AlwaysOn when content overflows; floating label
//   (ElevatedChrome) shows while scrolling / hovering / pressing the bar,
//   or when alwaysShowLabel is true.
//   labels: string[] (even sample) or AnnotatedScrollBarLabel-like
//   { content|text, scrollOffset }. scrollOffset 0..1 or absolute contentY (>=1).

T.Control {
    id: root

    Accessible.role: Accessible.ScrollBar
    Accessible.name: root.currentLabel.length ? root.currentLabel : qsTr("Annotated scroll bar")
    Accessible.description: {
        var parts = []
        if (root.detailLabel.length)
            parts.push(root.detailLabel)
        parts.push(qsTr("Position %1%").arg(Math.round(root.scrollPosition * 100)))
        return parts.join(". ")
    }

    // Default children / content slot (hosted in the inner Flickable)
    default property alias contentData: flick.data
    // Flickable content width
    property alias contentWidth: flick.contentWidth
    // Flickable content height
    property alias contentHeight: flick.contentHeight
    // Flickable content X
    property alias contentX: flick.contentX
    // Flickable content Y — set this (or flickable.contentY) to scroll programmatically
    property alias contentY: flick.contentY
    // Inner Flickable (bounds, contentItem, ScrollBar.vertical, …)
    property alias flickable: flick

    // string[] or [{ content|text, scrollOffset }]
    property var labels: []
    // Percent format when labels is empty (Qt arg: "%1%")
    property string labelFormat: "%1%"
    // Optional secondary line under currentLabel (e.g. chapter detail)
    property string detailLabel: ""
    // Keep the floating scrollbar label visible even when idle
    property bool alwaysShowLabel: false
    // When true, clicking a label marker jumps to that offset
    property bool labelsInteractive: true

    implicitWidth: 200
    implicitHeight: 200
    clip: true

    // Normalized vertical scroll position 0..1
    readonly property real scrollPosition: {
        if (flick.contentHeight <= flick.height)
            return 0
        return flick.contentY / Math.max(1, flick.contentHeight - flick.height)
    }

    readonly property real _maxContentY: Math.max(0, flick.contentHeight - flick.height)

    // Normalized entries: [{ text, offsetNorm, offsetY }]
    readonly property var _labelEntries: {
        var list = []
        if (!labels || !labels.length)
            return list
        var maxY = root._maxContentY
        for (var i = 0; i < labels.length; ++i) {
            var item = labels[i]
            var text = ""
            var offsetY = 0
            var offsetNorm = 0
            if (typeof item === "string" || typeof item === "number") {
                text = "" + item
                offsetNorm = labels.length <= 1 ? 0 : (i / (labels.length - 1))
                offsetY = offsetNorm * maxY
            } else if (item && typeof item === "object") {
                text = "" + (item.content !== undefined ? item.content
                             : (item.text !== undefined ? item.text : ""))
                var raw = item.scrollOffset !== undefined ? Number(item.scrollOffset)
                        : (item.offset !== undefined ? Number(item.offset) : NaN)
                if (!isFinite(raw)) {
                    offsetNorm = labels.length <= 1 ? 0 : (i / (labels.length - 1))
                    offsetY = offsetNorm * maxY
                } else if (raw >= 0 && raw <= 1) {
                    offsetNorm = raw
                    offsetY = raw * maxY
                } else {
                    offsetY = Math.max(0, Math.min(maxY, raw))
                    offsetNorm = maxY > 0 ? offsetY / maxY : 0
                }
            }
            list.push({ text: text, offsetNorm: offsetNorm, offsetY: offsetY })
        }
        return list
    }

    readonly property bool _hasOffsetLabels: {
        if (!labels || !labels.length)
            return false
        for (var i = 0; i < labels.length; ++i) {
            if (labels[i] && typeof labels[i] === "object")
                return true
        }
        return false
    }

    // Index of the nearest label for the current scroll position
    readonly property int activeLabelIndex: {
        var entries = _labelEntries
        if (!entries.length)
            return -1
        if (!_hasOffsetLabels) {
            return Math.min(entries.length - 1,
                            Math.max(0, Math.round(scrollPosition * (entries.length - 1))))
        }
        var best = 0
        var bestDist = Math.abs(scrollPosition - entries[0].offsetNorm)
        for (var i = 1; i < entries.length; ++i) {
            var d = Math.abs(scrollPosition - entries[i].offsetNorm)
            if (d < bestDist) {
                bestDist = d
                best = i
            }
        }
        return best
    }

    // Label for the current scroll position (from labels[] or labelFormat)
    readonly property string currentLabel: {
        var entries = _labelEntries
        if (entries.length > 0 && activeLabelIndex >= 0)
            return entries[activeLabelIndex].text
        return labelFormat.arg(Math.round(scrollPosition * 100))
    }

    // Jump to a label by index
    function jumpToLabel(index) {
        var entries = _labelEntries
        if (index < 0 || index >= entries.length)
            return
        flick.contentY = entries[index].offsetY
    }

    // Scroll so the given normalized 0..1 position is shown
    function scrollToPosition(norm) {
        flick.contentY = Math.max(0, Math.min(_maxContentY, Number(norm) * _maxContentY))
    }

    contentItem: Item {
        Flickable {
            id: flick
            anchors.fill: parent
            anchors.rightMargin: vbar.visible ? vbar.width : 0
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                id: vbar
                // Always show when scrollable so the annotated thumb/label are discoverable
                policy: flick.contentHeight > flick.height
                        ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            }
        }

        // Track markers for offset-based labels
        Repeater {
            model: root._hasOffsetLabels ? root._labelEntries : []
            delegate: Rectangle {
                required property var modelData
                required property int index
                width: 3
                height: 10
                radius: 1.5
                color: index === root.activeLabelIndex ? Theme.accent : Theme.strokeControlStrong
                opacity: vbar.size < 1.0 ? 0.9 : 0
                x: flick.width + Math.max(0, (vbar.width - width) / 2)
                y: {
                    var track = Math.max(0, flick.height - height)
                    return Math.min(track, Math.max(0, modelData.offsetNorm * track))
                }
                visible: opacity > 0.01
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    enabled: root.labelsInteractive
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.jumpToLabel(index)
                }
            }
        }

        ElevatedChrome {
            id: bubble
            z: 2
            width: Math.max(labelCol.implicitWidth + 16, 36)
            height: labelCol.implicitHeight + 12
            radius: Theme.cornerControl
            color: Theme.bgCardElevated
            borderWidth: 1
            borderColor: Theme.strokeCard
            elevation: 4
            shadowOpacity: Theme.dark ? 0.28 : 0.14
            opacity: (root.alwaysShowLabel
                      || vbar.active
                      || vbar.pressed
                      || vbar.hovered
                      || flick.moving
                      || flick.flicking
                      || flick.dragging) && vbar.size < 1.0 ? 1 : 0
            visible: opacity > 0.01
            scale: opacity > 0.5 ? 1 : 0.94

            x: Math.max(0, flick.width - width - 4)
            y: {
                var track = Math.max(0, flick.height - height)
                var handleCenter = vbar.position * flick.height + (vbar.size * flick.height) / 2
                return Math.min(track, Math.max(0, handleCenter - height / 2))
            }

            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingEnter
                }
            }
            Behavior on y {
                enabled: !Theme.reducedMotion && (vbar.active || vbar.pressed || vbar.hovered
                                                  || flick.moving || flick.flicking)
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            Column {
                id: labelCol
                anchors.centerIn: parent
                spacing: 1
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.currentLabel
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }
                Text {
                    visible: root.detailLabel.length > 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.detailLabel
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption - 1
                    color: Theme.textSecondary
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: root.labelsInteractive && root.activeLabelIndex >= 0 && root._hasOffsetLabels
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: root.jumpToLabel(root.activeLabelIndex)
            }
        }
    }

    background: Rectangle {
        color: Theme.bgCard
        border.width: 1
        border.color: Theme.strokeCard
        radius: Theme.cornerControl
    }
}

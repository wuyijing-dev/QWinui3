import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// SelectorBar — Compact horizontal item selector.
//
//   SelectorBar { model: ["All", "Unread"]; currentIndex: 0 }

T.Control {
    id: control

    // Data model / item list for this control
    property var model: []
    // Selected index
    property int currentIndex: 0
    // Selected index alias
    property alias selectedIndex: control.currentIndex
    // "pill" (filled accent) or "underline"
    property string selectionStyle: "pill"
    // Selected state
    signal selected(int index, var item)

    implicitHeight: Theme.controlHeight
    implicitWidth: row.implicitWidth + leftPadding + rightPadding
    padding: 2
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Selector")
    Keys.onLeftPressed: select(Math.max(0, currentIndex - 1))
    Keys.onRightPressed: select(Math.min((model ? model.length : 1) - 1, currentIndex + 1))
    Keys.onHomePressed: select(0)
    Keys.onEndPressed: select((model ? model.length : 1) - 1)

    property bool _indicatorReady: false

    // Select
    function select(index) {
        if (index < 0 || index >= (model ? model.length : 0))
            return
        if (currentIndex === index)
            return
        currentIndex = index
        selected(index, model[index])
    }

    onCurrentIndexChanged: Qt.callLater(function () { moveIndicator(false) })
    onSelectionStyleChanged: Qt.callLater(function () { moveIndicator(true) })
    onModelChanged: {
        _indicatorReady = false
        Qt.callLater(function () { moveIndicator(true) })
    }
    Component.onCompleted: Qt.callLater(function () { moveIndicator(true) })

    // Item At
    function itemAt(index) {
        for (var i = 0; i < row.children.length; ++i) {
            var ch = row.children[i]
            if (ch && ch.segmentIndex === index)
                return ch
        }
        return null
    }

    // Target Geometry
    function targetGeometry(index) {
        var btn = itemAt(index)
        if (!btn)
            return null
        var p = btn.mapToItem(host, 0, 0)
        var g = { x: p.x, y: 0, w: btn.width, h: host.height }

        if (control.selectionStyle === "underline") {
            // Align underline to the centered label/icon row, not the whole segment.
            var content = btn.contentRow
            if (content) {
                var c = content.mapToItem(host, 0, 0)
                g.w = Math.max(24, content.width)
                g.x = c.x
            } else {
                var contentW = Math.min(btn.width - 16, Math.max(24, btn._labelWidth))
                g.w = contentW
                g.x = p.x + (btn.width - contentW) / 2
            }
            g.h = 3
            g.y = host.height - g.h - 1
        }
        return g
    }

    // Move Indicator
    function moveIndicator(instant) {
        var g = targetGeometry(control.currentIndex)
        if (!g || host.height <= 0) {
            indicator.opacity = 0
            return
        }

        slideAnim.stop()

        var shouldAnimate = !instant && _indicatorReady && !Theme.reducedMotion
                && indicator.opacity > 0.5

        if (!shouldAnimate) {
            indicator.x = g.x
            indicator.y = g.y
            indicator.width = Math.max(1, g.w)
            indicator.height = Math.max(1, g.h)
            indicator.opacity = 1
            indicator.scale = 1
            _indicatorReady = true
            return
        }

        animX.from = indicator.x
        animX.to = g.x
        animY.from = indicator.y
        animY.to = g.y
        animW.from = indicator.width
        animW.to = Math.max(1, g.w)
        animH.from = indicator.height
        animH.to = Math.max(1, g.h)
        slideAnim.start()
    }

    function syncIndicatorIfIdle() {
        if (slideAnim.running)
            return
        moveIndicator(true)
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.bgAcrylic
        border.width: 1
        border.color: Theme.strokeDivider
    }

    contentItem: Item {
        id: host
        implicitWidth: row.implicitWidth
        implicitHeight: Theme.controlHeight - 4

        Rectangle {
            id: indicator
            z: 0
            radius: control.selectionStyle === "underline" ? 1.5 : (Theme.cornerControl - 1)
            color: Theme.accent
            opacity: 0
            transformOrigin: Item.Center
        }

        ParallelAnimation {
            id: slideAnim
            onStarted: {
                if (control.selectionStyle === "pill")
                    scaleKick.start()
            }
            onStopped: indicator.scale = 1

            NumberAnimation {
                id: animX
                target: indicator
                property: "x"
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
            NumberAnimation {
                id: animY
                target: indicator
                property: "y"
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
            NumberAnimation {
                id: animW
                target: indicator
                property: "width"
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
            NumberAnimation {
                id: animH
                target: indicator
                property: "height"
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        SequentialAnimation {
            id: scaleKick
            running: false
            NumberAnimation {
                target: indicator
                property: "scale"
                to: 1.06
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
            NumberAnimation {
                target: indicator
                property: "scale"
                to: 1.0
                duration: Theme.duration(Theme.motionNormal)
                easing.type: Theme.easingStandard
            }
        }

        Row {
            id: row
            z: 1
            spacing: 2
            height: parent.height
            onWidthChanged: Qt.callLater(control.syncIndicatorIfIdle)
            onHeightChanged: Qt.callLater(control.syncIndicatorIfIdle)

            Repeater {
                model: control.model

                AbstractButton {
                    id: itemBtn
                    required property var modelData
                    required property int index
                    // Active segment index
                    property int segmentIndex: index
                    // Content Row
                    property alias contentRow: contentRow
                    property real _labelWidth: contentRow.implicitWidth

                    // Kill default AbstractButton padding so icon+text sit in the true center.
                    padding: 0
                    leftPadding: 0
                    rightPadding: 0
                    topPadding: 0
                    bottomPadding: 0
                    leftInset: 0
                    rightInset: 0
                    topInset: 0
                    bottomInset: 0

                    height: row.height
                    width: Math.max(64, Math.ceil(contentRow.implicitWidth + 24))
                    hoverEnabled: true
                    checkable: true
                    checked: index === control.currentIndex
                    onClicked: {
                        if (control.currentIndex === index)
                            return
                        control.currentIndex = index
                        control.selected(index, modelData)
                    }

                    readonly property string _title: typeof modelData === "string"
                            ? modelData : (modelData.title || modelData.text || "")
                    readonly property string _icon: {
                        if (typeof modelData !== "object" || !modelData)
                            return ""
                        return IconSource.resolve(modelData.symbol || "",
                                                  modelData.icon || modelData.glyph || "")
                    }

                    contentItem: Item {
                        // Fill the button hit area; center the label row inside.
                        implicitWidth: contentRow.implicitWidth
                        implicitHeight: contentRow.implicitHeight

                        Row {
                            id: contentRow
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                id: iconLabel
                                anchors.verticalCenter: parent.verticalCenter
                                visible: itemBtn._icon.length > 0
                                width: visible ? implicitWidth : 0
                                text: itemBtn._icon
                                font.family: Theme.fontFamilyIcon
                                font.pixelSize: 14
                                color: {
                                    if (control.selectionStyle === "underline")
                                        return itemBtn.checked ? Theme.accent : Theme.textSecondary
                                    return itemBtn.checked ? Theme.textOnAccent
                                         : (control.enabled ? Theme.textPrimary : Theme.textDisabled)
                                }
                                Behavior on color {
                                    enabled: !Theme.reducedMotion
                                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                                }
                            }
                            Text {
                                id: titleLabel
                                anchors.verticalCenter: parent.verticalCenter
                                text: itemBtn._title
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontBody
                                // Fixed weight avoids width jitter; selected state uses color/indicator.
                                font.weight: Theme.fontWeightSemiBold
                                opacity: itemBtn.checked ? 1 : 0.92
                                color: {
                                    if (control.selectionStyle === "underline")
                                        return itemBtn.checked ? Theme.textPrimary : Theme.textSecondary
                                    return itemBtn.checked ? Theme.textOnAccent
                                         : (control.enabled ? Theme.textPrimary : Theme.textDisabled)
                                }
                                Behavior on color {
                                    enabled: !Theme.reducedMotion
                                    ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                                }
                            }
                        }
                    }

                    background: Rectangle {
                        radius: Theme.cornerControl - 1
                        color: {
                            if (itemBtn.checked)
                                return "transparent"
                            if (itemBtn.down)
                                return Theme.fillSubtleTertiary
                            if (itemBtn.hovered)
                                return Theme.fillSubtle
                            return "transparent"
                        }
                        border.width: itemBtn.visualFocus ? 1 : 0
                        border.color: Theme.focusOuter
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                    }

                    onWidthChanged: Qt.callLater(control.syncIndicatorIfIdle)
                }
            }
        }
    }
}

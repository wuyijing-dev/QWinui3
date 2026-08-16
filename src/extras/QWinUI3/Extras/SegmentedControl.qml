import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// SegmentedControl — Mutually exclusive segment buttons.
//
//   SegmentedControl {
//       id: segmentedControl
//       model: ["Day", "Week", "Month"]
//       currentIndex: 0
//   }
//
//   // --- API ---
//   // signals: onSelected, onSelectionChanged
//   // methods: select(index), itemAt(index), moveIndicator(instant), syncIndicatorIfIdle(), nextEnabled(from, delta)
//   // segmentedControl.select(index)
//   // segmentedControl.itemAt(index)
//   // segmentedControl.moveIndicator(instant)
//   // segmentedControl.syncIndicatorIfIdle()
//
// @notes
//   Exclusive segment buttons from model; currentIndex selection.

T.Control {
    id: control

    // Data model / item list for this control
    property var model: []
    // Selected index
    property int currentIndex: 0
    // Selected index alias
    property alias selectedIndex: control.currentIndex
    // Currently selected model item (WinUI SelectedItem)
    readonly property var selectedItem: {
        if (!model || currentIndex < 0 || currentIndex >= model.length)
            return null
        return model[currentIndex]
    }
    // Stretch factor / stretch pip
    property bool stretch: false
    // Force equal-width segments
    property bool equalWidth: stretch
    // Selected state
    signal selected(int index, var item)
    // Selection changed
    signal selectionChanged(int index)

    property bool _indicatorReady: false

    onCurrentIndexChanged: {
        selectionChanged(currentIndex)
        Qt.callLater(function () { moveIndicator(false) })
    }
    onModelChanged: {
        _indicatorReady = false
        Qt.callLater(function () { moveIndicator(true) })
    }
    Component.onCompleted: Qt.callLater(function () { moveIndicator(true) })

    // Select item by index
    function select(index) {
        if (index < 0 || index >= (model ? model.length : 0))
            return
        var item = model[index]
        if (typeof item !== "string" && item && item.enabled === false)
            return
        if (currentIndex === index)
            return
        currentIndex = index
        selected(index, item)
    }

    // Item at the given index
    function itemAt(index) {
        for (var i = 0; i < row.children.length; ++i) {
            var ch = row.children[i]
            if (ch && ch.segmentIndex === index)
                return ch
        }
        return null
    }

    // Move selection indicator to index
    function moveIndicator(instant) {
        var btn = itemAt(control.currentIndex)
        if (!btn || host.height <= 0) {
            indicator.opacity = 0
            return
        }
        var p = btn.mapToItem(host, 0, 0)
        slideAnim.stop()
        var shouldAnimate = !instant && _indicatorReady && !Theme.reducedMotion
                && indicator.opacity > 0.5
        if (!shouldAnimate) {
            indicator.x = p.x
            indicator.y = p.y
            indicator.width = Math.max(1, btn.width)
            indicator.height = Math.max(1, btn.height)
            indicator.opacity = 1
            _indicatorReady = true
            return
        }
        animX.from = indicator.x
        animX.to = p.x
        animY.from = indicator.y
        animY.to = p.y
        animW.from = indicator.width
        animW.to = Math.max(1, btn.width)
        animH.from = indicator.height
        animH.to = Math.max(1, btn.height)
        slideAnim.start()
    }

    // Sync selection indicator when idle
    function syncIndicatorIfIdle() {
        if (slideAnim.running)
            return
        moveIndicator(true)
    }

    // True when next is available
    function nextEnabled(from, delta) {
        var n = model ? model.length : 0
        if (n <= 0)
            return from
        var i = from
        for (var step = 0; step < n; ++step) {
            i = (i + delta + n) % n
            var item = model[i]
            if (typeof item === "string" || !item || item.enabled !== false)
                return i
        }
        return from
    }

    implicitWidth: stretch ? 240 : (row.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Theme.controlHeight
    padding: 3
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Keys.onLeftPressed: select(nextEnabled(currentIndex, -1))
    Keys.onRightPressed: select(nextEnabled(currentIndex, 1))
    Keys.onUpPressed: select(nextEnabled(currentIndex, -1))
    Keys.onDownPressed: select(nextEnabled(currentIndex, 1))
    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Segmented control")

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: control.activeFocus ? Theme.accent : Theme.strokeCard
        Behavior on border.color {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }

    contentItem: Item {
        id: host
        implicitWidth: row.implicitWidth
        implicitHeight: Theme.controlHeight - 6

        Rectangle {
            id: indicator
            z: 0
            radius: Theme.cornerControl - 1
            color: Theme.bgCard
            border.width: 1
            border.color: Theme.strokeCard
            opacity: 0
        }

        ParallelAnimation {
            id: slideAnim
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

        RowLayout {
            id: row
            z: 1
            anchors.fill: parent
            spacing: 2
            onWidthChanged: Qt.callLater(control.syncIndicatorIfIdle)
            onHeightChanged: Qt.callLater(control.syncIndicatorIfIdle)

            Repeater {
                model: control.model
                AbstractButton {
                    id: seg
                    required property var modelData
                    required property int index
                    // Active segment index
                    readonly property int segmentIndex: index
                    enabled: typeof modelData === "string" ? true
                             : (modelData.enabled === undefined ? true : !!modelData.enabled)
                    Layout.fillWidth: control.stretch
                    Layout.fillHeight: true
                    Layout.preferredWidth: control.stretch ? -1
                        : Math.max(64, contentItem.implicitWidth + 20)
                    checkable: true
                    checked: index === control.currentIndex
                    hoverEnabled: true
                    focusPolicy: Qt.NoFocus
                    onClicked: {
                        control.currentIndex = index
                        control.selected(index, modelData)
                    }
                    Accessible.role: Accessible.PageTab
                    Accessible.name: typeof modelData === "string"
                                     ? modelData
                                     : (modelData.text || modelData.title || "")
                    Accessible.checkable: true
                    Accessible.checked: checked

                    contentItem: RowLayout {
                        spacing: 6
                        readonly property string _glyph: typeof modelData === "string"
                            ? ""
                            : IconSource.resolve(modelData.symbol || "",
                                                 modelData.icon || modelData.glyph || "")
                        Text {
                            visible: parent._glyph.length > 0
                            text: parent._glyph
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 14
                            color: seg.checked ? Theme.textPrimary : Theme.textSecondary
                            Layout.leftMargin: 8
                            Behavior on color {
                                enabled: !Theme.reducedMotion
                                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                        }
                        Text {
                            Layout.fillWidth: control.stretch
                            Layout.leftMargin: parent._glyph.length ? 0 : 10
                            Layout.rightMargin: 10
                            text: typeof modelData === "string" ? modelData : (modelData.text || modelData.title || "")
                            font.family: control.font.family
                            font.pixelSize: control.font.pixelSize
                            font.weight: seg.checked ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                            color: control.enabled
                                 ? (seg.checked ? Theme.textPrimary : Theme.textSecondary)
                                 : Theme.textDisabled
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            Behavior on color {
                                enabled: !Theme.reducedMotion
                                ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                            }
                        }
                    }

                    background: Rectangle {
                        radius: Theme.cornerControl - 1
                        color: {
                            if (seg.checked)
                                return "transparent"
                            if (seg.hovered)
                                return Theme.fillSubtleSecondary
                            return "transparent"
                        }
                        Behavior on color {
                            enabled: !Theme.reducedMotion
                            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
                        }
                    }
                }
            }
        }
    }
}

import QtQuick
import QWinUI3.Theme

// SelectionPip — Navigation selection pip indicator.
//
//   SelectionPip {
//       id: selectionPip
//      
//   }
//
//   // --- API ---
//   // methods: snapTo(index), animateTo(index)
//   // selectionPip.snapTo(index)
//   // selectionPip.animateTo(index)
//
// @notes
//   Style-only Fluent chrome for Qt Quick Controls SelectionPip.
//   Public API is the Qt Quick Controls SelectionPip type; this file supplies visuals/metrics only.

Item {
    id: root

    Accessible.ignored: true

    // ListView this pip tracks
    property var listView: null
    // Index the pip should track
    property int targetIndex: -1
    // Pip rest height
    property real baseHeight: 16
    // Pip left inset
    property real leftMargin: 4
    // Skip motion when true
    property bool instant: false

    anchors.fill: parent
    visible: opacity > 0.01
    opacity: targetIndex >= 0 ? 1 : 0
    z: 2
    clip: true

    Rectangle {
        id: pip
        width: 3
        radius: 1.5
        color: Theme.accent
        x: root.leftMargin

        // Scroll animation start
        property real contentFromY: 0
        // Scroll animation end
        property real contentToY: 0
        // 0..1 animation / progress
        property real progress: 1
        // True when the control is ready
        property bool ready: false

        // Eased 0..1 animation progress
        readonly property real eased: {
            var t = progress
            return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2
        }
        // Absolute travel distance for the pip
        readonly property real travel: Math.abs(contentToY - contentFromY)
        // Stretch factor / stretch pip
        readonly property real stretch: Math.min(36, Math.max(10, travel * 0.45))
        // Animated content center Y
        readonly property real contentCenterY: contentFromY
                                              + (contentToY - contentFromY) * eased
                                              + baseHeight * 0.5
        // Current visual height (stretch / animation)
        readonly property real visualHeight: baseHeight + stretch * Math.sin(Math.PI * progress)
        // Flickable content Y
        readonly property real contentY: listView ? listView.contentY : 0

        height: visualHeight
        y: contentCenterY - visualHeight * 0.5 - contentY

        NumberAnimation on progress {
            id: pipAnim
            from: 0
            to: 1
            duration: Theme.reducedMotion ? 1 : 333
            easing.type: Easing.Linear
            running: false
        }

        // contentY that scrolls index into view
        function contentYForIndex(index) {
            if (!listView || index < 0)
                return -1
            var item = listView.itemAtIndex(index)
            if (!item)
                return -1
            return item.y + (item.height - baseHeight) * 0.5
        }

        // Current Flickable contentY
        function currentContentY() {
            if (progress >= 1)
                return contentToY
            return contentFromY + (contentToY - contentFromY) * eased
        }

        // Move to the given index / position
        function moveTo(index, forceInstant, retries) {
            if (retries === undefined)
                retries = 0
            if (index < 0) {
                ready = true
                return
            }
            var target = contentYForIndex(index)
            if (target < 0) {
                // ListView item may not be created yet — retry with an explicit
                // pip reference (bare moveTo is null inside Qt.callLater).
                if (retries < 12) {
                    Qt.callLater(function () {
                        if (pip)
                            pip.moveTo(index, forceInstant, retries + 1)
                    })
                }
                return
            }
            if (!ready || forceInstant || root.instant || Theme.reducedMotion) {
                pipAnim.stop()
                contentFromY = target
                contentToY = target
                progress = 1
                ready = true
                return
            }
            if (Math.abs(target - contentToY) < 0.5 && progress >= 1)
                return
            pipAnim.stop()
            contentFromY = currentContentY()
            contentToY = target
            progress = 0
            pipAnim.start()
            ready = true
        }
    }

    onTargetIndexChanged: Qt.callLater(function () {
        if (pip)
            pip.moveTo(root.targetIndex, false)
    })

    Connections {
        target: root.listView
        function onContentYChanged() { /* y binding reacts */ }
        function onHeightChanged() {
            if (pip)
                pip.moveTo(root.targetIndex, true)
        }
        function onCountChanged() {
            Qt.callLater(function () {
                if (pip)
                    pip.moveTo(root.targetIndex, true)
            })
        }
    }

    Component.onCompleted: Qt.callLater(function () {
        if (pip)
            pip.moveTo(root.targetIndex, true)
    })

    // Snap the selection pip instantly
    function snapTo(index) {
        if (pip)
            pip.moveTo(index, true)
    }

    // Animate the selection pip to the target
    function animateTo(index) {
        if (pip)
            pip.moveTo(index, false)
    }
}

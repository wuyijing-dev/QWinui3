import QtQuick
import QWinUI3.Theme

// SelectionPip — Navigation selection pip indicator.
//
//   SelectionPip { }

Item {
    id: root

    property var listView: null
    property int targetIndex: -1
    property real baseHeight: 16
    property real leftMargin: 4
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

        property real contentFromY: 0
        property real contentToY: 0
        property real progress: 1
        property bool ready: false

        readonly property real eased: {
            var t = progress
            return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2
        }
        readonly property real travel: Math.abs(contentToY - contentFromY)
        readonly property real stretch: Math.min(36, Math.max(10, travel * 0.45))
        readonly property real contentCenterY: contentFromY
                                              + (contentToY - contentFromY) * eased
                                              + baseHeight * 0.5
        readonly property real visualHeight: baseHeight + stretch * Math.sin(Math.PI * progress)
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

        function contentYForIndex(index) {
            if (!listView || index < 0)
                return -1
            var item = listView.itemAtIndex(index)
            if (!item)
                return -1
            return item.y + (item.height - baseHeight) * 0.5
        }

        function currentContentY() {
            if (progress >= 1)
                return contentToY
            return contentFromY + (contentToY - contentFromY) * eased
        }

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

    function snapTo(index) {
        if (pip)
            pip.moveTo(index, true)
    }

    function animateTo(index) {
        if (pip)
            pip.moveTo(index, false)
    }
}

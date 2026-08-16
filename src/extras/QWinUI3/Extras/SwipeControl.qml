import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// SwipeControl — Swipe-to-reveal actions on content.
//
//   SwipeControl {
//       id: swipeControl
//       SwipeAction { text: qsTr("Delete") }
//       ListTile { title: qsTr("Row") }
//   }
//
//   // --- API ---
//   // signals: onOpened, onClosed
//   // methods: close(), openLeft(), openRight()
//   // swipeControl.close()
//   // swipeControl.openLeft()
//   // swipeControl.openRight()
//
// @notes
//   Content + left/right SwipeAction reveal; openLeft/openRight/close.
//   swipeMode: reveal | execute (WinUI SwipeMode).

T.Control {
    id: root

    // Swipe content closed
    readonly property int closed: 0
    // Left actions revealed
    readonly property int leftOpen: 1
    // Right actions revealed
    readonly property int rightOpen: 2

    // Content slot / children host
    property alias content: contentSlot.data
    // Actions on the left
    property alias leftActions: leftRow.data
    // Actions on the right
    property alias rightActions: rightRow.data
    // Width of each swipe action
    property real actionWidth: 72
    // Drag distance to snap open
    property real revealThreshold: 36
    // Open / visible state
    readonly property bool isOpen: openMode !== closed
    // single | multiple reveal mode
    property int openMode: closed
    // WinUI SwipeMode: reveal | execute
    property string swipeMode: "reveal"

    // Emitted when opened
    signal opened(int mode)
    // Swipe content closed
    signal closed()

    implicitWidth: 320
    implicitHeight: Math.max(Theme.navItemHeight + 8, contentSlot.implicitHeight + 16)
    padding: 0
    clip: true
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.ListItem
    Accessible.name: qsTr("Swipe item")
    Accessible.description: isOpen ? qsTr("Actions revealed") : qsTr("Swipe for actions")
    Keys.onEscapePressed: close()
    Keys.onLeftPressed: openRight()
    Keys.onRightPressed: openLeft()

    // Max left swipe reveal width
    readonly property real maxLeftReveal: Math.max(0, leftRow.children.length * actionWidth)
    // Max right swipe reveal width
    readonly property real maxRightReveal: Math.max(0, rightRow.children.length * actionWidth)
    readonly property bool _executeMode: String(swipeMode).toLowerCase() === "execute"

    // Close / dismiss
    function close() {
        panel.x = 0
        if (openMode !== closed) {
            openMode = closed
            closed()
        }
    }
    // Reveal left swipe actions
    function openLeft() {
        if (maxLeftReveal <= 0) {
            close()
            return
        }
        panel.x = maxLeftReveal
        if (openMode !== leftOpen) {
            openMode = leftOpen
            opened(leftOpen)
        }
    }
    // Reveal right swipe actions
    function openRight() {
        if (maxRightReveal <= 0) {
            close()
            return
        }
        panel.x = -maxRightReveal
        if (openMode !== rightOpen) {
            openMode = rightOpen
            opened(rightOpen)
        }
    }

    function _firstAction(row) {
        for (var i = 0; i < row.children.length; ++i) {
            var ch = row.children[i]
            if (ch && typeof ch.invoke === "function")
                return ch
        }
        return null
    }

    // Apply BehaviorOnInvoked after an action runs
    function _afterActionInvoked(action) {
        if (!action)
            return
        var b = String(action.behaviorOnInvoked || "auto").toLowerCase()
        var shouldClose = false
        if (b === "close")
            shouldClose = true
        else if (b === "remainopen")
            shouldClose = false
        else
            shouldClose = !_executeMode // auto: close in reveal, remain in execute
        if (shouldClose)
            close()
    }

    // Wire SwipeAction.swipeControl (no action parent-walk)
    function _wireActions(row) {
        if (!row)
            return
        var kids = row.children || []
        for (var i = 0; i < kids.length; ++i) {
            var ch = kids[i]
            if (ch && ch.hasOwnProperty("swipeControl"))
                ch.swipeControl = root
        }
    }

    function _wireAllActions() {
        _wireActions(leftRow)
        _wireActions(rightRow)
    }

    Component.onCompleted: _wireAllActions()

    function _handleDragReleased() {
        if (_executeMode) {
            if (panel.x > revealThreshold) {
                var left = _firstAction(leftRow)
                if (left)
                    left.invoke()
                else
                    close()
            } else if (panel.x < -revealThreshold) {
                var right = _firstAction(rightRow)
                if (right)
                    right.invoke()
                else
                    close()
            } else {
                close()
            }
            return
        }
        if (panel.x > revealThreshold)
            openLeft()
        else if (panel.x < -revealThreshold)
            openRight()
        else
            close()
    }

    contentItem: Item {
        Row {
            id: leftRow
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            z: 0
            onChildrenChanged: root._wireActions(leftRow)
        }

        Row {
            id: rightRow
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            layoutDirection: Qt.RightToLeft
            z: 0
            onChildrenChanged: root._wireActions(rightRow)
        }

        Item {
            id: panel
            width: parent.width
            height: parent.height
            z: 1

            Behavior on x {
                enabled: !drag.active && !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }

            ElevatedChrome {
                anchors.fill: parent
                color: Theme.bgCard
                borderWidth: root.activeFocus ? 2 : 1
                borderColor: root.activeFocus ? Theme.focusOuter : Theme.strokeCard
                radius: Theme.cornerControl
                elevation: drag.active ? 4 : 2
                shadowOpacity: Theme.dark ? 0.2 : 0.1
                scale: drag.active && !Theme.reducedMotion ? 0.995 : 1
                Behavior on scale {
                    enabled: !Theme.reducedMotion
                    NumberAnimation { duration: Theme.duration(Theme.motionFast) }
                }
            }

            Item {
                id: contentSlot
                anchors.fill: parent
                anchors.margins: 12
                implicitHeight: childrenRect.height
                z: 1
            }

            DragHandler {
                id: drag
                target: panel
                xAxis.enabled: true
                yAxis.enabled: false
                xAxis.minimum: -root.maxRightReveal
                xAxis.maximum: root.maxLeftReveal
                onActiveChanged: {
                    if (active)
                        return
                    root._handleDragReleased()
                }
            }
        }
    }

    background: Item {}
}

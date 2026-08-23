import QtQuick
import QWinUI3.Theme

// SwipeAction — Action revealed by SwipeControl.
//
//   SwipeControl {
//       SwipeAction {
//           text: qsTr("Delete")
//           symbol: FluentIcons.Delete
//           behaviorOnInvoked: "close"
//           onTriggered: remove()
//       }
//       Label { text: qsTr("Row") }
//   }
//
// @notes
//   Action revealed by SwipeControl; text/symbol + onTriggered.
//   behaviorOnInvoked: auto | close | remainOpen (WinUI SwipeBehaviorOnInvoked).

Item {
    id: root

    // Display / input text
    property string text: qsTr("Delete")
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Primary color
    property color color: Theme.dark ? "#C42B1C" : Theme.systemCritical
    // Badge / content text color
    property color textColor: "#FFFFFF"
    // Leading content slot
    property bool leading: false
    // WinUI BehaviorOnInvoked: auto | close | remainOpen
    property string behaviorOnInvoked: "auto"

    // Resolved glyph string
    readonly property string effectiveGlyph: IconSource.resolve(symbol, iconGlyph)

    // Emitted when the action is invoked (preferred)
    signal triggered()
    // Emitted when clicked (alias of triggered for older demos)
    signal clicked()

    width: Math.max(88, contentCol.implicitWidth + 28)
    height: parent ? parent.height : Theme.navItemHeight
    clip: true
    Accessible.role: Accessible.Button
    Accessible.name: text

    // Host SwipeControl (wired by SwipeControl — no parent walk)
    property var swipeControl: null

    // Invoke this action (also used by SwipeControl execute mode)
    function invoke() {
        triggered()
        clicked()
        if (swipeControl && typeof swipeControl._afterActionInvoked === "function")
            swipeControl._afterActionInvoked(root)
    }

    Rectangle {
        anchors.fill: parent
        color: root.color
        topLeftRadius: root.leading ? Theme.cornerControl : 0
        bottomLeftRadius: root.leading ? Theme.cornerControl : 0
        topRightRadius: root.leading ? 0 : Theme.cornerControl
        bottomRightRadius: root.leading ? 0 : Theme.cornerControl
        scale: tap.pressed && !Theme.reducedMotion ? 0.97 : 1
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }

        TapHandler {
            id: tap
            onTapped: root.invoke()
        }

        // SwipeDelegate reveals the content-adjacent edge of the action first.
        // Pin labels to that edge with a margin so "Flag" does not collide with
        // the row title (e.g. "Archive") during a partial swipe.
        Column {
            id: contentCol
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: root.leading ? parent.right : undefined
            anchors.left: root.leading ? undefined : parent.left
            anchors.rightMargin: root.leading ? 12 : 0
            anchors.leftMargin: root.leading ? 0 : 12
            spacing: 4

            Text {
                visible: root.effectiveGlyph.length > 0
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.effectiveGlyph
                color: root.textColor
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 16
            }
            Text {
                id: label
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.text
                color: root.textColor
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}

import QtQuick
import QWinUI3.Theme

// Action panel for SwipeDelegate — use as swipe.left / swipe.right.
// Must have an explicit width so Qt places it on the correct edge.
Item {
    id: root

    property string text: qsTr("Delete")
    property string iconGlyph: ""
    property color color: Theme.dark ? "#C42B1C" : Theme.systemCritical
    property color textColor: "#FFFFFF"
    // Leading (left) vs trailing (right) corner rounding.
    property bool leading: false

    signal clicked()

    width: Math.max(88, contentCol.implicitWidth + 28)
    height: parent ? parent.height : Theme.navItemHeight

    Rectangle {
        anchors.fill: parent
        color: root.color
        topLeftRadius: root.leading ? Theme.cornerControl : 0
        bottomLeftRadius: root.leading ? Theme.cornerControl : 0
        topRightRadius: root.leading ? 0 : Theme.cornerControl
        bottomRightRadius: root.leading ? 0 : Theme.cornerControl
        scale: tap.pressed ? 0.97 : 1
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }

        TapHandler {
            id: tap
            onTapped: root.clicked()
        }

        Column {
            id: contentCol
            anchors.centerIn: parent
            spacing: 4

            Text {
                visible: root.iconGlyph.length > 0
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.iconGlyph
                color: root.textColor
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 16
            }
            Text {
                id: label
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.text
                color: root.textColor
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}

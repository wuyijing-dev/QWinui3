import QtQuick
import QWinUI3.Theme

// Action panel for SwipeDelegate — use as swipe.left / swipe.right.
Item {
    id: root

    property string text: qsTr("Delete")
    property var symbol: ""
    property string iconGlyph: ""
    property color color: Theme.dark ? "#C42B1C" : Theme.systemCritical
    property color textColor: "#FFFFFF"
    property bool leading: false

    readonly property string effectiveGlyph: IconSource.resolve(symbol, iconGlyph)

    signal clicked()

    width: Math.max(88, contentCol.implicitWidth + 28)
    height: parent ? parent.height : Theme.navItemHeight
    Accessible.role: Accessible.Button
    Accessible.name: text

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
            onTapped: root.clicked()
        }

        Column {
            id: contentCol
            anchors.centerIn: parent
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
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}

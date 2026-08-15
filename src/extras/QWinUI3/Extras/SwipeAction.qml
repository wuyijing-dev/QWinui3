import QtQuick
import QWinUI3.Theme

// SwipeAction — Action revealed by SwipeControl.
//
//   SwipeAction { text: qsTr("Delete"); onTriggered: remove() }
//
//   // --- API ---
//   // signals: onClicked

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

    // Resolved glyph string
    readonly property string effectiveGlyph: IconSource.resolve(symbol, iconGlyph)

    // Emitted when clicked
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

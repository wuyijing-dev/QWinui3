import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Platform

// Frosted panel. On Windows with window acrylic/mica, keep fill translucent so
// the real desktop blur shows through. Elevated mode adds a stronger card tint.
T.Pane {
    id: root

    property bool elevated: false
    property bool bordered: true
    property bool showLuminantEdge: true
    property real cornerRadius: Theme.cornerCard
    property color tintColor: elevated ? Theme.bgCardElevated : Theme.bgAcrylic
    property real frostOpacity: {
        if (!WindowHelper.customFrame)
            return 1
        switch (WindowHelper.backdrop) {
        case WindowHelper.BackdropSolid:
        case WindowHelper.BackdropNone:
            return 1
        case WindowHelper.BackdropTransparent:
            return elevated ? (Theme.dark ? 0.45 : 0.65) : (Theme.dark ? 0.32 : 0.50)
        case WindowHelper.BackdropAcrylic:
            return elevated ? (Theme.dark ? 0.62 : 0.82) : (Theme.dark ? 0.48 : 0.72)
        default:
            return elevated ? (Theme.dark ? 0.68 : 0.88) : (Theme.dark ? 0.55 : 0.80)
        }
    }

    padding: Theme.spacingLoose
    implicitWidth: 280
    implicitHeight: 160

    background: ElevatedChrome {
        color: Qt.rgba(root.tintColor.r, root.tintColor.g, root.tintColor.b, root.frostOpacity)
        radius: root.cornerRadius
        borderWidth: root.bordered ? 1 : 0
        borderColor: Theme.strokeCard
        elevated: root.elevated
        elevation: 4
        shadowOpacity: Theme.dark ? 0.28 : 0.10

        Rectangle {
            visible: root.showLuminantEdge
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 1
            height: 1
            radius: 1
            color: Theme.dark ? "#18FFFFFF" : "#22FFFFFF"
            opacity: 0.8
        }
    }
}

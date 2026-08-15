import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme
import QWinUI3.Platform

// AcrylicSurface — Frosted pane; keep translucent under system Mica/Acrylic.
//
//   AcrylicSurface {
//       id: pane
//       anchors.fill: parent
//       elevated: true
//       tintOpacity: 0.8
//       Label { anchors.centerIn: parent; text: qsTr("Frosted") }
//   }
//   // --- API ---
//   // pane.elevated / tintOpacity
//   // children fill the acrylic surface

T.Pane {
    id: root

    // Stronger elevation / card tint
    property bool elevated: false
    // Draw a border when true
    property bool bordered: true
    // Show luminant edge highlight
    property bool showLuminantEdge: true
    // Corner radius
    property real cornerRadius: Theme.cornerCard
    // Tint overlay color
    property color tintColor: elevated ? Theme.bgCardElevated : Theme.bgAcrylic
    // Frost overlay opacity
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
    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Acrylic surface")

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

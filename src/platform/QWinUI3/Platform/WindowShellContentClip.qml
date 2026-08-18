import QtQuick
import QWinUI3.Platform

// WindowShellContentClip — inset / clip helper for Linux client-shell bottom corners.
//
//   WindowShellContentClip {
//       targetWindow: window
//       Page { anchors.fill: parent }
//   }
//
// When clientShellDecoration is active and the window is not maximized, applies side/bottom
// insets equal to shellCornerRadius() so content does not bleed through rounded frame corners.
// Prefer this wrapper for full-bleed pages (NavigationView, ListView backgrounds).

Item {
    id: root

    property var targetWindow: null

    default property alias content: host.data

    readonly property bool clipActive: WindowHelper.clientShellDecoration
                                      && targetWindow
                                      && WindowHelper.shellChromeExpanded(targetWindow)
    readonly property real contentInset: clipActive ? WindowHelper.shellCornerRadius() : 0

    clip: clipActive

    Item {
        id: host
        anchors.fill: parent
        anchors.leftMargin: root.contentInset
        anchors.rightMargin: root.contentInset
        anchors.bottomMargin: root.contentInset
    }
}

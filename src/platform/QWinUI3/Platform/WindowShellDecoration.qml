import QtQuick
import QtQuick.Effects
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// WindowShellDecoration — Linux / Wayland client shell: DWM-like shadow + rounded frame.
//
// Used as ApplicationWindow.background when WindowHelper.clientShellDecoration is true.
// Windows uses native DWM; this is the cross-compositor fallback.

Item {
    id: root

    property var targetWindow: null

    readonly property bool active: WindowHelper.clientShellDecoration
    readonly property bool expanded: active && targetWindow
                                     && WindowHelper.shellChromeExpanded(targetWindow)
    readonly property real cornerRadius: expanded ? WindowHelper.shellCornerRadius() : 0
    readonly property bool showShadow: expanded && !Theme.reducedMotion
            && WindowHelper.shellShadowOpacity() > 0.001
    readonly property color frameFill: Theme.bgLayer
    readonly property color frameBorder: Theme.strokeDivider
    readonly property real shadowOpacity: WindowHelper.shellShadowOpacity()
    readonly property real shadowBlur: WindowHelper.shellShadowBlur()
    readonly property real shadowVerticalOffset: WindowHelper.shellShadowVerticalOffset()

    property bool _shadowReady: false

    Component.onCompleted: Qt.callLater(function () {
        if (root)
            root._shadowReady = true
    })

    Rectangle {
        id: frame
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.frameFill
        border.width: root.cornerRadius > 0 ? Math.max(1, Theme.strokeHairline) : 0
        border.color: root.frameBorder
        antialiasing: true
        layer.enabled: root.showShadow && root._shadowReady
        layer.smooth: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: root.shadowBlur
            shadowOpacity: root.shadowOpacity
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: root.shadowVerticalOffset
            blurMax: 44
            autoPaddingEnabled: true
        }
    }

    // Reduced-motion fallback: flat rim instead of MultiEffect shadow
    Rectangle {
        anchors.fill: frame
        anchors.topMargin: 2
        visible: root.active && root.expanded && Theme.reducedMotion
        radius: frame.radius
        color: Theme.dark ? "#44000000" : "#33000000"
        z: -1
    }
}

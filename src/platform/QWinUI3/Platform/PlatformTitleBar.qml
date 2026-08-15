import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// PlatformTitleBar — Caption buttons + drag region + TitleBar host.
//
//   PlatformTitleBar {
//       targetWindow: window
//       TitleBar { embedded: true; title: qsTr("App") }
//   }

Item {
    id: root

    // Window this chrome is attached to
    property var targetWindow: null
    // Show caption buttons
    property bool showCaptionButtons: WindowHelper.customFrame
    // Show minimize
    property bool showMinimize: true
    // Show maximize
    property bool showMaximize: true
    // Show close
    property bool showClose: true
    // Title bar height option
    property int preferredHeightOption: WindowHelper.TitleBarHeightTall
    // Use native NC hit-testing
    readonly property bool useNativeChrome: WindowHelper.nativeChrome && showCaptionButtons
    // Resolved caption button height
    readonly property real resolvedCaptionHeight: WindowHelper.titleBarHeightForOption(preferredHeightOption)
    // Title content slot
    default property alias titleContent: contentHost.data

    // Caption button row height
    property real captionHeight: resolvedCaptionHeight
    implicitHeight: Math.max(contentHost.implicitHeight,
                             showCaptionButtons ? captionHeight : contentHost.implicitHeight)
    height: implicitHeight

    property bool _ready: false
    property bool _hitTestPending: false

    // AppWindowTitleBar theming (WinUI caption button / chrome colors).
    property color chromeBackground: Theme.bgAcrylic
    // Inactive chrome styling
    property bool chromeInactive: false
    // Caption button rest fill
    property color buttonBackground: "transparent"
    // Caption button hover fill
    property color buttonHover: Theme.fillSubtle
    // Caption button pressed fill
    property color buttonPressed: Theme.fillSubtleTertiary
    // Caption button foreground
    property color buttonForeground: Theme.textPrimary
    // Close hover fill
    property color closeHover: "#E81123"
    // Close pressed fill
    property color closePressed: "#C50F1F"

    // Report Hit Test
    function reportHitTest() {
        if (!root._ready || !root.useNativeChrome || !root.targetWindow)
            return
        if (root._hitTestPending)
            return
        root._hitTestPending = true
        Qt.callLater(function () {
            root._hitTestPending = false
            root._reportHitTestNow()
        })
    }

    function _reportHitTestNow() {
        if (!root._ready || !root.useNativeChrome || !root.targetWindow)
            return

        // Screen-logical rects (mapToGlobal). Native NCHITTEST compares against
        // the same space — critical for maximize/fullscreen where win.x/y drift
        // from GetWindowRect.
        function screenRect(item) {
            if (!item || !item.visible || item.width <= 0 || item.height <= 0)
                return Qt.rect(0, 0, 0, 0)
            var g = item.mapToGlobal(0, 0)
            return Qt.rect(Math.floor(g.x), Math.floor(g.y),
                           Math.ceil(item.width), Math.ceil(item.height))
        }

        var clients = []
        if (contentHost.children.length > 0 && contentHost.children[0].clientExcludeRectsFor)
            clients = contentHost.children[0].clientExcludeRectsFor(root.targetWindow)

        WindowHelper.updateHitTestLayout(
                    root.targetWindow,
                    screenRect(root),
                    screenRect(minBtn),
                    screenRect(maxBtn),
                    screenRect(closeBtn),
                    clients)
    }

    Rectangle {
        anchors.fill: parent
        color: root.chromeInactive
               ? Qt.rgba(root.chromeBackground.r, root.chromeBackground.g,
                         root.chromeBackground.b, 0.72)
               : root.chromeBackground
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        anchors.rightMargin: root.showCaptionButtons
                             ? (captionRow.visible ? captionRow.width : 138) : 0
        acceptedButtons: Qt.LeftButton
        enabled: root.showCaptionButtons && root.targetWindow !== null
        z: -1
        onPressed: {
            if (root.targetWindow && root.targetWindow.startSystemMove)
                root.targetWindow.startSystemMove()
        }
        onDoubleClicked: {
            if (!root.targetWindow || !root.showMaximize)
                return
            if (root.targetWindow.visibility === Window.Maximized
                    || root.targetWindow.visibility === Window.FullScreen)
                root.targetWindow.showNormal()
            else
                root.targetWindow.showMaximized()
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            id: contentHost
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitHeight: children.length > 0 ? children[0].implicitHeight : 48
        }

        Row {
            id: captionRow
            visible: root.showCaptionButtons
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.preferredHeight: root.captionHeight
            z: 2

            CaptionButton {
                id: minBtn
                visible: root.showMinimize
                glyph: FluentIcons.ChromeMinimize
                height: root.captionHeight
                interactive: true
                backgroundColor: root.buttonBackground
                hoverColor: root.buttonHover
                pressedColor: root.buttonPressed
                foregroundColor: root.buttonForeground
                forceHovered: WindowHelper.captionHover === WindowHelper.CaptionMinimize
                forcePressed: WindowHelper.captionPressed === WindowHelper.CaptionMinimize
                onClicked: {
                    if (root.targetWindow)
                        root.targetWindow.showMinimized()
                }
                ToolTip.visible: hovered || forceHovered
                ToolTip.text: qsTr("Minimize")
                ToolTip.delay: 600
                onWidthChanged: root.reportHitTest()
                onHeightChanged: root.reportHitTest()
                onXChanged: root.reportHitTest()
                onYChanged: root.reportHitTest()
            }
            CaptionButton {
                id: maxBtn
                visible: root.showMaximize
                glyph: root.targetWindow
                       && (root.targetWindow.visibility === Window.Maximized
                           || root.targetWindow.visibility === Window.FullScreen)
                       ? FluentIcons.ChromeRestore : FluentIcons.ChromeMaximize
                height: root.captionHeight
                interactive: true
                backgroundColor: root.buttonBackground
                hoverColor: root.buttonHover
                pressedColor: root.buttonPressed
                foregroundColor: root.buttonForeground
                forceHovered: WindowHelper.captionHover === WindowHelper.CaptionMaximize
                forcePressed: WindowHelper.captionPressed === WindowHelper.CaptionMaximize
                onClicked: {
                    if (!root.targetWindow)
                        return
                    if (root.targetWindow.visibility === Window.Maximized
                            || root.targetWindow.visibility === Window.FullScreen)
                        root.targetWindow.showNormal()
                    else
                        root.targetWindow.showMaximized()
                }
                ToolTip.visible: hovered || forceHovered
                ToolTip.text: root.targetWindow
                              && (root.targetWindow.visibility === Window.Maximized
                                  || root.targetWindow.visibility === Window.FullScreen)
                              ? qsTr("Restore") : qsTr("Maximize")
                ToolTip.delay: 600
                onWidthChanged: root.reportHitTest()
                onHeightChanged: root.reportHitTest()
                onXChanged: root.reportHitTest()
                onYChanged: root.reportHitTest()
            }
            CaptionButton {
                id: closeBtn
                visible: root.showClose
                glyph: FluentIcons.ChromeCloseAlt
                destructive: true
                height: root.captionHeight
                interactive: true
                backgroundColor: root.buttonBackground
                hoverColor: root.closeHover
                pressedColor: root.closePressed
                foregroundColor: root.buttonForeground
                forceHovered: WindowHelper.captionHover === WindowHelper.CaptionClose
                forcePressed: WindowHelper.captionPressed === WindowHelper.CaptionClose
                onClicked: {
                    if (root.targetWindow)
                        root.targetWindow.close()
                }
                ToolTip.visible: hovered || forceHovered
                ToolTip.text: qsTr("Close")
                ToolTip.delay: 600
                onWidthChanged: root.reportHitTest()
                onHeightChanged: root.reportHitTest()
                onXChanged: root.reportHitTest()
                onYChanged: root.reportHitTest()
            }
        }
    }

    onWidthChanged: if (_ready) reportHitTest()
    onHeightChanged: if (_ready) reportHitTest()
    onTargetWindowChanged: if (_ready) reportHitTest()
    onPreferredHeightOptionChanged: if (_ready) reportHitTest()
    Component.onCompleted: {
        _ready = true
        Qt.callLater(reportHitTest)
    }

    Connections {
        target: root.targetWindow
        enabled: root._ready
        function onWidthChanged() { root.reportHitTest() }
        function onHeightChanged() { root.reportHitTest() }
        function onVisibilityChanged() { root.reportHitTest() }
    }

    Connections {
        target: WindowHelper
        function onCaptionHoverChanged() { }
        function onCaptionPressedChanged() { }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

Item {
    id: root

    property var targetWindow: null
    property bool showCaptionButtons: WindowHelper.customFrame
    property bool showMinimize: true
    property bool showMaximize: true
    readonly property bool useNativeChrome: WindowHelper.nativeChrome && showCaptionButtons
    default property alias titleContent: contentHost.data

    property real captionHeight: 32
    implicitHeight: Math.max(contentHost.implicitHeight, showCaptionButtons ? 48 : contentHost.implicitHeight)
    height: implicitHeight

    property bool _ready: false
    property bool _hitTestPending: false

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

        var win = root.targetWindow
        var winX = win.x
        var winY = win.y

        function buttonRect(btn) {
            if (!btn || !btn.visible || btn.width <= 0 || btn.height <= 0)
                return Qt.rect(0, 0, 0, 0)
            var g = btn.mapToGlobal(0, 0)
            return Qt.rect(g.x - winX, g.y - winY, btn.width, btn.height)
        }

        var topGlobal = root.mapToGlobal(0, 0)
        var titleBottom = Math.ceil((topGlobal.y - winY) + root.height)

        var clients = []
        if (contentHost.children.length > 0 && contentHost.children[0].clientExcludeRectsFor)
            clients = contentHost.children[0].clientExcludeRectsFor(win)

        WindowHelper.updateHitTestLayout(
                    win,
                    titleBottom,
                    buttonRect(minBtn),
                    buttonRect(maxBtn),
                    buttonRect(closeBtn),
                    clients)
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bgAcrylic
    }

    // Fallback drag — also used when native hit-test is not ready yet (titleH==0).
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
            if (root.targetWindow.visibility === Window.Maximized)
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
                glyph: "\uE921"
                height: root.captionHeight
                // Always Qt-interactive: native HTMIN/MAX/CLOSE paints a white
                // system button plate on translucent DWM materials.
                interactive: true
                onClicked: {
                    if (root.targetWindow)
                        root.targetWindow.showMinimized()
                }
                ToolTip.visible: hovered
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
                glyph: root.targetWindow && root.targetWindow.visibility === Window.Maximized
                       ? "\uE923" : "\uE922"
                height: root.captionHeight
                interactive: true
                onClicked: {
                    if (!root.targetWindow)
                        return
                    if (root.targetWindow.visibility === Window.Maximized)
                        root.targetWindow.showNormal()
                    else
                        root.targetWindow.showMaximized()
                }
                ToolTip.visible: hovered
                ToolTip.text: root.targetWindow && root.targetWindow.visibility === Window.Maximized
                              ? qsTr("Restore") : qsTr("Maximize")
                ToolTip.delay: 600
                onWidthChanged: root.reportHitTest()
                onHeightChanged: root.reportHitTest()
                onXChanged: root.reportHitTest()
                onYChanged: root.reportHitTest()
            }
            CaptionButton {
                id: closeBtn
                glyph: "\uE8BB"
                destructive: true
                height: root.captionHeight
                interactive: true
                onClicked: {
                    if (root.targetWindow)
                        root.targetWindow.close()
                }
                ToolTip.visible: hovered
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
}

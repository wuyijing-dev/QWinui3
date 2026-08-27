import QtQuick
import QtQuick.Controls
import QWinUI3.Theme

// TitleBarCommandBar — declarative title-bar commands for leftHeader / captionRightHeader (3.01 W2).

Row {
    id: root

    property var commands: []

    spacing: Theme.spacingTight
    implicitHeight: Theme.searchBoxHeight - 8

    onWidthChanged: _refreshHitTest()
    onHeightChanged: _refreshHitTest()
    onImplicitWidthChanged: _refreshHitTest()
    onImplicitHeightChanged: _refreshHitTest()
    onCommandsChanged: _refreshHitTest()

    Component.onCompleted: Qt.callLater(function () {
        if (root)
            root._refreshHitTest()
    })

    function _refreshHitTest() {
        var p = parent
        while (p) {
            if (typeof p.notifyChromeHitTest === "function") {
                p.notifyChromeHitTest()
                return
            }
            if (typeof p.reportHitTest === "function") {
                p.reportHitTest()
                return
            }
            p = p.parent
        }
    }

    Repeater {
        id: cmdRepeater
        model: root.commands || []
        delegate: IconButton {
            flat: true
            microMotionEnabled: false
            iconSize: 14
            visible: modelData && modelData.visible !== false
            enabled: !modelData || modelData.enabled !== false
            symbol: {
                if (!modelData)
                    return FluentIcons.Placeholder
                if (modelData.symbol !== undefined)
                    return modelData.symbol
                if (modelData.icon !== undefined)
                    return modelData.icon
                return FluentIcons.Placeholder
            }
            Accessible.name: {
                if (!modelData)
                    return ""
                var t = modelData.label || modelData.title || ""
                if (modelData.shortcut)
                    return t.length ? t + " (" + modelData.shortcut + ")" : modelData.shortcut
                return t.length ? t : qsTr("Command %1").arg(index + 1)
            }
            ToolTip.text: Accessible.name
            ToolTip.visible: hovered
            onClicked: {
                if (modelData && modelData.action)
                    modelData.action()
            }
        }
    }
}

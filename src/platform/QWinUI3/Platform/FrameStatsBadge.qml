import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Platform

// FrameStatsBadge — compact FPS readout for StandardTitleChrome.rightHeader
// (PlatformTitleBar slot before caption buttons — not TitleBar.rightHeader).
//
//   StandardTitleChrome {
//       rightHeader: FrameStatsBadge { }
//   }
//
// Requires FrameStatsMonitor.attachWindow(window) and FrameStatsMonitor.enabled.

Label {
    id: root

    visible: FrameStatsMonitor.enabled && FrameStatsMonitor.inTitleBar
    padding: 6
    verticalAlignment: Text.AlignVCenter
    Layout.fillWidth: false
    Layout.minimumWidth: implicitWidth
    Layout.preferredWidth: implicitWidth
    font.pixelSize: Theme.fontCaption
    font.weight: Theme.fontWeightSemiBold
    readonly property string readoutText: {
        if (FrameStatsMonitor.fps <= 0)
            return qsTr("FPS …")
        var line = qsTr("%1 FPS · %2 ms")
                .arg(FrameStatsMonitor.fps.toFixed(1))
                .arg(FrameStatsMonitor.frameTimeMs.toFixed(1))
        if (FrameStatsMonitor.showRhi && FrameStatsMonitor.rhiLabel.length)
            line += qsTr(" · %1").arg(FrameStatsMonitor.rhiLabel)
        return line
    }

    color: Theme.textSecondary
    text: readoutText
    Accessible.name: qsTr("Frames per second")
    Accessible.description: readoutText

    Connections {
        target: FrameStatsMonitor
        function onChanged() {
            var p = root.parent
            while (p) {
                if (typeof p.reportHitTest === "function") {
                    p.reportHitTest()
                    return
                }
                if (typeof p.notifyChromeHitTest === "function") {
                    p.notifyChromeHitTest()
                    return
                }
                p = p.parent
            }
        }
    }
}

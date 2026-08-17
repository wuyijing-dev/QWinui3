import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Platform

// FrameStatsBadge — compact FPS readout for TitleBar rightHeader / leftHeader slots.
//
//   TitleBar {
//       rightHeader: FrameStatsBadge { }
//   }
//
// Requires FrameStatsMonitor.attachWindow(window) once (Gallery Main does this on completed).

Label {
    id: root

    visible: FrameStatsMonitor.enabled && FrameStatsMonitor.inTitleBar
    padding: 6
    verticalAlignment: Text.AlignVCenter
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontCaption
    font.weight: Theme.fontWeightSemiBold
    color: Theme.textSecondary
    text: FrameStatsMonitor.fps > 0
          ? qsTr("%1 FPS · %2 ms").arg(FrameStatsMonitor.fps.toFixed(1))
                                    .arg(FrameStatsMonitor.frameTimeMs.toFixed(1))
          : qsTr("FPS …")
    Accessible.name: qsTr("Frames per second")
    Accessible.description: text

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

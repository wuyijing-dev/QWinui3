import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Platform

// FrameStatsOverlay — floating FPS badge when not using the title-bar slot.
//
//   FrameStatsOverlay { targetWindow: window }
//
Item {
    id: root

    property var targetWindow: null

    visible: FrameStatsMonitor.enabled && !FrameStatsMonitor.inTitleBar
    z: 9999
    anchors.fill: parent
    enabled: false

    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 12
        radius: Theme.cornerControl
        color: Qt.rgba(Theme.bgCard.r, Theme.bgCard.g, Theme.bgCard.b, 0.92)
        border.width: 1
        border.color: Theme.strokeDivider
        implicitWidth: label.implicitWidth + 16
        implicitHeight: label.implicitHeight + 8

        Label {
            id: label
            anchors.centerIn: parent
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
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
            text: readoutText
        }
    }
}

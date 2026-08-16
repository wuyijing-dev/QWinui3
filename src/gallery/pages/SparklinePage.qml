import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Sparkline.
//
// Reveal wipe, showDelta, end marker, caption, and live streams. API: docs/components/Sparkline.md

CatalogPage {
    id: page
    title: qsTr("Sparkline")
    subtitle: qsTr("Reveal wipe, showDelta, end marker, caption, and live streams.")

    property var liveSpark: []
    property int tick: 0

    Component.onCompleted: {
        var a = []
        for (var i = 0; i < 40; ++i)
            a.push(40 + Math.sin(i * 0.4) * 12)
        liveSpark = a
    }

    Timer {
        interval: 450
        running: page.visible
        repeat: true
        onTriggered: {
            page.tick++
            var a = page.liveSpark.slice()
            a.push(40 + Math.sin(page.tick * 0.45) * 14 + Math.random() * 3)
            if (a.length > 40)
                a.shift()
            page.liveSpark = a
        }
    }

    readonly property var sparkData: {
        var a = []
        for (var i = 0; i < 64; ++i)
            a.push(40 + Math.sin(i * 0.35) * 18 + (i % 7) * 0.8)
        return a
    }
    readonly property var sparkDown: {
        var a = []
        for (var i = 0; i < 48; ++i)
            a.push(70 - i * 0.9 + Math.sin(i * 0.4) * 4)
        return a
    }

    ControlExample {
        headerText: qsTr("Status row")
        qmlSource: "Sparkline { caption: \"CPU\"; showEndMarker: true }"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Sparkline {
                id: sparkCpu
                Layout.preferredWidth: 160
                Layout.preferredHeight: 44
                caption: qsTr("CPU")
                values: page.sparkData
            }
            Sparkline {
                Layout.preferredWidth: 160
                Layout.preferredHeight: 44
                caption: qsTr("Latency")
                values: page.sparkDown
                strokeColor: Theme.systemSuccess
                fillColor: ChartUtils.withAlpha(Theme.systemSuccess, 0.18)
            }
            Sparkline {
                Layout.preferredWidth: 140
                Layout.preferredHeight: 44
                showDelta: true
                values: [2, 1, 4, 3, 8, 5, 2, 1, 0, 1, 3, 2]
                strokeColor: Theme.systemCritical
                fillColor: ChartUtils.withAlpha(Theme.systemCritical, 0.16)
            }
            Button {
                text: qsTr("Replay")
                onClicked: sparkCpu.playReveal()
            }
        }
    }

    ControlExample {
        headerText: qsTr("Live")
        qmlSource: "Sparkline { animated: false; values: stream }"
        Sparkline {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            animated: false
            strokeWidth: 2
            values: page.liveSpark
        }
    }
}

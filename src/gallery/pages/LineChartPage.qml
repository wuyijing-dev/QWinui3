import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    id: page
    padding: 0

    property var liveA: []
    property var liveB: []
    property int tick: 0
    property string megaStatus: qsTr("Idle — load 1M points (C++ ChartSeries)")

    ChartSeries {
        id: megaSeries
    }

    function seedLive() {
        var a = [], b = []
        for (var i = 0; i < 60; ++i) {
            a.push(30 + Math.sin(i * 0.2) * 12)
            b.push(40 + Math.cos(i * 0.18) * 10)
        }
        liveA = a
        liveB = b
    }

    Component.onCompleted: seedLive()

    Timer {
        interval: 700
        running: page.visible
        repeat: true
        onTriggered: {
            page.tick++
            var a = page.liveA.slice()
            var b = page.liveB.slice()
            a.push(30 + Math.sin(page.tick * 0.35) * 14 + (Math.random() * 4))
            b.push(40 + Math.cos(page.tick * 0.28) * 11 + (Math.random() * 3))
            if (a.length > 60) a.shift()
            if (b.length > 60) b.shift()
            page.liveA = a
            page.liveB = b
        }
    }

    readonly property var lineA: {
        var a = []
        for (var i = 0; i < 120; ++i)
            a.push(30 + Math.sin(i * 0.12) * 20 + Math.cos(i * 0.05) * 8)
        return a
    }
    readonly property var lineB: {
        var a = []
        for (var i = 0; i < 120; ++i)
            a.push(45 + Math.cos(i * 0.1) * 14)
        return a
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection

            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("LineChart")
                subtitle: qsTr("Pixel LOD for million-point series, hover crosshair, and empty state.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Interactive multi-series")
                qmlSource: "LineChart {\n    title: \"Traffic\"\n    interactive: true\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        color: Theme.textSecondary
                        text: qsTr("Move the pointer across the plot to read series values.")
                    }
                    LineChart {
                        id: multiLine
                        Layout.fillWidth: true
                        Layout.preferredHeight: 240
                        title: qsTr("Traffic")
                        showArea: true
                        interactive: true
                        showLegend: true
                        series: [
                            { name: qsTr("Inbound"), values: page.lineA, color: Theme.accent, filled: true },
                            { name: qsTr("Outbound"), values: page.lineB, color: Theme.systemSuccess, filled: false }
                        ]
                    }
                    Button {
                        text: qsTr("Replay reveal")
                        onClicked: multiLine.playReveal()
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Live stream")
                qmlSource: "LineChart { series: liveBuffers }"
                LineChart {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    animated: false
                    showArea: true
                    showLegend: true
                    series: [
                        { name: qsTr("CPU"), values: page.liveA, color: Theme.accent, filled: true },
                        { name: qsTr("Mem"), values: page.liveB, color: Theme.systemCaution, filled: false }
                    ]
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Million-point LOD")
                qmlSource: "ChartSeries { id: s }\nLineChart { values: s }"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        color: Theme.textSecondary
                        text: qsTr("全部 100 万点已加载到内存。界面只画约「宽度×2」个包络采样（例如 900px ≈ 1.8k），这是像素级 LOD，不是只加载了 1.8k。悬停用 overlay，不再重绘 Canvas。")
                    }
                    LineChart {
                        id: megaLine
                        Layout.fillWidth: true
                        Layout.preferredHeight: 240
                        title: qsTr("1M samples (full range)")
                        showArea: false
                        showLegend: false
                        interactive: true
                        animated: false
                        values: megaSeries
                    }
                    RowLayout {
                        Label {
                            Layout.fillWidth: true
                            color: Theme.textSecondary
                            text: megaSeries.count
                                  ? qsTr("已加载 %1 · 屏幕采样 %2 · %3")
                                        .arg(ChartUtils.formatCount(megaSeries.count))
                                        .arg(ChartUtils.formatCount(megaLine.drawnPointCount))
                                        .arg(page.megaStatus)
                                  : page.megaStatus
                        }
                        Button {
                            text: megaSeries.count ? qsTr("Reload 1M") : qsTr("Load 1M points")
                            onClicked: {
                                page.megaStatus = qsTr("generating…")
                                Qt.callLater(function () {
                                    var t0 = Date.now()
                                    megaSeries.generateWave(1000000)
                                    page.megaStatus = qsTr("ready in %1 ms").arg(Date.now() - t0)
                                })
                            }
                        }
                        Button {
                            text: qsTr("Clear")
                            enabled: megaSeries.count > 0
                            onClicked: {
                                megaSeries.clear()
                                page.megaStatus = qsTr("Cleared")
                            }
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

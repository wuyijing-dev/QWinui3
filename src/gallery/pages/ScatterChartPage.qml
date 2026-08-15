import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ScatterChart.
//
// Density LOD for million-point clouds, trend line, and tooltips. API: docs/components/ScatterChart.md

Page {
    id: page
    padding: 0
    property string status: qsTr("Hover a point")
    property string megaStatus: qsTr("Idle — load 1M points (C++ ChartSeries)")

    ChartSeries {
        id: megaCloud
    }

    readonly property var cloud: {
        var a = []
        for (var i = 0; i < 120; ++i) {
            a.push({
                x: Math.sin(i * 0.37) * 40 + Math.cos(i * 0.11) * 20 + i * 0.15,
                y: Math.cos(i * 0.29) * 30 + Math.sin(i * 0.17) * 18 + 40,
                color: (i % 5 === 0) ? Theme.systemCaution : Theme.accent
            })
        }
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
                title: qsTr("ScatterChart")
                subtitle: qsTr("Density LOD for million-point clouds, trend line, and tooltips.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Correlation + trend")
                qmlSource: "ScatterChart {\n    title: \"Samples\"\n    showTrendLine: true\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    ScatterChart {
                        id: scatter
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260
                        title: qsTr("Samples")
                        showTrendLine: true
                        points: page.cloud
                        onPointClicked: (index, x, y) => {
                            page.status = qsTr("Point %1 → (%2, %3)")
                                .arg(index + 1)
                                .arg(ChartUtils.formatNumber(x))
                                .arg(ChartUtils.formatNumber(y))
                        }
                    }
                    RowLayout {
                        Label {
                            Layout.fillWidth: true
                            color: Theme.textSecondary
                            text: page.status
                        }
                        Button {
                            text: qsTr("Replay")
                            onClicked: scatter.playReveal()
                        }
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Million-point density")
                qmlSource: "ChartSeries { id: s }\nScatterChart { values: s }"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        color: Theme.textSecondary
                        text: qsTr("All 1M points stay in C++. Density bins cover the full X/Y range; drawn N is occupied pixels, not a partial load.")
                    }
                    ScatterChart {
                        id: megaScatter
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260
                        title: qsTr("1M cloud (full range)")
                        animated: false
                        showTrendLine: false
                        values: megaCloud
                    }
                    RowLayout {
                        Label {
                            Layout.fillWidth: true
                            color: Theme.textSecondary
                            text: megaCloud.count
                                  ? qsTr("Loaded %1 / drawn %2 · %3")
                                        .arg(ChartUtils.formatCount(megaCloud.count))
                                        .arg(ChartUtils.formatCount(megaScatter.drawnPointCount))
                                        .arg(page.megaStatus)
                                  : page.megaStatus
                        }
                        Button {
                            text: megaCloud.count ? qsTr("Reload 1M") : qsTr("Load 1M points")
                            onClicked: {
                                page.megaStatus = qsTr("generating…")
                                Qt.callLater(function () {
                                    var t0 = Date.now()
                                    megaCloud.generateCloud(1000000)
                                    page.megaStatus = qsTr("ready in %1 ms").arg(Date.now() - t0)
                                })
                            }
                        }
                        Button {
                            text: qsTr("Clear")
                            enabled: megaCloud.count > 0
                            onClicked: {
                                megaCloud.clear()
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

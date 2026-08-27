import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Ops console / LiveMetricStrip.
// Throttled live KPI strip + event feed. Recipe: docs/charts.md · docs/app-platform-3xx.md

CatalogPage {
    id: page
    title: qsTr("Ops console")
    subtitle: qsTr("LiveMetricStrip — throttled KPI ring + compare-period. Closes FL-014.")

    property var eventLog: []

    function prependEvent(text) {
        var next = eventLog.slice()
        next.unshift({
            time: Qt.formatTime(new Date(), "hh:mm:ss"),
            text: text
        })
        while (next.length > 12)
            next.pop()
        eventLog = next
    }

    ControlExample {
        headerText: qsTr("LiveMetricStrip")
        qmlSource: "LiveMetricStrip {\n    intervalMs: 1000\n    compareLag: 8\n    onTick: pushSample(\"cpu\", v)\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Owns the throttle Timer, ring buffers (maxPoints), and compareValue from compareLag samples back. Feed values in onTick via pushSample(key, value) — no per-tile Timer. Prefer over MetricCompareRow + ad-hoc refresh for ops dashboards.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                CheckBox {
                    id: liveEn
                    text: qsTr("Live refresh")
                    checked: true
                }
                Label {
                    text: qsTr("Interval")
                    color: Theme.textSecondary
                }
                SpinBox {
                    id: intervalBox
                    from: 250
                    to: 5000
                    stepSize: 100
                    value: 1000
                    editable: true
                    Layout.preferredWidth: 120
                    Accessible.name: qsTr("Refresh interval ms")
                }
                Label {
                    text: qsTr("Compare lag")
                    color: Theme.textSecondary
                }
                SpinBox {
                    id: lagBox
                    from: 1
                    to: 24
                    value: 8
                    editable: true
                    Layout.preferredWidth: 100
                    Accessible.name: qsTr("Compare lag samples")
                }
                Button {
                    text: qsTr("Tick once")
                    onClicked: opsStrip.tickOnce()
                }
                Button {
                    text: qsTr("Clear buffers")
                    onClicked: {
                        opsStrip.clearBuffers()
                        page.prependEvent(qsTr("Buffers cleared"))
                    }
                }
                Label {
                    Layout.fillWidth: true
                    text: qsTr("samples %1 · last %2")
                            .arg(opsStrip.sampleCount)
                            .arg(opsStrip.lastTickMs > 0
                                 ? Qt.formatTime(new Date(opsStrip.lastTickMs), "hh:mm:ss")
                                 : "—")
                    color: Theme.textSecondary
                    elide: Text.ElideRight
                }
            }

            LiveMetricStrip {
                id: opsStrip
                Layout.fillWidth: true
                intervalMs: intervalBox.value
                running: liveEn.checked && page.visible
                maxPoints: 16
                compareLag: lagBox.value
                periodLabel: qsTr("vs ~%1 samples ago").arg(lagBox.value)
                autoDeltaPercent: true
                metrics: [
                    {
                        key: "cpu",
                        title: qsTr("CPU"),
                        unit: "%",
                        cautionThreshold: 75,
                        criticalThreshold: 90,
                        symbol: FluentIcons.Sync,
                        sparklineHeight: 32
                    },
                    {
                        key: "mem",
                        title: qsTr("Memory"),
                        unit: "%",
                        invertDeltaColors: true,
                        cautionThreshold: 80,
                        criticalThreshold: 92,
                        symbol: FluentIcons.Save
                    },
                    {
                        key: "lat",
                        title: qsTr("Latency p95"),
                        unit: " ms",
                        invertDeltaColors: true,
                        invertThresholds: true,
                        cautionThreshold: 50,
                        criticalThreshold: 70,
                        symbol: FluentIcons.Clock
                    },
                    {
                        key: "err",
                        title: qsTr("Error rate"),
                        unit: "%",
                        valuePrecision: 1,
                        invertDeltaColors: true,
                        cautionThreshold: 2,
                        criticalThreshold: 5,
                        symbol: FluentIcons.Warning
                    }
                ]
                onTick: {
                    var cpu = 40 + Math.round(Math.random() * 45)
                    var mem = 55 + Math.round(Math.random() * 30)
                    var lat = 28 + Math.round(Math.random() * 30)
                    var err = Math.round((Math.random() * 4) * 10) / 10
                    pushSamples({ cpu: cpu, mem: mem, lat: lat, err: err })
                }
                Component.onCompleted: {
                    pushSamples({ cpu: 64, mem: 71, lat: 42, err: 1.2 })
                }
                onSamplePushed: function (key, value) {
                    if (key === "cpu" && value >= 90)
                        page.prependEvent(qsTr("CPU critical · %1%").arg(Math.round(value)))
                    else if (key === "err" && value >= 3)
                        page.prependEvent(qsTr("Error rate elevated · %1%").arg(value))
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Event feed (ops console)")
        qmlSource: "onSamplePushed: (key, value) => prependEvent(…)"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Product apps wire samplePushed / thresholds into toasts or a filtered grid. Full SplitWorkspace + filterable DataTable kit lands in examples/ops-console (examples/ops-console).")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                radius: Theme.cornerControl
                color: Theme.bgCard
                border.color: Theme.strokeCard
                border.width: 1
                clip: true

                ListView {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing
                    model: page.eventLog
                    spacing: 4
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    delegate: RowLayout {
                        required property var modelData
                        width: ListView.view.width
                        spacing: Theme.spacing
                        Text {
                            text: modelData.time
                            font: ThemeFonts.monoFontFor(Theme.fontCaption)
                            color: Theme.textSecondary
                        }
                        Text {
                            Layout.fillWidth: true
                            text: modelData.text
                            font.pixelSize: Theme.fontBody
                            color: Theme.textPrimary
                            elide: Text.ElideRight
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        visible: page.eventLog.length === 0
                        text: qsTr("No threshold events yet — wait for CPU ≥ 90% or errors ≥ 3%")
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "// LiveMetricStrip — live ops KPI row\n// MetricCompareRow — static compare strip\n// examples/dashboard"

        ColumnLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use LiveMetricStrip when values arrive on a timer or poll. Keep MetricCompareRow for static period captions without a ring buffer. DashboardShell.kpiRow accepts either. See examples/dashboard (v2 live tick).")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }
}

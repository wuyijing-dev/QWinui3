import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Vertical kit V3 (3.07) — ops console: SplitWorkspace + LiveMetricStrip + DataTable.
// Recipe: docs/charts.md · docs/app-platform-3xx.md

StandardWindow {
    id: window
    width: 1200
    height: 760
    visible: true
    title: qsTr("Ops console")
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "OpsConsoleExample"

    property string envFilter: qsTr("All")
    property real cpu: 58
    property real errRate: 0.4

    function makeIncidents(n) {
        var out = []
        var envs = [qsTr("prod"), qsTr("staging"), qsTr("dev")]
        var sevs = [qsTr("Sev1"), qsTr("Sev2"), qsTr("Sev3")]
        for (var i = 0; i < n; ++i) {
            out.push({
                id: "INC-" + (1200 + i),
                service: qsTr("svc-%1").arg((i % 7) + 1),
                env: envs[i % 3],
                severity: sevs[i % 3],
                ageMin: (i * 7) % 180
            })
        }
        return out
    }

    property var allIncidents: makeIncidents(48)
    property var visibleIncidents: {
        if (envFilter === qsTr("All"))
            return allIncidents
        return allIncidents.filter(function (r) { return r.env === envFilter })
    }

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
            subtitle: qsTr("V3 · SplitWorkspace · LiveMetricStrip · DataTable")
        }
    }

    Item {
        width: 0
        height: 0
        visible: false
        LayoutPreset {
            id: layouts
            category: "OpsConsoleExample/Layouts"
            workspace: split
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing
        spacing: Theme.spacing

        LiveMetricStrip {
            id: live
            Layout.fillWidth: true
            intervalMs: 1400
            running: true
            maxPoints: 16
            compareLag: 8
            periodLabel: qsTr("vs prior window")
            metrics: [
                {
                    key: "cpu",
                    title: qsTr("CPU"),
                    unit: "%",
                    cautionThreshold: 75,
                    criticalThreshold: 90,
                    symbol: FluentIcons.Sync
                },
                {
                    key: "err",
                    title: qsTr("Error rate"),
                    unit: "%",
                    invertDeltaColors: true,
                    invertThresholds: true,
                    cautionThreshold: 1.0,
                    criticalThreshold: 2.5,
                    symbol: FluentIcons.Warning
                }
            ]
            onTick: {
                window.cpu = 40 + Math.round(Math.random() * 45)
                window.errRate = Math.round((0.1 + Math.random() * 2.4) * 10) / 10
                pushSamples({ cpu: window.cpu, err: window.errRate })
            }
            Component.onCompleted: pushSamples({ cpu: window.cpu, err: window.errRate })
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Button {
                text: qsTr("Layout: Monitor")
                onClicked: {
                    split.paneCount = 3
                    split.setRatios([0.22, 0.48, 0.3])
                    layouts.save("Monitor")
                }
            }
            Button {
                text: qsTr("Layout: Focus")
                onClicked: {
                    split.paneCount = 2
                    split.setRatios([0.28, 0.72])
                    layouts.save("Focus")
                }
            }
            Button {
                text: qsTr("Restore Monitor")
                onClicked: layouts.apply("Monitor")
            }
            Item { Layout.fillWidth: true }
            Label {
                text: qsTr("%1 incidents").arg(window.visibleIncidents.length)
                color: Theme.textSecondary
            }
        }

        SplitWorkspace {
            id: split
            Layout.fillWidth: true
            Layout.fillHeight: true
            paneCount: 3
            orientation: Qt.Horizontal
            minPaneWidth: 140
            ratios: [0.22, 0.48, 0.3]

            pane1: Pane {
                padding: Theme.spacing
                background: Rectangle {
                    color: Theme.bgCard
                    radius: Theme.cornerCard
                    border.color: Theme.strokeDivider
                    border.width: 1
                }
                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.spacing
                    Text {
                        text: qsTr("Environment")
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }
                    ComboBox {
                        Layout.fillWidth: true
                        model: [qsTr("All"), qsTr("prod"), qsTr("staging"), qsTr("dev")]
                        currentIndex: 0
                        onActivated: function (index) {
                            window.envFilter = model[index]
                        }
                    }
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                        text: qsTr("Filter drives the incident grid. LayoutPreset saves Monitor / Focus.")
                    }
                    Item { Layout.fillHeight: true }
                }
            }

            pane2: Pane {
                padding: Theme.spacing
                background: null
                DataTable {
                    anchors.fill: parent
                    filterPlaceholder: qsTr("Filter id, service, severity")
                    columns: [
                        { title: qsTr("Id"), role: "id", width: 100, sortable: true },
                        { title: qsTr("Service"), role: "service", width: 110, sortable: true },
                        { title: qsTr("Env"), role: "env", width: 90, sortable: true },
                        { title: qsTr("Severity"), role: "severity", width: 90, sortable: true },
                        { title: qsTr("Age (min)"), role: "ageMin", width: 90, sortable: true }
                    ]
                    rows: window.visibleIncidents
                }
            }

            pane3: Pane {
                padding: Theme.spacing
                background: Rectangle {
                    color: Theme.bgCard
                    radius: Theme.cornerCard
                    border.color: Theme.strokeDivider
                    border.width: 1
                }
                ColumnLayout {
                    anchors.fill: parent
                    spacing: Theme.spacing
                    Text {
                        text: qsTr("Live snapshot")
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        color: Theme.textSecondary
                        text: qsTr("CPU %1% · error rate %2%")
                                .arg(window.cpu).arg(window.errRate)
                    }
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textTertiary
                        text: qsTr("Ctrl+Alt+Left/Right focuses panes. See SplitWorkspace (3.03).")
                    }
                    Item { Layout.fillHeight: true }
                }
            }
        }
    }
}

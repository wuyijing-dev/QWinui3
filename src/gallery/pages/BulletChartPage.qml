import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — BulletChart.
//
// KPI bullets with targetMet, showTargetDelta, unit, and setValue(). API: docs/components/BulletChart.md

CatalogPage {
    id: page
    title: qsTr("BulletChart")
    subtitle: qsTr("Experimental (deferred). Prefer KpiTile for KPI bullets.")

    property real revenue: 72
    property real satisfaction: 88
    property real latency: 42

    Timer {
        interval: 1600
        running: page.visible
        repeat: true
        onTriggered: {
            page.revenue = 55 + Math.round(Math.random() * 40)
            page.satisfaction = 70 + Math.round(Math.random() * 28)
            page.latency = 25 + Math.round(Math.random() * 50)
        }
    }

    ControlExample {
        headerText: qsTr("Live KPIs")
        qmlSource: "BulletChart {\n    unit: \"%\"\n    target: 80\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            BulletChart {
                Layout.fillWidth: true
                label: qsTr("Revenue")
                value: page.revenue
                target: 80
                maximum: 100
                unit: "%"
                showTargetDelta: true
                ranges: [0.5, 0.75, 1]
            }
            BulletChart {
                Layout.fillWidth: true
                label: qsTr("Satisfaction")
                value: page.satisfaction
                target: 85
                maximum: 100
                unit: "%"
                ranges: [0.4, 0.7, 1]
            }
            BulletChart {
                id: latencyBullet
                Layout.fillWidth: true
                label: qsTr("Latency")
                value: page.latency
                target: 50
                maximum: 100
                unit: " ms"
                showTarget: true
                ranges: [0.35, 0.65, 1]
            }
            Button {
                text: qsTr("Set latency 30")
                onClicked: latencyBullet.setValue(30)
            }
        }
    }
}

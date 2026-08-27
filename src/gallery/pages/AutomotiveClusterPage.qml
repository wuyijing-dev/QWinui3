import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    id: page
    title: qsTr("AutomotiveCluster")
    subtitle: qsTr("Experimental composed instrument cluster. Product dashboards still use the stable six.")

    property real t: 0
    property bool hazards: false
    property bool oilWarn: false
    property bool park: false

    Timer {
        interval: 50
        running: page.visible
        repeat: true
        onTriggered: {
            page.t += 0.05
            var cruise = 0.5 + 0.5 * Math.sin(page.t * 0.35)
            cluster.speed = 18 + cruise * 118
            cluster.rpm = 1100 + cruise * 3200
            cluster.coolant = 84 + cruise * 14
            cluster.boost = (cruise - 0.38) * 1.15
            cluster.voltage = 13.4 + cruise * 0.5
            cluster.fuel = Math.max(0.08, cluster.fuel - 0.00012)
            var dtHours = 50 / 3600000
            cluster.tripKm += cluster.speed * dtHours
            cluster.totalKm += cluster.speed * dtHours
            cluster.gear = cruise > 0.12 ? "D" : "N"
            cluster.gearNumber = cruise > 0.12 ? Math.max(2, Math.min(6, Math.round(1 + cruise * 5))) : 0
            cluster.leftTurn = page.hazards || Math.sin(page.t * 0.7) > 0.92
            cluster.rightTurn = page.hazards
            cluster.highBeam = cruise > 0.82
            cluster.oil = page.oilWarn
            cluster.parkingBrake = page.park
        }
    }

    ControlExample {
        headerText: qsTr("Cluster")
        qmlSource: "AutomotiveCluster {\n speed: 86; rpm: 3200; fuel: 0.42; gear: \"D\"\n}"
        ColumnLayout {
            spacing: Theme.spacing
            AutomotiveCluster {
                id: cluster
                Layout.fillWidth: true
                implicitHeight: 380
                speed: 86
                rpm: 3200
                fuel: 0.62
                coolant: 90
                boost: 0.2
                voltage: 13.8
                gear: "D"
                gearNumber: 4
                totalKm: 12480.3
                tripKm: 36.2
            }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                CheckBox {
                    text: qsTr("Hazards")
                    onToggled: page.hazards = checked
                }
                CheckBox {
                    text: qsTr("Oil")
                    onToggled: page.oilWarn = checked
                }
                CheckBox {
                    text: qsTr("Park")
                    onToggled: page.park = checked
                }
                Button {
                    text: qsTr("Refuel")
                    onClicked: cluster.fuel = 1
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingSection
                TpmsGauge {
                    title: qsTr("TPMS")
                    fl: 2.3
                    fr: 2.3
                    rl: 2.4
                    rr: 2.2
                }
                GMeterGauge {
                    title: qsTr("G")
                    lateral: 0.35 * Math.sin(page.t * 1.1)
                    longitudinal: 0.2 * Math.cos(page.t * 0.8)
                }
            }
        }
    }
}

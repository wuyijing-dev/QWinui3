import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// AutomotiveCluster — Composed vehicle instrument cluster.
//
//   AutomotiveCluster {
//       speed: 86
//       rpm: 3200
//       fuel: 0.42
//       coolant: 92
//       gear: "D"
//   }
//
// @notes
//   Experimental compose host. Product dashboards still use the stable six.
//   Wires SpeedometerGauge, TachometerGauge, FuelGauge, CoolantGauge, GearIndicator,
//   OdometerGauge, TelltaleBar, VoltageGauge.

T.Control {
    id: root
    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Instrument cluster")

    property real speed: 0
    property real speedMax: 240
    property string speedUnit: "km/h"
    property real rpm: 800
    property real rpmMax: 8000
    property real redline: 6500
    property real fuel: 0.5
    property real coolant: 90
    property real boost: 0
    property real voltage: 13.8
    property string gear: "P"
    property int gearNumber: 0
    property real totalKm: 0
    property real tripKm: 0
    property bool leftTurn: false
    property bool rightTurn: false
    property bool highBeam: false
    property bool oil: false
    property bool engine: false
    property bool abs: false
    property bool batteryWarn: false
    property bool parkingBrake: false

    implicitWidth: 720
    implicitHeight: 360
    padding: 10

    function setSpeed(v) { speed = v }
    function setRpm(v) { rpm = v }

    contentItem: ColumnLayout {
        spacing: 8
        TelltaleBar {
            Layout.fillWidth: true
            leftTurn: root.leftTurn
            rightTurn: root.rightTurn
            highBeam: root.highBeam
            oil: root.oil
            engine: root.engine
            abs: root.abs
            battery: root.batteryWarn
            parkingBrake: root.parkingBrake
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8
            TachometerGauge {
                Layout.fillHeight: true
                Layout.preferredWidth: 180
                value: root.rpm
                maximum: root.rpmMax
                redline: root.redline
                title: qsTr("RPM")
            }
            SpeedometerGauge {
                Layout.fillHeight: true
                Layout.fillWidth: true
                value: root.speed
                maximum: root.speedMax
                unit: root.speedUnit
            }
            ColumnLayout {
                Layout.preferredWidth: 148
                Layout.fillHeight: true
                FuelGauge {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    value: root.fuel
                    title: qsTr("Fuel")
                }
                CoolantGauge {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    value: root.coolant
                    title: qsTr("Temp")
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            GearIndicator {
                gear: root.gear
                gearNumber: root.gearNumber
            }
            OdometerGauge {
                Layout.fillWidth: true
                totalKm: root.totalKm
                tripKm: root.tripKm
            }
            VoltageGauge {
                Layout.preferredWidth: 140
                value: root.voltage
                title: qsTr("Batt")
            }
            BoostGauge {
                Layout.preferredWidth: 132
                Layout.preferredHeight: 108
                value: root.boost
                title: qsTr("Boost")
            }
        }
    }
    background: Rectangle {
        radius: Theme.cornerCard
        color: Theme.bgCard
        border.width: 1
        border.color: Theme.strokeCard
    }
}

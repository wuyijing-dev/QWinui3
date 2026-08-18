import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("TelltaleBar")
    subtitle: qsTr("Experimental cluster warning lamps. Prefer InfoBadge for app status dots.")

    ControlExample {
        headerText: qsTr("Lamps")
        qmlSource: "TelltaleBar { oil: true; leftTurn: true }"
        ColumnLayout {
            spacing: Theme.spacing
            TelltaleBar {
                id: lamps
                title: qsTr("Telltales")
                Layout.fillWidth: true
                leftTurn: leftBox.checked
                rightTurn: rightBox.checked
                highBeam: beamBox.checked
                oil: oilBox.checked
                engine: milBox.checked
                abs: absBox.checked
                battery: battBox.checked
                parkingBrake: parkBox.checked
                doors: doorBox.checked
                belt: beltBox.checked
            }
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                CheckBox { id: leftBox; text: qsTr("Left"); checked: true }
                CheckBox { id: rightBox; text: qsTr("Right") }
                CheckBox { id: beamBox; text: qsTr("Beam") }
                CheckBox { id: oilBox; text: qsTr("Oil"); checked: true }
                CheckBox { id: milBox; text: qsTr("MIL") }
                CheckBox { id: absBox; text: qsTr("ABS") }
                CheckBox { id: battBox; text: qsTr("Batt") }
                CheckBox { id: parkBox; text: qsTr("Park") }
                CheckBox { id: doorBox; text: qsTr("Door") }
                CheckBox { id: beltBox; text: qsTr("Belt") }
            }
        }
    }
}

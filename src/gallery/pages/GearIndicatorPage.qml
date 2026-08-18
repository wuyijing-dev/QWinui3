import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("GearIndicator")
    subtitle: qsTr("Experimental PRNDS readout. Prefer DigitGauge for a generic numeric face.")

    ControlExample {
        headerText: qsTr("Selector")
        qmlSource: "GearIndicator { gear: \"D\"; gearNumber: 4 }"
        ColumnLayout {
            spacing: Theme.spacing
            GearIndicator {
                id: gear
                title: qsTr("Gear")
                gear: "D"
                gearNumber: 4
            }
            RowLayout {
                Repeater {
                    model: ["P", "R", "N", "D", "S", "M"]
                    Button {
                        required property var modelData
                        text: String(modelData)
                        highlighted: String(modelData) === String(gear.gear).toUpperCase()
                        onClicked: gear.setGear(String(modelData), String(modelData) === "P" || String(modelData) === "R" || String(modelData) === "N" ? 0 : 4)
                    }
                }
            }
        }
    }
}

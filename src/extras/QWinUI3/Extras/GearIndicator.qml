import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// GearIndicator — PRNDS / manual gear readout for a cluster.
//
//   GearIndicator { gear: "D"; gearNumber: 4 }
//
// @notes
//   Experimental. Compose in AutomotiveCluster. Not a stable-six type.

T.Control {
    id: root
    Accessible.role: Accessible.StaticText
    Accessible.name: title.length ? title : qsTr("Gear")
    Accessible.description: displayText

    property string gear: "P"
    property int gearNumber: 0
    property string title: ""
    property var gears: ["P", "R", "N", "D", "S", "M"]

    implicitWidth: 240
    implicitHeight: title.length ? 72 : 56
    padding: 8

    readonly property string displayText: {
        var g = String(gear).toUpperCase()
        if ((g === "M" || g === "S" || g === "D") && gearNumber > 0)
            return g + String(gearNumber)
        return g
    }

    function setGear(g, n) {
        gear = g
        if (n !== undefined)
            gearNumber = n
    }

    contentItem: ColumnLayout {
        spacing: 4
        Text {
            visible: root.title.length > 0
            text: root.title
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
        Row {
            spacing: 8
            Repeater {
                model: root.gears
                Text {
                    required property var modelData
                    text: String(modelData)
                    font.family: Theme.fontFamilyDisplay
                    font.pixelSize: String(modelData) === String(root.gear).toUpperCase() ? Theme.fontTitle : Theme.fontBody
                    font.weight: String(modelData) === String(root.gear).toUpperCase() ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
                    color: String(modelData) === String(root.gear).toUpperCase() ? Theme.accent : Theme.textSecondary
                }
            }
            Text {
                visible: root.gearNumber > 0 && (String(root.gear).toUpperCase() === "D" || String(root.gear).toUpperCase() === "S" || String(root.gear).toUpperCase() === "M")
                text: String(root.gearNumber)
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontTitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
        }
    }
    background: Item {}
}

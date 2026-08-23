import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// OdometerGauge — Total and trip distance.
//
//   OdometerGauge { totalKm: 12480.3; tripKm: 36.2 }
//
//   // --- API ---
//   // methods: setTotal(v), setTrip(v), resetTrip()
//
// @notes
//   Experimental cluster odometer. Prefer DigitGauge for a generic numeric face.

T.Control {
    id: root
    Accessible.role: Accessible.StaticText
    Accessible.name: title.length ? title : qsTr("Odometer")
    Accessible.description: formattedTotal + " / " + formattedTrip

    property real totalKm: 0
    property real tripKm: 0
    property string title: ""
    property string unit: "km"
    property int tripPrecision: 1
    property int totalPrecision: 1

    implicitWidth: 200
    implicitHeight: title.length ? 72 : 56
    padding: 8

    readonly property string formattedTotal: Number(totalKm).toFixed(totalPrecision) + " " + unit
    readonly property string formattedTrip: Number(tripKm).toFixed(tripPrecision) + " " + unit

    function setTotal(v) { totalKm = Math.max(0, v) }
    function setTrip(v) { tripKm = Math.max(0, v) }
    function resetTrip() { tripKm = 0 }

    contentItem: ColumnLayout {
        spacing: 2
        Text {
            visible: root.title.length > 0
            text: root.title
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
        RowLayout {
            Text {
                text: qsTr("ODO")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                text: root.formattedTotal
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }
        }
        RowLayout {
            Text {
                text: qsTr("TRIP")
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                text: root.formattedTrip
                font.pixelSize: Theme.fontBody
                color: Theme.textPrimary
            }
        }
    }
    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }
}

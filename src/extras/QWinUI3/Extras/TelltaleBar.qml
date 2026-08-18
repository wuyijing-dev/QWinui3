import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TelltaleBar — Cluster warning / indicator lamps.
//
//   TelltaleBar { oil: true; leftTurn: true }
//
// @notes
//   Experimental telltales. Prefer InfoBadge for app status dots.

T.Control {
    id: root
    Accessible.role: Accessible.Grouping
    Accessible.name: title.length ? title : qsTr("Telltales")

    property string title: ""
    property bool leftTurn: false
    property bool rightTurn: false
    property bool highBeam: false
    property bool oil: false
    property bool engine: false
    property bool abs: false
    property bool battery: false
    property bool parkingBrake: false
    property bool doors: false
    property bool belt: false
    property int blinkMs: 400

    implicitWidth: 420
    implicitHeight: title.length ? 52 : 36
    padding: 6

    property bool _blinkOn: true
    Timer {
        interval: root.blinkMs
        running: root.leftTurn || root.rightTurn
        repeat: true
        onTriggered: root._blinkOn = !root._blinkOn
        onRunningChanged: if (!running) root._blinkOn = true
    }

    contentItem: ColumnLayout {
        spacing: 4
        Text {
            visible: root.title.length > 0
            text: root.title
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
        Flow {
            Layout.fillWidth: true
            spacing: 8
            Repeater {
                model: [
                    { on: root.leftTurn && root._blinkOn, label: qsTr("←"), color: Theme.systemSuccess },
                    { on: root.highBeam, label: qsTr("BEAM"), color: Theme.accent },
                    { on: root.oil, label: qsTr("OIL"), color: Theme.systemCritical },
                    { on: root.engine, label: qsTr("MIL"), color: Theme.systemCaution },
                    { on: root.abs, label: qsTr("ABS"), color: Theme.systemCaution },
                    { on: root.battery, label: qsTr("BAT"), color: Theme.systemCritical },
                    { on: root.parkingBrake, label: qsTr("P"), color: Theme.systemCritical },
                    { on: root.doors, label: qsTr("DOOR"), color: Theme.systemCaution },
                    { on: root.belt, label: qsTr("BELT"), color: Theme.systemCritical },
                    { on: root.rightTurn && root._blinkOn, label: qsTr("→"), color: Theme.systemSuccess }
                ]
                Rectangle {
                    required property var modelData
                    radius: 4
                    implicitHeight: 22
                    implicitWidth: lampLabel.implicitWidth + 12
                    color: modelData.on ? Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.28) : Theme.fillSubtle
                    border.width: 1
                    border.color: modelData.on ? modelData.color : Theme.strokeDivider
                    opacity: modelData.on ? 1 : 0.35
                    Text {
                        id: lampLabel
                        anchors.centerIn: parent
                        text: modelData.label
                        font.pixelSize: Theme.fontCaption - 1
                        font.weight: Theme.fontWeightSemiBold
                        color: modelData.on ? modelData.color : Theme.textSecondary
                    }
                }
            }
        }
    }
    background: Item {}
}

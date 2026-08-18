import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// TpmsGauge — Four-corner tire pressure.
//
//   TpmsGauge { fl: 2.3; fr: 2.3; rl: 2.4; rr: 2.1 }
//
// @notes
//   Experimental TPMS. Prefer KpiTile for a single pressure KPI.

T.Control {
    id: root
    Accessible.role: Accessible.Grouping
    Accessible.name: title.length ? title : qsTr("TPMS")

    property string title: ""
    property string unit: "bar"
    property real fl: 2.3
    property real fr: 2.3
    property real rl: 2.4
    property real rr: 2.4
    property real warnBelow: 2.0
    property real warnAbove: 2.8

    implicitWidth: 160
    implicitHeight: title.length ? 140 : 124
    padding: 8

    function _color(v) {
        if (v < warnBelow || v > warnAbove)
            return Theme.systemCritical
        return Theme.systemSuccess
    }

    function _fmt(v) { return Number(v).toFixed(1) }

    contentItem: ColumnLayout {
        spacing: 4
        Text {
            visible: root.title.length > 0
            text: root.title
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Rectangle {
                id: body
                width: Math.min(parent.width * 0.34, 42)
                height: parent.height * 0.62
                radius: 8
                anchors.centerIn: parent
                color: Theme.fillSubtle
                border.color: Theme.strokeControl
                border.width: 1
            }
            Text { anchors.left: parent.left; anchors.top: parent.top; text: root._fmt(root.fl) + " " + root.unit; color: root._color(root.fl); font.pixelSize: Theme.fontCaption }
            Text { anchors.right: parent.right; anchors.top: parent.top; text: root._fmt(root.fr) + " " + root.unit; color: root._color(root.fr); font.pixelSize: Theme.fontCaption }
            Text { anchors.left: parent.left; anchors.bottom: parent.bottom; text: root._fmt(root.rl) + " " + root.unit; color: root._color(root.rl); font.pixelSize: Theme.fontCaption }
            Text { anchors.right: parent.right; anchors.bottom: parent.bottom; text: root._fmt(root.rr) + " " + root.unit; color: root._color(root.rr); font.pixelSize: Theme.fontCaption }
        }
    }
    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.fillSubtle
        border.width: 1
        border.color: Theme.strokeCard
    }
}

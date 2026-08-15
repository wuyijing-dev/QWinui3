import QtQuick
import QtQuick.Templates as T
import QWinUI3.Theme

// DayOfWeekRow — Fluent styled DayOfWeekRow.
//
//   DayOfWeekRow { }

T.AbstractDayOfWeekRow {
    id: control

    implicitWidth: 280
    implicitHeight: 32
    spacing: 2
    leftPadding: 8
    rightPadding: 8
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontCaption

    delegate: Item {
        required property string shortName
        implicitWidth: 36
        implicitHeight: 28

        Text {
            anchors.fill: parent
            text: shortName
            font.family: control.font.family
            font.pixelSize: control.font.pixelSize
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textSecondary
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            opacity: 0.9
        }
    }

    contentItem: Row {
        spacing: control.spacing
        Repeater {
            model: control.source
            delegate: control.delegate
        }
    }
}

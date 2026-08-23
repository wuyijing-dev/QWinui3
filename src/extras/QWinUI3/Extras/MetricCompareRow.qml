import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// MetricCompareRow — Side-by-side KpiTile row with a shared period caption (2.65).
//
//   MetricCompareRow {
//       periodLabel: qsTr("vs last week")
//       KpiTile { title: qsTr("Revenue"); value: 128; compareValue: 110 }
//       KpiTile { title: qsTr("Orders"); value: 42; compareValue: 40 }
//   }
//
// @notes
//   Compose host for dashboard KPI compare strips. Put KpiTile (or any Item) as children.
//   periodLabel draws once above the row; tiles keep their own compareValue / delta.

T.Control {
    id: root

    // Shared period caption above the KPI row
    property string periodLabel: ""
    // Horizontal spacing between tiles
    property real tileSpacing: Theme.spacingLoose
    // Children (typically KpiTile)
    default property alias content: tileRow.data

    implicitWidth: 480
    implicitHeight: Math.max(120, header.implicitHeight + tileRow.implicitHeight + padding * 2)
    padding: 0

    contentItem: ColumnLayout {
        spacing: Theme.spacingTight

        Text {
            id: header
            Layout.fillWidth: true
            visible: root.periodLabel.length > 0
            text: root.periodLabel
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            elide: Text.ElideRight
        }

        RowLayout {
            id: tileRow
            Layout.fillWidth: true
            spacing: root.tileSpacing
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QWinUI3.Theme

// DashboardShell — Minimal dashboard layout host (2.52 preview; chart grid + filter rail in 2.65).
//
//   DashboardShell {
//       title: qsTr("Ops")
//       subtitle: qsTr("Last 24h")
//       kpiRow: RowLayout {
//           KpiTile { title: qsTr("Users"); value: 1284 }
//       }
//       ContentCard { title: qsTr("Details") }
//   }
//
// @notes
//   Opinionated column: optional title block, KPI row slot, default body (charts/cards).
//   Experimental until 2.65 deepens grid + TwoPaneView filter rail — docs/first-app-252.md.

Item {
    id: root

    implicitWidth: 640
    implicitHeight: 480

    property string title: ""
    property string subtitle: ""
    property alias kpiRow: kpiHost.data
    default property alias content: bodyHost.data

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacingSection

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingTight
            visible: root.title.length > 0 || root.subtitle.length > 0

            Text {
                Layout.fillWidth: true
                visible: root.title.length > 0
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontTitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                elide: Text.ElideRight
            }
            Text {
                Layout.fillWidth: true
                visible: root.subtitle.length > 0
                text: root.subtitle
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
                wrapMode: Text.WordWrap
            }
        }

        RowLayout {
            id: kpiHost
            Layout.fillWidth: true
            spacing: Theme.spacing
        }

        ColumnLayout {
            id: bodyHost
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacingSection
        }
    }
}

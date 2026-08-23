import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QWinUI3.Theme

// DashboardShell — Opinionated dashboard layout host (2.65 Wave A).
//
//   DashboardShell {
//       title: qsTr("Ops")
//       subtitle: qsTr("Last 24h")
//       filterPane: ColumnLayout {
//           ComboBox { model: [qsTr("Last 24h"), qsTr("Last 7d")] }
//       }
//       kpiRow: MetricCompareRow {
//           periodLabel: qsTr("vs last week")
//           KpiTile { title: qsTr("Users"); value: 1284; compareValue: 1200 }
//       }
//       ChartCard { title: qsTr("Trend"); LineChart { values: series } }
//   }
//
// @notes
//   Title + KPI strip + body. Optional filterPane uses TwoPaneView (≥ filterBreakpoint
//   wide; otherwise SinglePane shows body — toggle filter via TwoPaneView APIs).
//   chartColumns is a layout hint for GridLayout children. Not the withdrawn Hub.

Item {
    id: root

    implicitWidth: 720
    implicitHeight: 520

    // Page title
    property string title: ""
    // Supporting subtitle
    property string subtitle: ""
    // KPI strip (MetricCompareRow / RowLayout of KpiTile)
    property alias kpiRow: kpiHost.data
    // Optional filter rail (TwoPaneView pane1)
    property alias filterPane: filterHost.data
    // Chart / card body
    default property alias content: bodyHost.data
    // Hint for GridLayout columns in demos
    property int chartBreakpoint: 900
    readonly property int chartColumns: width >= chartBreakpoint ? 2 : 1
    // Wide mode threshold for filter | body
    property int filterBreakpoint: 720
    // Preferred filter rail width when wide
    property real filterPaneWidth: 240

    readonly property bool _hasFilter: filterHost.children.length > 0

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
            visible: children.length > 0
        }

        TwoPaneView {
            id: panes
            Layout.fillWidth: true
            Layout.fillHeight: true
            preferredMode: TwoPaneView.Wide
            minWideWidth: root.filterBreakpoint
            panePriorityWidth: root.filterPaneWidth
            // No filter → body-only SinglePane; with filter → leftRight when wide.
            // Narrow + filter: keep charts (pane2) visible — filters return when wide.
            wideModeConfiguration: root._hasFilter ? "leftRight" : "singlePane"
            singlePaneIndex: 1
            panePriority: TwoPaneView.Pane2

            pane1: Rectangle {
                color: Theme.bgCard
                border.width: root._hasFilter ? 1 : 0
                border.color: Theme.strokeCard
                radius: Theme.cornerCard
                visible: root._hasFilter
                clip: true

                ScrollView {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing
                    clip: true
                    contentWidth: availableWidth

                    ColumnLayout {
                        id: filterHost
                        width: Math.max(160, panes.panePriorityWidth - 2 * Theme.spacing)
                        spacing: Theme.spacing
                    }
                }
            }

            pane2: Flickable {
                clip: true
                contentWidth: width
                contentHeight: bodyHost.implicitHeight
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: bodyHost
                    width: parent.width
                    spacing: Theme.spacingSection
                }
            }
        }
    }
}

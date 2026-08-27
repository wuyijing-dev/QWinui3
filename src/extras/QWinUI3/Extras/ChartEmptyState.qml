import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ChartEmptyState — Fluent empty / loading / error placeholder for ChartCard (2.65).
//
//   ChartCard {
//       title: qsTr("Revenue")
//       ChartEmptyState {
//           state: "empty"
//           title: qsTr("No data yet")
//           message: qsTr("Connect a source or widen the date range.")
//           actionText: qsTr("Refresh")
//           onActionClicked: reload()
//       }
//   }
//
// @notes
//   state: "empty" | "loading" | "error". Optional actionText emits actionClicked.

T.Control {
    id: root

    // Visual mode: empty | loading | error
    property string state: "empty"
    // Primary title
    property string title: {
        if (state === "loading")
            return qsTr("Loading…")
        if (state === "error")
            return qsTr("Couldn't load chart")
        return qsTr("No data")
    }
    // Supporting message
    property string message: ""
    // Optional action button label (hidden when empty)
    property string actionText: ""
    // FluentIcons symbol override (empty → default per state)
    property var symbol: ""

    signal actionClicked()

    implicitWidth: 240
    implicitHeight: 160
    padding: Theme.spacingLoose

    readonly property string _glyph: {
        if (symbol !== undefined && String(symbol).length)
            return IconSource.resolve(symbol, "")
        if (state === "loading")
            return FluentIcons.ProgressRingCommon
        if (state === "error")
            return FluentIcons.ErrorBadge
        return FluentIcons.AreaChart
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacing

        Item {
            Layout.alignment: Qt.AlignHCenter
            width: 40
            height: 40

            BusyIndicator {
                anchors.centerIn: parent
                running: root.state === "loading"
                visible: running
                width: 28
                height: 28
            }

            Text {
                anchors.centerIn: parent
                visible: root.state !== "loading"
                text: root._glyph
                font: Theme.iconFontFor(28)
                color: root.state === "error" ? Theme.systemCritical : Theme.textSecondary
            }
        }

        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: root.title
            font.pixelSize: Theme.fontBody
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            wrapMode: Text.WordWrap
        }

        Text {
            Layout.fillWidth: true
            visible: root.message.length > 0
            horizontalAlignment: Text.AlignHCenter
            text: root.message
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            wrapMode: Text.WordWrap
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            visible: root.actionText.length > 0 && root.state !== "loading"
            text: root.actionText
            onClicked: root.actionClicked()
        }
    }
}

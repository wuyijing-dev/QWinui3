import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — CommandBar.
//
// Fluent More/Chevron, toggle(), secondaryCommands, and open/close signals. API: docs/components/CommandBar.md

CatalogPage {
    title: qsTr("CommandBar")
    subtitle: qsTr("Primary AppBar row, JS overflow, and secondaryCommandsHost AppBar buttons.")

    ControlExample {
        headerText: qsTr("Primary commands")
        qmlSource: "CommandBar {\n    AppBarButton { … }\n    secondaryCommandsHost: AppBarButton { text: \"Share\" }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Label { text: qsTr("Label"); color: Theme.textSecondary }
                ComboBox {
                    id: labelPos
                    model: ["bottom", "right", "collapsed"]
                    currentIndex: 0
                    Layout.preferredWidth: 140
                }
                Label { text: qsTr("Closed"); color: Theme.textSecondary }
                ComboBox {
                    id: closedMode
                    model: ["compact", "minimal", "hidden"]
                    currentIndex: 0
                    Layout.preferredWidth: 140
                }
            }
            CommandBar {
                id: cmdBar
                Layout.fillWidth: true
                defaultLabelPosition: labelPos.currentText
                closedDisplayMode: closedMode.currentText
                secondaryCommands: [
                    {
                        text: qsTr("Select all"),
                        triggered: function () { status.text = qsTr("Select all") }
                    },
                    {
                        text: qsTr("Find"),
                        triggered: function () { status.text = qsTr("Find") }
                    }
                ]
                secondaryCommandsHost: [
                    AppBarButton {
                        symbol: FluentIcons.Share
                        text: qsTr("Share")
                        onClicked: status.text = qsTr("Share (host)")
                    },
                    AppBarToggleButton {
                        symbol: FluentIcons.Pin
                        text: qsTr("Pin")
                        onClicked: status.text = checked ? qsTr("Pinned") : qsTr("Unpinned")
                    }
                ]
                onOpened: status.text = qsTr("Command bar opened")
                onClosed: status.text = qsTr("Command bar closed")
                AppBarButton {
                    symbol: FluentIcons.Copy
                    text: qsTr("Copy")
                    onClicked: status.text = qsTr("Copy")
                }
                AppBarButton {
                    symbol: FluentIcons.Cut
                    text: qsTr("Cut")
                    onClicked: status.text = qsTr("Cut")
                }
                AppBarSeparator {}
                AppBarButton {
                    symbol: FluentIcons.Delete
                    text: qsTr("Delete")
                    onClicked: status.text = qsTr("Delete")
                }
            }
            Label {
                id: status
                text: qsTr("Ready — … opens JS overflow + AppBar secondaryCommandsHost.")
                color: Theme.textSecondary
            }
        }
    }
}

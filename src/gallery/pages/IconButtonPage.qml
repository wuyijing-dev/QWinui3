import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — IconButton.

CatalogPage {
    title: qsTr("IconButton")
    subtitle: qsTr("Icon-only button with Fluent symbol, badge, and Accessible name from toolTip.")

    ControlExample {
        headerText: qsTr("Icons")
        qmlSource: "IconButton {\n    symbol: FluentIcons.Copy\n    badgeValue: 3\n}"
        ColumnLayout {
            spacing: Theme.spacing
            RowLayout {
                spacing: Theme.spacing
                IconButton {
                    symbol: FluentIcons.Copy
                    toolTipText: qsTr("Copy")
                    onClicked: status.text = qsTr("Copy")
                }
                IconButton {
                    symbol: FluentIcons.Cut
                    toolTipText: qsTr("Cut")
                    onClicked: status.text = qsTr("Cut")
                }
                IconButton {
                    symbol: FluentIcons.Delete
                    highlighted: true
                    toolTipText: qsTr("Delete")
                    onClicked: status.text = qsTr("Delete")
                }
                IconButton {
                    symbol: FluentIcons.Refresh
                    flat: false
                    toolTipText: qsTr("Refresh")
                    onClicked: status.text = qsTr("Refresh")
                }
                IconButton {
                    symbol: FluentIcons.Mail
                    toolTipText: qsTr("Notifications")
                    badgeValue: 3
                    onClicked: status.text = qsTr("Notifications")
                }
                IconButton { symbol: FluentIcons.ChromeClose; enabled: false; toolTipText: qsTr("Close") }
            }
            Label {
                id: status
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
        }
    }
}

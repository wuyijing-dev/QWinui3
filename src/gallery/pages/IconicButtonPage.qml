import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — IconicButton (base for IconButton / AppBar*).

CatalogPage {
    title: qsTr("IconicButton")
    subtitle: qsTr("Base icon + label button with badge, flat/highlighted chrome, and FocusStroke.")

    ControlExample {
        headerText: qsTr("Symbol + text")
        qmlSource: "IconicButton {\n    text: \"Open\"\n    symbol: FluentIcons.Open\n}"

        ColumnLayout {
            spacing: Theme.spacing
            RowLayout {
                spacing: Theme.spacing
                IconicButton {
                    text: qsTr("Open")
                    symbol: FluentIcons.Open
                    flat: false
                    onClicked: status.text = qsTr("Open")
                }
                IconicButton {
                    text: qsTr("Save")
                    symbol: FluentIcons.Save
                    highlighted: true
                    onClicked: status.text = qsTr("Save")
                }
                IconicButton {
                    text: qsTr("Mail")
                    symbol: FluentIcons.Mail
                    badgeValue: 4
                    onClicked: status.text = qsTr("Mail")
                }
                IconicButton {
                    text: qsTr("Disabled")
                    symbol: FluentIcons.Cancel
                    enabled: false
                }
            }
            Label {
                id: status
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
        }
    }
}

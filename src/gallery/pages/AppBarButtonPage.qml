import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AppBarButton.
//
// Icon-and-label command button with badge and tool tip. API: docs/components/AppBarButton.md

CatalogPage {
    title: qsTr("AppBarButton")
    subtitle: qsTr("Icon-and-label command button with badge and tool tip.")

    ControlExample {
        headerText: qsTr("Commands")
        qmlSource: "AppBarButton {\n    symbol: FluentIcons.Mail\n    badgeValue: 3\n}"
        ColumnLayout {
            spacing: Theme.spacing
            CheckBox {
                id: compactBox
                text: qsTr("IsCompact")
            }
            RowLayout {
                spacing: Theme.spacingLoose
                AppBarButton {
                    symbol: FluentIcons.Copy
                    text: qsTr("Copy")
                    isCompact: compactBox.checked
                    keyboardAcceleratorText: "Ctrl+C"
                    toolTipText: qsTr("Copy selection")
                    onClicked: status.text = qsTr("Copy")
                }
                AppBarButton {
                    symbol: FluentIcons.Mail
                    text: qsTr("Mail")
                    badgeValue: 3
                    isCompact: compactBox.checked
                    toolTipText: qsTr("3 unread")
                    onClicked: status.text = qsTr("Mail")
                }
                AppBarButton {
                    symbol: FluentIcons.Delete
                    text: qsTr("Delete")
                    isCompact: compactBox.checked
                    keyboardAcceleratorText: "Del"
                    onClicked: status.text = qsTr("Delete")
                }
                AppBarButton {
                    symbol: FluentIcons.Save
                    text: qsTr("Save")
                    highlighted: true
                    isCompact: compactBox.checked
                    keyboardAcceleratorText: "Ctrl+S"
                    onClicked: status.text = qsTr("Save")
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

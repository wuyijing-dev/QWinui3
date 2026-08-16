import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Expander.

CatalogPage {
    title: qsTr("Expander")
    subtitle: qsTr("Collapsible card with symbol header and Fluent ChevronDown animation.")

    ControlExample {
        headerText: qsTr("Basic Expander")
        qmlSource: "Expander {\n    symbol: FluentIcons.Settings\n    title: \"More options\"\n}"

        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: 480
            spacing: Theme.spacing
            RowLayout {
                Label { text: qsTr("Direction"); color: Theme.textSecondary }
                ComboBox {
                    id: dirBox
                    model: ["down", "up"]
                    currentIndex: 0
                    Layout.preferredWidth: 120
                }
            }
            Expander {
                title: qsTr("More options")
                subtitle: qsTr("Advanced preferences for this feature")
                symbol: FluentIcons.Settings
                expanded: true
                expandDirection: dirBox.currentText

                Label {
                    text: qsTr("Additional details are shown when the expander is open.")
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    color: Theme.textSecondary
                }
                Button {
                    text: qsTr("Action")
                }
            }
            Expander {
                symbol: FluentIcons.Contact
                expanded: false
                headerContent: RowLayout {
                    spacing: Theme.spacing
                    Label {
                        text: qsTr("Notifications")
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                        Layout.fillWidth: true
                    }
                    InfoBadge {
                        id: headerBadge
                        value: 3
                        severity: headerBadge.informational
                    }
                    Switch {
                        checked: true
                    }
                }
                Label {
                    text: qsTr("Custom WinUI Header slot — badge + switch beside the title.")
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    color: Theme.textSecondary
                }
            }
        }
    }
}

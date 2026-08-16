import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SettingsExpander.

CatalogPage {
    title: qsTr("SettingsExpander")
    subtitle: qsTr("Expandable settings group — nested cards, header alias, master toggle.")

    ControlExample {
        headerText: qsTr("Nested settings")
        qmlSource: "SettingsExpander {\n    header: qsTr(\"Privacy\")\n    toggle: true\n    SettingsCard { … }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: expStatus
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
            SettingsExpander {
                header: qsTr("Privacy")
                description: qsTr("Control how your data is used.")
                symbol: FluentIcons.Lock
                expanded: true
                toggle: true
                checked: true
                onToggled: expStatus.text = checked ? qsTr("Privacy master on") : qsTr("Privacy master off")
                onExpanding: expStatus.text = qsTr("Expanding…")
                onCollapsing: expStatus.text = qsTr("Collapsing…")

                SettingsCard {
                    title: qsTr("Diagnostics")
                    description: qsTr("Send optional diagnostic data.")
                    toggle: true
                    checked: true
                }
                SettingsCard {
                    title: qsTr("Advertising ID")
                    description: qsTr("Let apps use advertising ID.")
                    toggle: true
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SettingsExpander.

CatalogPage {
    title: qsTr("SettingsExpander")
    subtitle: qsTr("Expandable settings group with symbol header and Fluent ChevronDown.")

    ControlExample {
        headerText: qsTr("Nested settings")
        qmlSource: "SettingsExpander {\n    toggle: true\n    SettingsCard { toggle: true }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: expStatus
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
            SettingsExpander {
                title: qsTr("Privacy")
                description: qsTr("Control how your data is used.")
                symbol: FluentIcons.Lock
                expanded: true
                toggle: true
                checked: true
                onToggled: expStatus.text = checked ? qsTr("Privacy master on") : qsTr("Privacy master off")
                onExpanding: expStatus.text = qsTr("Expanding…")
                onCollapsing: expStatus.text = qsTr("Collapsing…")

                ColumnLayout {
                    width: parent.width
                    spacing: Theme.spacing
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
}

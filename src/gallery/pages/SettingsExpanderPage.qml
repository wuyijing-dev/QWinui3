import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SettingsExpander.
//
// Expandable settings group with symbol header and Fluent ChevronDown. API: docs/components/SettingsExpander.md

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("SettingsExpander")
                subtitle: qsTr("Expandable settings group with symbol header and Fluent ChevronDown.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Nested settings")
                qmlSource: "SettingsExpander {\n    SettingsCard { toggle: true }\n}"
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
                        action: Switch {
                            checked: true
                            onToggled: expStatus.text = checked ? qsTr("Privacy master on") : qsTr("Privacy master off")
                        }
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

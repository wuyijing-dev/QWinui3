import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Expander.
//
// Collapsible card with symbol header and Fluent ChevronDown animation. API: docs/components/Expander.md

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
                title: qsTr("Expander")
                subtitle: qsTr("Collapsible card with symbol header and Fluent ChevronDown animation.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                        Layout.fillWidth: true
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
                        Layout.fillWidth: true
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
                                onClicked: { /* keep header button from fighting */ }
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

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

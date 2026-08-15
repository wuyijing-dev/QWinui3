import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

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
                title: qsTr("MenuFlyoutItem")
                subtitle: qsTr("Flyout menu rows with glyphs, toggles, radios, and headers.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Rich menu")
                qmlSource: "MenuFlyout {\n    MenuFlyoutItem { text: \"Copy\"; iconGlyph: \"\\uE8C8\" }\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    Button {
                        id: richBtn
                        text: qsTr("Open flyout")
                        onClicked: richFlyout.showAt(richBtn)
                    }
                    Label {
                        text: qsTr("Last action: %1").arg(lastAction.text.length ? lastAction.text : qsTr("(none)"))
                        color: Theme.textSecondary
                    }
                    QtObject { id: lastAction; property string text: "" }
                    MenuFlyout {
                        id: richFlyout
                        MenuFlyoutHeader { text: qsTr("Clipboard") }
                        MenuFlyoutItem {
                            text: qsTr("Copy")
                            iconGlyph: "\uE8C8"
                            keyboardAcceleratorText: "Ctrl+C"
                            keyVisualAccelerator: true
                            onTriggered: lastAction.text = text
                        }
                        MenuFlyoutItem {
                            text: qsTr("Paste")
                            iconGlyph: "\uE77F"
                            keyboardAcceleratorText: "Ctrl+V"
                            keyVisualAccelerator: true
                            onTriggered: lastAction.text = text
                        }
                        MenuFlyoutSeparator {}
                        MenuFlyoutHeader { text: qsTr("Options") }
                        ToggleMenuFlyoutItem {
                            text: qsTr("Show grid")
                            checked: true
                            onTriggered: lastAction.text = text + (checked ? qsTr(" on") : qsTr(" off"))
                        }
                        ToggleMenuFlyoutItem {
                            text: qsTr("Snap to pixel")
                            onTriggered: lastAction.text = text
                        }
                        MenuFlyoutSeparator {}
                        MenuFlyoutHeader { text: qsTr("View") }
                        RadioMenuFlyoutItem {
                            text: qsTr("Compact")
                            checked: true
                            onTriggered: lastAction.text = text
                        }
                        RadioMenuFlyoutItem {
                            text: qsTr("Comfortable")
                            onTriggered: lastAction.text = text
                        }
                        RadioMenuFlyoutItem {
                            text: qsTr("Spacious")
                            onTriggered: lastAction.text = text
                        }
                        MenuFlyoutSeparator {}
                        MenuFlyoutItem {
                            text: qsTr("Delete")
                            iconGlyph: "\uE74D"
                            iconColor: Theme.systemCritical
                            onTriggered: lastAction.text = text
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

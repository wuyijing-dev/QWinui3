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
                title: qsTr("MenuFlyout")
                subtitle: qsTr("A command flyout menu anchored to a control.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Show at button")
                qmlSource: "MenuFlyout {\n    MenuItem { text: \"Copy\" }\n}\nflyout.showAt(button)"
                Button {
                    id: flyoutButton
                    text: qsTr("Open menu")
                    onClicked: demoFlyout.showAt(flyoutButton)
                }
                MenuFlyout {
                    id: demoFlyout
                    MenuFlyoutItem {
                        text: qsTr("Copy")
                        iconGlyph: "\uE8C8"
                        keyboardAcceleratorText: "Ctrl+C"
                        onTriggered: lastAction.text = text
                    }
                    MenuFlyoutItem {
                        text: qsTr("Paste")
                        iconGlyph: "\uE77F"
                        keyboardAcceleratorText: "Ctrl+V"
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
                Label {
                    text: qsTr("Last action: %1").arg(lastAction.text.length ? lastAction.text : qsTr("(none)"))
                    color: Theme.textSecondary
                }
                QtObject { id: lastAction; property string text: "" }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

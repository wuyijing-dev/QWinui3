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
                subtitle: qsTr("Elevated command menu with isOpen, preferredPlacement, and enter/exit motion.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Show at button")
                qmlSource: "MenuFlyout {\n    preferredPlacement: Qt.AlignBottom\n    isOpen: …\n}"
                Button {
                    id: flyoutButton
                    text: qsTr("Open menu")
                    onClicked: demoFlyout.showAt(flyoutButton)
                }
                MenuFlyout {
                    id: demoFlyout
                    preferredPlacement: Qt.AlignBottom
                    MenuFlyoutItem {
                        text: qsTr("Copy")
                        icon: FluentIcons.Copy
                        keyboardAcceleratorText: "Ctrl+C"
                        onTriggered: lastAction.text = text
                    }
                    MenuFlyoutItem {
                        text: qsTr("Paste")
                        icon: FluentIcons.Paste
                        keyboardAcceleratorText: "Ctrl+V"
                        onTriggered: lastAction.text = text
                    }
                    MenuFlyoutSeparator {}
                    MenuFlyoutItem {
                        text: qsTr("Delete")
                        icon: FluentIcons.Delete
                        iconColor: Theme.systemCritical
                        onTriggered: lastAction.text = text
                    }
                }
                Label {
                    text: qsTr("Open: %1 — Last: %2")
                        .arg(demoFlyout.isOpen ? qsTr("yes") : qsTr("no"))
                        .arg(lastAction.text.length ? lastAction.text : qsTr("(none)"))
                    color: Theme.textSecondary
                }
                QtObject { id: lastAction; property string text: "" }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

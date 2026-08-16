import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — MenuFlyout.
//
// Elevated menu with title, isOpen, preferredPlacement, and motion. API: docs/components/MenuFlyout.md

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
                subtitle: qsTr("Elevated menu with title, isOpen, preferredPlacement, and motion.")
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
                CheckBox {
                    id: maxH
                    text: qsTr("MaxHeight 160 (scroll)")
                    checked: false
                }
                CheckBox {
                    id: constrainBounds
                    text: qsTr("Constrain to bounds")
                    checked: true
                }
                MenuFlyout {
                    id: demoFlyout
                    preferredPlacement: Qt.AlignBottom
                    title: qsTr("Actions")
                    contentMaxHeight: maxH.checked ? 160 : 0
                    shouldConstrainToRootBounds: constrainBounds.checked
                    MenuFlyoutItem {
                        text: qsTr("Copy")
                        symbol: FluentIcons.Copy
                        keyboardAcceleratorText: "Ctrl+C"
                        onTriggered: lastAction.text = text
                    }
                    MenuFlyoutItem {
                        text: qsTr("Paste")
                        symbol: FluentIcons.Paste
                        keyboardAcceleratorText: "Ctrl+V"
                        onTriggered: lastAction.text = text
                    }
                    MenuFlyoutSeparator {}
                    MenuFlyoutItem {
                        text: qsTr("Rename")
                        symbol: FluentIcons.Edit
                        onTriggered: lastAction.text = text
                    }
                    MenuFlyoutItem {
                        text: qsTr("Share")
                        symbol: FluentIcons.Share
                        onTriggered: lastAction.text = text
                    }
                    MenuFlyoutItem {
                        text: qsTr("Open")
                        symbol: FluentIcons.OpenFile
                        onTriggered: lastAction.text = text
                    }
                    MenuFlyoutItem {
                        text: qsTr("Delete")
                        symbol: FluentIcons.Delete
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

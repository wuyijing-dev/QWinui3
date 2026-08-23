import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — MenuFlyout.
//
// Elevated menu with title, isOpen, preferredPlacement, and motion.
// Keyboard recipe: docs/commands.md (1.15).

CatalogPage {
    title: qsTr("MenuFlyout")
    subtitle: qsTr("Context menu with Esc / arrows / Enter. Recipe: docs/commands.md.")

    ControlExample {
        headerText: qsTr("Keyboard model (1.15)")
        qmlSource: "// showAt(anchor) · Esc / outside dismiss\n// Arrows · Enter/Space · keyboardAcceleratorText"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Set MenuFlyout.title for Accessible chrome. Items use text as Accessible.name; keyboardAcceleratorText is announced as description and shown as a chord hint.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
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
}


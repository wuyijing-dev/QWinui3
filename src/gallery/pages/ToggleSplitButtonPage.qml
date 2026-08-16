import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ToggleSplitButton.

CatalogPage {
    title: qsTr("ToggleSplitButton")
    subtitle: qsTr("Checkable primary + Fluent ChevronDown flyout; isOpen and Accessible.")

    ControlExample {
        headerText: qsTr("List style")
        qmlSource: "ToggleSplitButton {\n    text: \"List\"\n    symbol: FluentIcons.List\n    checked: true\n}"
        ColumnLayout {
            spacing: Theme.spacing
            ToggleSplitButton {
                id: listToggle
                text: qsTr("List")
                symbol: FluentIcons.List
                checked: true
                onPrimaryClicked: status.text = checked ? qsTr("List on") : qsTr("List off")
                MenuItem {
                    text: qsTr("List")
                    onTriggered: status.text = qsTr("List mode")
                }
                MenuItem {
                    text: qsTr("Grid")
                    onTriggered: status.text = qsTr("Grid mode")
                }
                MenuItem {
                    text: qsTr("Tiles")
                    onTriggered: status.text = qsTr("Tiles mode")
                }
            }
            Label {
                id: status
                text: qsTr("Ready — menu open: %1").arg(listToggle.isOpen ? qsTr("yes") : qsTr("no"))
                color: Theme.textSecondary
            }
        }
    }
}

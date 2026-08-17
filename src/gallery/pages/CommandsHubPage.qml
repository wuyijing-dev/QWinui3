import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Commands & menus chooser (1.15 / 1.37). docs/commands.md

CatalogPage {
    id: page
    title: qsTr("Commands & menus")
    subtitle: qsTr("CommandPalette / CommandBar / MenuFlyout — docs/commands.md (1.15).")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("When to use which")
        qmlSource: "CommandPalette · CommandBar · MenuFlyout · MenuBar\ndocs/commands.md · docs/keyboard.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("CommandPalette for Ctrl+K global actions. CommandBar / AppBarButton for page tool strips. MenuFlyout for context menus. MenuBar for classic menus with Action.shortcut. Keyboard-first cookbook: Keyboard-first page.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Repeater {
                model: [
                    { label: qsTr("CommandPalette"), page: "CommandPalettePage" },
                    { label: qsTr("CommandBar"), page: "CommandBarPage" },
                    { label: qsTr("CommandBarFlyout"), page: "CommandBarFlyoutPage" },
                    { label: qsTr("AppBarButton"), page: "AppBarButtonPage" },
                    { label: qsTr("MenuFlyout"), page: "MenuFlyoutPage" },
                    { label: qsTr("MenuBar"), page: "MenuBarPage" },
                    { label: qsTr("Keyboard-first tour"), page: "KeyboardFirstPage" }
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Label {
                        Layout.fillWidth: true
                        text: modelData.label
                        color: Theme.textPrimary
                    }
                    Button {
                        text: qsTr("Open")
                        onClicked: page.openComp(modelData.page)
                    }
                }
            }
        }
    }
}

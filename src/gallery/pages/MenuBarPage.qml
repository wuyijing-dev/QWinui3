import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — MenuBar.
//
// Keyboard recipe: docs/commands.md (1.15).

CatalogPage {
    title: qsTr("MenuBar")
    subtitle: qsTr("Cascading window menus + StandardKey accelerators (2.41) — docs/commands.md.")

    ControlExample {
        headerText: qsTr("Accelerator discovery (2.41)")
        qmlSource: "// Action.shortcut = real chord\n// Mirror same string in CommandPalette.commands[].shortcut"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("MenuBar Action.shortcut chords work when the menu is closed (StandardKey.* or explicit strings). Users still need discovery — mirror high-value actions in CommandPalette with the same shortcut text so Ctrl+K finds Ctrl+C. keyboardAcceleratorText on CommandBar is visual-only. docs/commands.md wave 3.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox { text: qsTr("Edit menu uses StandardKey.Cut / Copy / Paste") }
            CheckBox { text: qsTr("Same chords documented in CommandPalette for Ctrl+K search") }
            CheckBox { text: qsTr("No OS-global shortcut hooks — app-scoped Action.shortcut only") }
        }
    }

    ControlExample {
        headerText: qsTr("Keyboard model (1.15)")
        qmlSource: "// Alt/F10 focuses MenuBar (Qt)\n// Action { shortcut: StandardKey.Copy }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Styled Qt Quick Controls MenuBar. Use Action.shortcut (or StandardKey.*) so chords work outside the open menu. Mnemonics follow the platform MenuBar behavior.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Standard menus")
        qmlSource: "MenuBar {\n    Menu { title: \"File\" ... }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            MenuBar {
                Layout.fillWidth: true
                Menu {
                    title: qsTr("File")
                    Action {
                        text: qsTr("New")
                        shortcut: StandardKey.New
                        onTriggered: status.text = qsTr("New")
                    }
                    Action {
                        text: qsTr("Open…")
                        shortcut: StandardKey.Open
                        onTriggered: status.text = qsTr("Open")
                    }
                    MenuSeparator {}
                    Action {
                        text: qsTr("Exit")
                        shortcut: StandardKey.Quit
                        onTriggered: status.text = qsTr("Exit")
                    }
                }
                Menu {
                    title: qsTr("Edit")
                    Action {
                        text: qsTr("Cut")
                        shortcut: StandardKey.Cut
                        onTriggered: status.text = qsTr("Cut")
                    }
                    Action {
                        text: qsTr("Copy")
                        shortcut: StandardKey.Copy
                        onTriggered: status.text = qsTr("Copy")
                    }
                    Action {
                        text: qsTr("Paste")
                        shortcut: StandardKey.Paste
                        onTriggered: status.text = qsTr("Paste")
                    }
                }
                Menu {
                    title: qsTr("Help")
                    Action {
                        text: qsTr("About")
                        onTriggered: status.text = qsTr("About")
                    }
                }
            }
            Label {
                id: status
                text: qsTr("Ready — try Ctrl+C / Ctrl+V while this page is focused")
                color: Theme.textSecondary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}

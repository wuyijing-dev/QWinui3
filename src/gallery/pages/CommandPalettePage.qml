import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — CommandPalette.
//
// Ctrl+K launcher (also available on ShellWindow). Stable 1.37 · perf 2.16.
// Recipe: docs/commands.md · docs/keyboard.md (1.44)

CatalogPage {
    id: page

    title: qsTr("CommandPalette")
    subtitle: qsTr("Ctrl+K hub — recents + debounce (2.59) · docs/commands.md")

    function stressCommands() {
        var out = [
            {
                id: "settings",
                title: qsTr("Go to Settings"),
                subtitle: qsTr("Open Gallery settings"),
                shortcut: "Ctrl+,",
                symbol: FluentIcons.Settings,
                action: function () { result.text = qsTr("Settings") }
            },
            {
                title: qsTr("Toggle theme"),
                subtitle: qsTr("Switch light / dark"),
                symbol: FluentIcons.Color,
                keywords: "dark light appearance",
                action: function () { result.text = qsTr("Theme toggled") }
            },
            {
                title: qsTr("New window"),
                subtitle: qsTr("Open a blank shell"),
                shortcut: "Ctrl+N",
                symbol: FluentIcons.Add,
                action: function () { result.text = qsTr("New window") }
            },
            {
                title: qsTr("Search docs"),
                subtitle: qsTr("Component API reference"),
                symbol: FluentIcons.Search,
                action: function () { result.text = qsTr("Docs") }
            },
            {
                title: qsTr("Copy selection"),
                shortcut: "Ctrl+C",
                symbol: FluentIcons.Copy,
                action: function () { result.text = qsTr("Copied") }
            }
        ]
        for (var i = 1; i <= 480; ++i) {
            out.push({
                title: qsTr("Stress command %1").arg(i),
                subtitle: qsTr("Large list filter demo (2.41)"),
                keywords: "stress perf debounce",
                action: (function (n) {
                    return function () { result.text = qsTr("Stress %1").arg(n) }
                })(i)
            })
        }
        return out
    }

    overlay: CommandPalette {
        id: palette
        parent: Overlay.overlay
        filterDebounceMs: 80
        maxResults: 64
        commands: page.stressCommands()
        onCommandTriggered: function (cmd) {
            result.text = qsTr("Ran: %1").arg(cmd.title)
        }
    }

    ControlExample {
        headerText: qsTr("Wave 3 — large list + shortcuts (2.41)")
        qmlSource: "// 480+ commands · filter matches shortcut\n// commandCount · filteredCount · docs/commands.md wave 3"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Stress list: 480+ commands with debounced filter (80 ms) and maxResults cap (64). Type a shortcut (e.g. ctrl+c) to discover by chord — not just title/keywords. Footer shows filteredCount of commandCount while typing. Mirror MenuBar Action.shortcut strings here for discovery.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: palette.visible
                      ? qsTr("Palette open — %1 of %2 commands")
                            .arg(palette.filteredCount).arg(palette.commandCount)
                      : qsTr("Open palette to see commandCount / filteredCount")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Keyboard model (2.16)")
        qmlSource: "// Ctrl+K · debounced filter · maxResults\n// ↑↓ · Enter · Esc — docs/commands.md"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Open with Ctrl+K (or the button). Type to filter — keystrokes debounce before rebuild (80 ms); results cap at maxResults (64). Arrow keys move highlight; Enter runs; Esc closes. Stress list: 120+ commands. docs/commands.md wave 2.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Open palette")
        qmlSource: "CommandPalette { commands: [ { title, action } ] }\npalette.open()\n// ShellWindow: Ctrl+K"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Button {
                text: qsTr("Open (or Ctrl+K)")
                onClicked: palette.open()
            }
            KeyChordVisual { shortcut: "Ctrl+K" }
            Label {
                id: result
                Layout.fillWidth: true
                color: Theme.textSecondary
                text: qsTr("No command yet")
            }
        }

        Shortcut {
            sequences: ["Ctrl+K"]
            onActivated: palette.open()
        }
    }
}

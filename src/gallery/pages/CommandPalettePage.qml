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
        registry: demoRegistry
        commands: page.stressCommands()
        onCommandTriggered: function (cmd) {
            result.text = qsTr("Ran: %1").arg(cmd.title)
        }
    }

    CommandRegistry {
        id: demoRegistry
        property bool hasSelection: false
        Component.onCompleted: {
            register({
                id: "registry-hello",
                title: qsTr("Registry: Hello (global)"),
                subtitle: qsTr("Discovered via CommandRegistry (2.68)"),
                scope: "global",
                symbol: FluentIcons.Emoji,
                action: function () { result.text = qsTr("Registry global") }
            })
            register({
                id: "registry-page",
                title: qsTr("Registry: Page scope"),
                scope: "page",
                scopeId: "commands",
                symbol: FluentIcons.Page,
                action: function () { result.text = qsTr("Registry page") }
            })
            register({
                id: "cut",
                title: qsTr("Cut selection"),
                subtitle: qsTr("canExecute — enabled when selection is on (3.02 R3)"),
                scope: "focused",
                scopeId: "editor",
                shortcut: "Ctrl+X",
                symbol: FluentIcons.Cut,
                canExecute: function () { return demoRegistry.hasSelection },
                action: function () { result.text = qsTr("Cut") }
            })
            register({
                id: "save",
                title: qsTr("Save document"),
                scope: "window",
                shortcut: "Ctrl+S",
                symbol: FluentIcons.Save,
                action: function () { result.text = qsTr("Save") }
            })
            register({
                id: "save-as-conflict",
                title: qsTr("Save as… (conflict demo)"),
                subtitle: qsTr("Same Ctrl+S chord — shows in conflicts readout"),
                scope: "window",
                shortcut: "Ctrl+S",
                symbol: FluentIcons.SaveAs,
                action: function () { result.text = qsTr("Save as") }
            })
            setPageScope("commands")
            setFocusedScope("editor")
            setWindowScope("gallery")
        }
    }

    ControlExample {
        headerText: qsTr("CommandRegistry auto-discovery (2.68 / 3.02)")
        qmlSource: "CommandPalette { registry: CommandRegistry { … } }\nregistry.shortcutConflicts()\nregistry.refreshContext()"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Bind CommandPalette.registry to merge scoped commands (focused → page → window → global). dispatch() and palette rows honor canExecute / enabled. Call refreshContext() when selection changes.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            CheckBox {
                text: qsTr("Has selection (enables Cut)")
                checked: demoRegistry.hasSelection
                onCheckedChanged: {
                    demoRegistry.hasSelection = checked
                    demoRegistry.refreshContext()
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textPrimary
                text: {
                    var c = demoRegistry.conflicts
                    if (!c || !c.length)
                        return qsTr("Shortcut conflicts: none")
                    var parts = []
                    for (var i = 0; i < c.length; ++i)
                        parts.push(c[i].shortcut + " → " + c[i].titles.join(" · "))
                    return qsTr("Shortcut conflicts: %1").arg(parts.join("; "))
                }
            }
            RowLayout {
                Button {
                    text: qsTr("Dispatch Cut")
                    onClicked: {
                        var ok = demoRegistry.dispatch("cut")
                        result.text = ok ? qsTr("Cut dispatched") : qsTr("Cut blocked (no selection)")
                    }
                }
                Button {
                    text: qsTr("Dispatch Save")
                    onClicked: {
                        demoRegistry.dispatch("save")
                        result.text = qsTr("Save dispatched")
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Recent commands (2.87 D20)")
        qmlSource: "CommandPalette {\n    persistRecents: true\n    maxRecentCommands: 5\n    recentsSettingsCategory: \"MyApp\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Run a few commands, close the palette, and reopen — recent keys persist in Settings (capped ring). Empty query pins recents at the top.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textPrimary
                text: palette.recentCommandKeys.length
                      ? qsTr("Recent keys: %1").arg(palette.recentCommandKeys.join(", "))
                      : qsTr("No recent commands yet — run one from the palette.")
            }
            Button {
                text: qsTr("Clear recents")
                onClicked: palette.clearRecentCommands()
            }
        }
    }

    ControlExample {
        qmlSource: "// 480+ commands · filter matches shortcut\n// commandCount · filteredCount · docs/commands.md wave 3"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Stress list: 480+ commands with debounced filter (80 ms) and maxResults cap (64). Type a shortcut (e.g. ctrl+c) to discover by chord — not just title/keywords. Footer shows filteredCount of commandCount while typing. Mirror MenuBar Action.shortcut strings here for discovery.")
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

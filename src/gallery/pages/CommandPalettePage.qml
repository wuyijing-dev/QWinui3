import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — CommandPalette.
//
// Ctrl+K launcher (also available on ShellWindow).

CatalogPage {
    title: qsTr("CommandPalette")
    subtitle: qsTr("Modern Ctrl+K command launcher — fuzzy filter, keyboard, ShellWindow shortcut.")

    overlay: CommandPalette {
        id: palette
        parent: Overlay.overlay
        commands: [
            {
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
        onCommandTriggered: function (cmd) {
            result.text = qsTr("Ran: %1").arg(cmd.title)
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

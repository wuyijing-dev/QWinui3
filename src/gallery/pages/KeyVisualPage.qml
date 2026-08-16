import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — KeyVisual.
//
// Key chrome and KeyChordVisual with chordText parsing — not Qt Virtual Keyboard. API: docs/components/KeyVisual.md

CatalogPage {
    title: qsTr("KeyVisual")
    subtitle: qsTr("Key chrome and KeyChordVisual with chordText parsing — not Qt Virtual Keyboard.")

    ControlExample {
        headerText: qsTr("Shortcuts")
        qmlSource: "KeyVisual { keyText: \"Ctrl\" }"
        RowLayout {
            spacing: 6
            KeyVisual { keyText: "Ctrl"; toolTipText: qsTr("Control") }
            Label { text: "+"; color: Theme.textSecondary }
            KeyVisual { keyText: "Shift"; toolTipText: qsTr("Shift") }
            Label { text: "+"; color: Theme.textSecondary }
            KeyVisual { keyText: "P"; toolTipText: qsTr("Palette"); emphasized: true }
            Label {
                Layout.leftMargin: 12
                text: qsTr("Command palette")
                color: Theme.textSecondary
            }
        }
    }
    ControlExample {
        headerText: qsTr("KeyChordVisual — parse shortcut")
        qmlSource: "KeyChordVisual { shortcut: \"Ctrl+Shift+P\" }"
        ColumnLayout {
            spacing: 12
            KeyChordVisual {
                id: paletteChord
                shortcut: "Ctrl+Shift+P"
                toolTipText: qsTr("Command palette")
            }
            Label {
                text: qsTr("chordText: %1").arg(paletteChord.chordText)
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
            KeyChordVisual { shortcut: "Ctrl+K, Ctrl+S"; toolTipText: qsTr("Keyboard shortcuts") }
            KeyChordVisual { shortcut: "Alt+F4"; size: "large" }
            KeyChordVisual {
                keys: ["Win", "Shift", "S"]
                size: "small"
                toolTipText: qsTr("Snip & Sketch")
            }
        }
    }
    ControlExample {
        headerText: qsTr("Sizes & states")
        qmlSource: "KeyVisual { keyText: \"A\"; size: \"large\"; emphasized: true }"
        RowLayout {
            spacing: 10
            KeyVisual { keyText: "A"; size: "small" }
            KeyVisual { keyText: "A"; size: "medium" }
            KeyVisual { keyText: "A"; size: "large" }
            KeyVisual { keyText: "Go"; size: "medium"; emphasized: true; minWidth: 40 }
            KeyVisual { keyText: "Esc"; enabled: false }
            KeyVisual { symbol: FluentIcons.ChevronLeft; keyText: ""; minWidth: 32 }
            KeyVisual { symbol: FluentIcons.ChevronRight; keyText: ""; minWidth: 32 }
        }
    }
    ControlExample {
        headerText: qsTr("Navigation")
        qmlSource: "KeyVisual { keyText: \"Esc\" }"
        RowLayout {
            spacing: 6
            KeyVisual { keyText: "Esc" }
            KeyVisual { keyText: "←" }
            KeyVisual { keyText: "→" }
            KeyVisual { keyText: "Enter"; minWidth: 48 }
            KeyChordVisual { shortcut: "Ctrl+Tab"; Layout.leftMargin: 12 }
        }
    }
}

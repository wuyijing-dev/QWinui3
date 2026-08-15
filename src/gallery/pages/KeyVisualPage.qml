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
                title: qsTr("KeyVisual")
                subtitle: qsTr("Key chrome and KeyChordVisual with chordText parsing — not Qt Virtual Keyboard.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

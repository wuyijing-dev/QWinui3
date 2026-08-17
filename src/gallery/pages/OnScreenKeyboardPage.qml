import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — OnScreenKeyboard (1.73). Recipe: docs/on-screen-keyboard.md
//
// Win11 dock + Keyman layouts + in-app zh/ja/ko IME + emoji. Not Qt Virtual Keyboard.

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Win11 OSK — Keyman layouts + zh/ja/ko IME. docs/on-screen-keyboard.md (1.73).")

    ControlExample {
        headerText: qsTr("Type with the dock (1.73)")
        qmlSource: "OnScreenKeyboard { }\n// Globe: en/de/fr/es/ru/ar + 中文/日本語/한국어 + emoji"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Tap a field, then use the dock. 中文: pinyin (nihao). 日本語: romaji (konnichiwa) then hiragana/katakana. 한국어: 2-beolsik hangul. Emoji key is a layer, not an engine. In-app IME — not Microsoft IME, not Qt Virtual Keyboard.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            ComboBox {
                id: langBox
                Layout.fillWidth: true
                model: osk.engine.layoutLabels
                currentIndex: osk.engine.layoutIndex
                onActivated: osk.engine.layoutIndex = index
            }
            TextField {
                id: lineField
                Layout.fillWidth: true
                placeholderText: qsTr("Single-line field")
                LayoutMirroring.enabled: osk.engine.rtl
                LayoutMirroring.childrenInherit: true
            }
            TextArea {
                id: areaField
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.dp(96)
                placeholderText: qsTr("Multi-line area")
                wrapMode: TextArea.Wrap
                LayoutMirroring.enabled: osk.engine.rtl
            }
            CheckBox { text: qsTr("Treat OnScreenKeyboard as experimental (not freeze-covered)") }
        }
    }

    footer: OnScreenKeyboard {
        id: osk
    }

    Connections {
        target: osk.engine
        function onLayoutIdChanged() {
            langBox.currentIndex = osk.engine.layoutIndex
        }
    }

    Component.onCompleted: lineField.forceActiveFocus()
}

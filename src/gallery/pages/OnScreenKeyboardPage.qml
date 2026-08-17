import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — OnScreenKeyboard (1.74 soak). Recipe: docs/on-screen-keyboard.md
//
// Win11 dock + Keyman layouts + in-app zh/ja/ko IME + emoji. Not Qt Virtual Keyboard.

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Win11 OSK soak — docs/on-screen-keyboard.md (1.74). Still experimental.")

    ControlExample {
        headerText: qsTr("Language matrix soak (1.74)")
        qmlSource: "OnScreenKeyboard { }\n// backend: pinyin | romaji | hangul | keyman | builtin"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Tap a field, then use the dock. Check each row after trying that layout. Space confirms the first candidate (zh/ja/ko). Digits 1–9 pick on the current page. Emoji is a layer, not an engine. In-app only — not Microsoft IME, not Qt Virtual Keyboard.")
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
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Active: %1 · backend “%2”").arg(osk.engine.layoutLabel).arg(osk.engine.backend)
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
            CheckBox { text: qsTr("en-US letters / Shift / Caps / symbols (keyman or builtin)") }
            CheckBox { text: qsTr("de / fr / es / ru labels match keys; ar RTL mirrors") }
            CheckBox { text: qsTr("中文: nihao → candidates; Space / 1–9; nv → 女") }
            CheckBox { text: qsTr("日本語: konnichiwa / trailing n → ん; xtu → っ; hiragana + katakana") }
            CheckBox { text: qsTr("한국어: 2-beolsik 안녕 (dkssud); Shift doubles; incomplete cluster preedit") }
            CheckBox { text: qsTr("Emoji layer inserts; does not steal focus") }
            CheckBox { text: qsTr("Candidate bar: names + page buttons; keys never steal focus") }
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

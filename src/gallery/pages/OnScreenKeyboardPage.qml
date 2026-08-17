import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — OnScreenKeyboard (1.76). Recipe: docs/on-screen-keyboard.md
//
// MIT-only IME deepen: pinyin prefix phrases, hangul peel/space, ja kana only.

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Win11 OSK — IME deepen (MIT-only). docs/on-screen-keyboard.md (1.76).")

    ControlExample {
        headerText: qsTr("IME deepen (1.76)")
        qmlSource: "OnScreenKeyboard { }\n// zh prefix phrases · ko peel/Space · ja kana only"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("中文: type a partial phrase (e.g. niha) — prefix hits appear before single chars. 日本語: romaji→kana only — no kanji (JMDict is CC-BY-SA, not MIT). 한국어: Shift doubles; Caps ignored; Backspace peels ㅘ/ㅢ and double finals; Space commits + word break. Still experimental — not Microsoft / Mozc quality.")
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
            CheckBox { text: qsTr("中文: niha shows 你好 (prefix); Space/1–9 still work") }
            CheckBox { text: qsTr("日本語: kana only — no kanji candidates (documented gap)") }
            CheckBox { text: qsTr("한국어: ㅘ peel on Backspace; Space commits + space") }
            CheckBox { text: qsTr("Keyman packs from 1.75 still switch via Globe") }
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

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — OnScreenKeyboard (1.75). Recipe: docs/on-screen-keyboard.md
//
// Named Keyman .kmx subset + in-app zh/ja/ko IME + emoji. Not Qt Virtual Keyboard.

CatalogPage {
    id: page
    title: qsTr("On-screen keyboard")
    subtitle: qsTr("Win11 OSK — Keyman packs + zh/ja/ko IME. docs/on-screen-keyboard.md (1.75).")

    ControlExample {
        headerText: qsTr("Language matrix (1.75 packs)")
        qmlSource: "OnScreenKeyboard { }\n// Keyman: en-US/GB de fr es it pt pl sv tr ru ar\n// IME: zh / ja / ko"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Tap a field, then use the dock. 1.75 adds Keyman packs: English (UK), Italiano, Português, Polski, Svenska, Türkçe. Direct layouts use engine.backend “keyman”. 中文/日本語/한국어 stay in-app IME. Emoji is a layer. Not Microsoft IME, not Qt Virtual Keyboard. Shipped vs BYO: keyboards/README.md.")
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
            CheckBox { text: qsTr("en-US / en-GB / de / fr / es labels match keys") }
            CheckBox { text: qsTr("it / pt / pl / sv / tr (1.75) type correctly") }
            CheckBox { text: qsTr("ru Cyrillic; ar RTL mirrors") }
            CheckBox { text: qsTr("中文 / 日本語 / 한국어 IME still work") }
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

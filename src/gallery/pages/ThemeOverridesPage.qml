import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Theme overrides / branding (1.09).
//
// Writable knobs only — no Style fork. Restores Theme when leaving the page.

CatalogPage {
    id: page
    title: qsTr("Theme overrides")
    subtitle: qsTr("Brand via Theme.customAccent / density / dark — Style already follows.")

    property var _saved: null

    function _snapshotTheme() {
        return {
            dark: Theme.dark,
            density: Theme.density,
            uiScale: Theme.uiScale,
            accentPack: Theme.accentPack,
            customAccent: String(Theme.customAccent),
            followSystemColorScheme: Theme.followSystemColorScheme
        }
    }

    function _restoreTheme() {
        if (!_saved)
            return
        Theme.followSystemColorScheme = _saved.followSystemColorScheme
        Theme.dark = _saved.dark
        Theme.density = _saved.density
        Theme.uiScale = _saved.uiScale
        Theme.accentPack = _saved.accentPack
        Theme.customAccent = _saved.customAccent
    }

    Component.onCompleted: _saved = _snapshotTheme()
    Component.onDestruction: _restoreTheme()

    ControlExample {
        headerText: qsTr("Brand presets")
        qmlSource: "Theme.customAccent = \"#0F766E\"\nTheme.density = \"compact\""

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("Applies Theme knobs only. Leaving this page restores your previous Theme.")
            }

            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Button {
                    text: qsTr("Contoso teal")
                    onClicked: {
                        Theme.followSystemColorScheme = false
                        Theme.customAccent = "#0F766E"
                        Theme.density = "compact"
                        Theme.dark = false
                    }
                }
                Button {
                    text: qsTr("Contoso magenta")
                    onClicked: {
                        Theme.followSystemColorScheme = false
                        Theme.customAccent = "#C239B3"
                        Theme.density = "standard"
                        Theme.dark = false
                    }
                }
                Button {
                    text: qsTr("Night orange")
                    onClicked: {
                        Theme.followSystemColorScheme = false
                        Theme.customAccent = "#FF8C00"
                        Theme.density = "compact"
                        Theme.dark = true
                    }
                }
                Button {
                    text: qsTr("Pack: purple")
                    flat: true
                    onClicked: Theme.setAccentPack("purple")
                }
                Button {
                    text: qsTr("Restore page entry")
                    flat: true
                    onClicked: page._restoreTheme()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingLoose
                Label {
                    text: qsTr("Custom accent")
                    color: Theme.textPrimary
                }
                ColorPickerButton {
                    selectedColor: Theme.customAccent.a > 0.001
                                   ? Theme.customAccent : Theme.accent
                    showHexLabel: true
                    onColorChosen: function (c) {
                        if (c.a > 0.001)
                            Theme.customAccent = c
                    }
                }
                ComboBox {
                    model: [qsTr("Standard density"), qsTr("Compact")]
                    currentIndex: Theme.density === "compact" ? 1 : 0
                    onActivated: function (index) {
                        Theme.density = index === 1 ? "compact" : "standard"
                    }
                }
                Switch {
                    text: Theme.dark ? qsTr("Dark") : qsTr("Light")
                    checked: Theme.dark
                    onToggled: {
                        Theme.followSystemColorScheme = false
                        Theme.dark = checked
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Stock controls pick up the brand")
        qmlSource: "AccentButton / Button / Switch / ProgressBar / CheckBox"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                radius: Theme.cornerControl
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing
                    spacing: Theme.spacing
                    Rectangle {
                        width: 28
                        height: 28
                        radius: 6
                        color: Theme.accent
                    }
                    Label {
                        Layout.fillWidth: true
                        text: qsTr("App chrome using Theme.accent / Theme.bgCard")
                        color: Theme.textPrimary
                        font.weight: Theme.fontWeightSemiBold
                    }
                    Label {
                        text: Theme.accent
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                    }
                }
            }

            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                AccentButton { text: qsTr("Accent") }
                Button { text: qsTr("Standard") }
                Button { highlighted: true; text: qsTr("Highlighted") }
                Switch { text: qsTr("Notify"); checked: true }
                CheckBox { text: qsTr("Agree"); checked: true }
            }

            ProgressBar {
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                value: 0.62
                indeterminate: false
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("density=%1 · accentPack=%2 · custom=%3")
                         .arg(Theme.density)
                         .arg(Theme.accentPack)
                         .arg(Theme.customAccent.a > 0.001 ? String(Theme.customAccent) : qsTr("(none)"))
            }
        }
    }
}

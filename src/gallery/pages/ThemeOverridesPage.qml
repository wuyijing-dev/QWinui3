import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Theme overrides / branding (1.09) + density metrics (1.30).
//
// Writable knobs only — no Style fork. Restores Theme when leaving the page.
// Density / type / narrow shells: docs/density.md

CatalogPage {
    id: page
    title: qsTr("Theme overrides")
    subtitle: qsTr("Brand + density. Live metrics: docs/density.md (1.30). Style already follows Theme.")

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
        headerText: qsTr("Density metrics (1.30)")
        qmlSource: "Theme.density = \"compact\"\nTheme.uiScale = 1.0\n// fonts do not scale"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Compact uses 0.85x on controlHeight / padding / spacing. Type scale (fontCaption…fontTitle) stays fixed. Narrow shells: NavigationView paneDisplayMode auto (threshold 1008) or ListDetailsView minWideWidth - docs/density.md.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingLoose
                ComboBox {
                    model: [qsTr("Standard density"), qsTr("Compact")]
                    currentIndex: Theme.density === "compact" ? 1 : 0
                    Accessible.name: qsTr("Density")
                    onActivated: function (index) {
                        Theme.density = index === 1 ? "compact" : "standard"
                    }
                }
                Label {
                    text: qsTr("uiScale")
                    color: Theme.textSecondary
                }
                Slider {
                    id: scaleSlider
                    from: 0.85
                    to: 1.25
                    stepSize: 0.05
                    value: Theme.uiScale
                    Layout.preferredWidth: 160
                    Accessible.name: qsTr("UI scale")
                    onMoved: Theme.uiScale = value
                }
                Label {
                    text: Theme.uiScale.toFixed(2)
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textPrimary
                text: qsTr("controlHeight=%1 · spacing=%2 · navItemHeight=%3 · fontBody=%4 (fixed)")
                         .arg(Theme.controlHeight)
                         .arg(Theme.spacing)
                         .arg(Theme.navItemHeight)
                         .arg(Theme.fontBody)
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Sample")
                    implicitHeight: Theme.controlHeight
                }
                Button {
                    text: qsTr("Highlighted")
                    highlighted: true
                    implicitHeight: Theme.controlHeight
                }
                Switch { text: qsTr("Notify"); checked: true }
            }
        }
    }

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
                text: qsTr("density=%1 · uiScale=%2 · accentPack=%3 · custom=%4")
                         .arg(Theme.density)
                         .arg(Theme.uiScale.toFixed(2))
                         .arg(Theme.accentPack)
                         .arg(Theme.customAccent.a > 0.001 ? String(Theme.customAccent) : qsTr("(none)"))
            }
        }
    }
}

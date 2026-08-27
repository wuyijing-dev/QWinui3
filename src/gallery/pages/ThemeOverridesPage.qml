import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Theme overrides / branding + density + contrast.
//
// Writable knobs only — no Style fork. Restores Theme when leaving the page.
// Density: docs/density.md · Contrast: docs/color-contrast.md

CatalogPage {
    id: page
    title: qsTr("Theme overrides")
    subtitle: qsTr("Brand + density + contrast AA — docs/theme-overrides.md.")

    property var _saved: null

    function _restoreTheme() {
        if (page._saved)
            Theme.apply(page._saved)
    }

    readonly property real _ratioPrimaryCard: Theme.contrastRatio(Theme.textPrimary, Theme.bgCard)
    readonly property real _ratioSecondaryCard: Theme.contrastRatio(Theme.textSecondary, Theme.bgCard)
    readonly property real _ratioAccentCard: Theme.accentContrastRatio(Theme.bgCard)
    readonly property real _ratioOnAccent: Theme.contrastRatio(Theme.textOnAccent, Theme.accent)
    readonly property bool _aaPrimary: Theme.contrastPassesAA(Theme.textPrimary, Theme.bgCard)
    readonly property bool _aaSecondary: Theme.contrastPassesAA(Theme.textSecondary, Theme.bgCard)
    readonly property bool _aaAccent: Theme.contrastPassesAA(Theme.accent, Theme.bgCard)
    readonly property bool _aaOnAccent: Theme.contrastPassesAA(Theme.textOnAccent, Theme.accent)

    function _passLabel(ok) {
        return ok ? qsTr("AA pass") : qsTr("AA fail")
    }

    Component.onCompleted: _saved = Theme.snapshot()
    Component.onDestruction: Theme.apply(_saved)

    ControlExample {
        headerText: qsTr("Branding accent packs")
        qmlSource: "Theme.setAccentPack(\"purple\")\nTheme.customAccent = \"#0F766E\""
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Built-in packs: blue · purple · green · orange. customAccent overrides pack. Persist with ThemeAppearanceSettings + ThemePrefs — docs/theme-overrides..")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Repeater {
                    model: ["blue", "purple", "green", "orange"]
                    delegate: Button {
                        required property string modelData
                        text: modelData
                        flat: Theme.accentPack !== modelData || Theme.customAccent.a > 0.001
                        onClicked: Theme.setAccentPack(modelData)
                    }
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textPrimary
                text: qsTr("accentPack=%1 · custom=%2 · AA accent/card: %3")
                         .arg(Theme.accentPack)
                         .arg(Theme.customAccent.a > 0.001 ? String(Theme.customAccent) : qsTr("(none)"))
                         .arg(page._aaAccent ? qsTr("pass") : qsTr("fail"))
            }
        }
    }

    ControlExample {
        headerText: qsTr("Contrast diagnostics")
        qmlSource: "Theme.contrastRatio(fg, bg)\nTheme.contrastPassesAA(fg, bg)"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("WCAG 2.x ratios for current Theme (guidance only — not a certification). Body AA ≥ 4.5:1. Change accent / dark below and watch the table. Recipe: docs/color-contrast.md · High contrast: Accessibility / Settings.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                columnSpacing: Theme.spacingLoose
                rowSpacing: Theme.spacing
                Label { text: qsTr("Pair"); font.weight: Theme.fontWeightSemiBold; color: Theme.textPrimary }
                Label { text: qsTr("Ratio"); font.weight: Theme.fontWeightSemiBold; color: Theme.textPrimary }
                Label { text: qsTr("AA"); font.weight: Theme.fontWeightSemiBold; color: Theme.textPrimary }

                Label { text: qsTr("textPrimary / bgCard"); color: Theme.textSecondary }
                Label { text: page._ratioPrimaryCard.toFixed(2) + ":1"; color: Theme.textPrimary }
                Label {
                    text: page._passLabel(page._aaPrimary)
                    color: page._aaPrimary ? Theme.systemSuccess : Theme.systemCritical
                }

                Label { text: qsTr("textSecondary / bgCard"); color: Theme.textSecondary }
                Label { text: page._ratioSecondaryCard.toFixed(2) + ":1"; color: Theme.textPrimary }
                Label {
                    text: page._passLabel(page._aaSecondary)
                    color: page._aaSecondary ? Theme.systemSuccess : Theme.systemCritical
                }

                Label { text: qsTr("accent / bgCard"); color: Theme.textSecondary }
                Label { text: page._ratioAccentCard.toFixed(2) + ":1"; color: Theme.textPrimary }
                Label {
                    text: page._passLabel(page._aaAccent)
                    color: page._aaAccent ? Theme.systemSuccess : Theme.systemCritical
                }

                Label { text: qsTr("textOnAccent / accent"); color: Theme.textSecondary }
                Label { text: page._ratioOnAccent.toFixed(2) + ":1"; color: Theme.textPrimary }
                Label {
                    text: page._passLabel(page._aaOnAccent)
                    color: page._aaOnAccent ? Theme.systemSuccess : Theme.systemCritical
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Rectangle {
                    width: 120
                    height: 40
                    radius: Theme.cornerControl
                    color: Theme.bgCard
                    border.width: 1
                    border.color: Theme.strokeCard
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Primary")
                        color: Theme.textPrimary
                    }
                }
                Rectangle {
                    width: 120
                    height: 40
                    radius: Theme.cornerControl
                    color: Theme.accent
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("On accent")
                        color: Theme.textOnAccent
                    }
                }
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    color: Theme.textSecondary
                    text: qsTr("dark=%1 · accent=%2").arg(Theme.dark).arg(String(Theme.accent))
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Density metrics")
        qmlSource: "Theme.density = \"compact\"\nTheme.uiScale = 1.0\n// fonts do not scale"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Compact uses 0.85x on controlHeight / padding / spacing. Type scale (fontCaption…fontTitle) stays fixed. Narrow shells: NavigationView paneDisplayMode auto (threshold 1008) or ListDetailsView minWideWidth - docs/density.md.")
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

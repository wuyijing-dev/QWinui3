import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Style module spot-check (2.17).
// Recipe: docs/style-polish.md · docs/theme-overrides.md

CatalogPage {
    id: page
    title: qsTr("Style spot-check")
    subtitle: qsTr("WinUI 3 chrome consistency — docs/style-polish.md")

    signal openControl(var item)

    function openComp(id) {
        var it = ControlCatalog.findByComponent(id)
        if (it)
            page.openControl(it)
    }

    ControlExample {
        headerText: qsTr("Pointer baseline")
        qmlSource: "Button.appearance · TextField.hasError · FontIcon · FocusStroke"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Press/hover/focus spot-check for Fluent chrome. Toggle Theme.reducedMotion and highContrast on Theme overrides.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: Theme.spacingLoose
                rowSpacing: Theme.spacing
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Filled")
                    appearance: "filled"
                }
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Outline")
                    appearance: "outline"
                }
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Ghost")
                    appearance: "ghost"
                }
                AccentButton {
                    Layout.fillWidth: true
                    text: qsTr("Accent CTA")
                    symbol: FluentIcons.Save
                }
                HyperlinkButton {
                    Layout.fillWidth: true
                    text: qsTr("Learn more")
                }
                TextField {
                    id: errField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Valid email")
                    hasError: errField.text.length > 0 && errField.text.indexOf("@") < 0
                }
                SpinBox {
                    Layout.fillWidth: true
                    from: 0
                    to: 10
                    value: 3
                }
                ToolButton {
                    Layout.fillWidth: true
                    text: qsTr("Tool subtle")
                    appearance: "subtle"
                }
                RoundButton {
                    text: "+"
                    loading: roundBusy.checked
                }
                ProgressBar {
                    id: progDemo
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: 0.35
                }
                FontIcon {
                    symbol: FluentIcons.ChevronDown
                    fontSize: 16
                    chevronRotation: chevronDemo.checked ? 180 : 0
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            RowLayout {
                spacing: Theme.spacing
                CheckBox {
                    id: chevronDemo
                    text: qsTr("Chevron expanded (I4)")
                    checked: true
                }
                CheckBox {
                    id: roundBusy
                    text: qsTr("RoundButton loading")
                }
                Button {
                    text: qsTr("Trigger error shake")
                    onClicked: {
                        errField.text = qsTr("bad")
                        errField.hasError = true
                    }
                }
                Button {
                    text: qsTr("Progress complete")
                    onClicked: progDemo.value = 1
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Stock Style controls")
        qmlSource: "import QWinUI3.Style  // implicit via gallery\nButton · TextField · ComboBox · CheckBox"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Side-by-side spot-check for the QWinUI3 Style module. Toggle light/dark, accent, and density on Theme overrides — fills should stay consistent (borderedControlFill / bgControlRest). docs/style-polish.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: Theme.spacingLoose
                rowSpacing: Theme.spacing
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Standard")
                }
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Accent")
                    highlighted: true
                }
                TextField {
                    Layout.fillWidth: true
                    placeholderText: qsTr("TextField rest / hover / focus")
                }
                ComboBox {
                    Layout.fillWidth: true
                    model: [qsTr("Combo A"), qsTr("Combo B"), qsTr("Combo C")]
                }
                CheckBox {
                    text: qsTr("Checked")
                    checked: true
                }
                CheckBox {
                    text: qsTr("Unchecked")
                }
                RadioButton {
                    text: qsTr("Radio on")
                    checked: true
                }
                RadioButton {
                    text: qsTr("Radio off")
                }
                Switch {
                    text: qsTr("Switch")
                    checked: true
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    stepSize: 25
                    tickMarksVisible: true
                    value: 50
                }
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Theme overrides")
                    highlighted: true
                    onClicked: page.openComp("ThemeOverridesPage")
                }
                Button {
                    text: qsTr("Button page")
                    onClicked: page.openComp("ButtonPage")
                }
                Button {
                    text: qsTr("TextField page")
                    onClicked: page.openComp("TextFieldPage")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Lists & cards")
        qmlSource: "SettingsCard.interactive · ChartCard.interactive · ListTile.swipeHintVisible"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            SettingsCard {
                Layout.fillWidth: true
                title: qsTr("Interactive settings row")
                description: qsTr("Hover / press elevation — appearance elevated")
                appearance: "elevated"
                interactive: true
                showChevron: true
                onClicked: cardHint.text = qsTr("SettingsCard clicked")
            }
            ChartCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                title: qsTr("Interactive chart card")
                subtitle: qsTr("Hover to lift")
                appearance: "elevated"
                interactive: true
                onClicked: cardHint.text = qsTr("ChartCard clicked")
            }
            ListTile {
                Layout.fillWidth: true
                title: qsTr("Swipe-ready row")
                subtitle: qsTr("Trailing accent edge at rest")
                symbol: FluentIcons.Mail
                swipeHintVisible: true
            }
            Label {
                id: cardHint
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Press interactive cards above.")
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Token readout")
        qmlSource: "Theme.borderedControlFill\nTheme.bgControlRest · Theme.fillSliderThumb"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                text: qsTr("bgControlRest: %1 · fillControlSecondary: %2 · fillControlDisabled: %3 · fillSliderThumb: %4")
                    .arg(Theme.bgControlRest)
                    .arg(Theme.fillControlSecondary)
                    .arg(Theme.fillControlDisabled)
                    .arg(Theme.fillSliderThumb)
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                text: qsTr("borderedControlFill(rest): %1 · borderedControlFill(hover): %2")
                    .arg(Theme.borderedControlFill(false, false, false))
                    .arg(Theme.borderedControlFill(true, false, false))
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SettingsComboCard / SettingsSliderCard.

CatalogPage {
    title: qsTr("Settings combo & slider cards")
    subtitle: qsTr("SettingsCard conveniences with built-in ComboBox or Slider actions.")

    ControlExample {
        headerText: qsTr("SettingsComboCard")
        qmlSource: "SettingsComboCard {\n    title: \"Density\"\n    model: [\"Standard\", \"Compact\"]\n}"
        SettingsComboCard {
            title: qsTr("Density")
            description: qsTr("Theme.density scales control metrics.")
            symbol: FluentIcons.Trim
            model: [qsTr("Standard"), qsTr("Compact")]
            currentIndex: Theme.density === "compact" ? 1 : 0
            onActivated: function (index) {
                Theme.density = index === 1 ? "compact" : "standard"
            }
        }
    }
    ControlExample {
        headerText: qsTr("SettingsSliderCard")
        qmlSource: "SettingsSliderCard {\n    title: \"Volume\"\n    from: 0; to: 100\n}"
        SettingsSliderCard {
            id: vol
            title: qsTr("UI scale demo")
            description: qsTr("Sample value only — not wired to Theme.")
            symbol: FluentIcons.Font
            from: 0
            to: 100
            value: 48
            valuePrecision: 0
        }
    }
}

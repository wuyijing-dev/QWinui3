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
        background: null

        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection

            Text {
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                text: qsTr("Settings")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontTitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                title: qsTr("Appearance")
                description: qsTr("Light or dark Theme tokens.")
                headerIcon: "\uE790"
                action: Switch {
                    text: Theme.dark ? qsTr("Dark") : qsTr("Light")
                    checked: Theme.dark
                    onToggled: Theme.dark = checked
                }
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                title: qsTr("Reduced motion")
                description: qsTr("Short-circuit Theme.duration() animations.")
                headerIcon: "\uE7FC"
                action: Switch {
                    checked: Theme.reducedMotion
                    onToggled: Theme.reducedMotion = checked
                }
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.bottomMargin: Theme.spacingSection
                title: qsTr("Density")
                description: qsTr("Compact control metrics (Theme.density).")
                headerIcon: "\uE8A5"
                action: ComboBox {
                    model: [qsTr("Standard"), qsTr("Compact")]
                    currentIndex: Theme.density === "compact" ? 1 : 0
                    onActivated: function (index) {
                        Theme.density = index === 1 ? "compact" : "standard"
                    }
                }
            }
        }
    }
}

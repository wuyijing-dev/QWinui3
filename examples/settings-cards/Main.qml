import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

StandardWindow {
    id: window
    width: 720
    height: 780
    visible: true
    title: qsTr("Settings cards example")
    backdrop: WindowHelper.BackdropSolid

    property bool notificationsEnabled: true
    property bool marketingEmail: false
    property string accountName: qsTr("Alex Chen")

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
        }
    }

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
            Text {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                wrapMode: Text.WordWrap
                text: qsTr("Account, appearance, and notification rows built with SettingsCard / SettingsExpander.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            Text {
                Layout.leftMargin: Theme.spacingSection
                text: qsTr("Account")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textSecondary
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                title: window.accountName
                description: qsTr("Signed in locally for this example.")
                headerIcon: "\uE77B"
                action: Button {
                    flat: true
                    text: qsTr("Manage")
                }
            }

            Text {
                Layout.leftMargin: Theme.spacingSection
                text: qsTr("Appearance")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textSecondary
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                title: qsTr("App theme")
                description: qsTr("Toggle Theme.dark")
                headerIcon: "\uE790"
                action: Switch {
                    checked: Theme.dark
                    onToggled: Theme.dark = checked
                }
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                title: qsTr("Accent pack")
                description: qsTr("Theme.accentPack presets")
                headerIcon: "\uE790"
                action: ComboBox {
                    model: [qsTr("Blue"), qsTr("Purple"), qsTr("Green"), qsTr("Orange")]
                    currentIndex: {
                        switch (Theme.accentPack) {
                        case "purple": return 1
                        case "green": return 2
                        case "orange": return 3
                        default: return 0
                        }
                    }
                    onActivated: function (index) {
                        var packs = ["blue", "purple", "green", "orange"]
                        Theme.accentPack = packs[index]
                    }
                }
            }

            Text {
                Layout.leftMargin: Theme.spacingSection
                text: qsTr("Notifications")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textSecondary
            }

            SettingsExpander {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.bottomMargin: Theme.spacingSection
                title: qsTr("Notification preferences")
                description: qsTr("Expand for email and toast options.")
                headerIcon: "\uEA8F"

                SettingsCard {
                    Layout.fillWidth: true
                    title: qsTr("Enable notifications")
                    description: qsTr("Master switch for this sample.")
                    action: Switch {
                        checked: window.notificationsEnabled
                        onToggled: window.notificationsEnabled = checked
                    }
                }
                SettingsCard {
                    Layout.fillWidth: true
                    title: qsTr("Marketing email")
                    description: qsTr("Optional promotional mail.")
                    enabled: window.notificationsEnabled
                    action: Switch {
                        checked: window.marketingEmail
                        enabled: window.notificationsEnabled
                        onToggled: window.marketingEmail = checked
                    }
                }
            }
        }
    }
}

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
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("ActionCard")
                subtitle: qsTr("Clickable card with glyph, optional badge, and chevron.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Actions")
                qmlSource: "ActionCard {\n    badgeVisible: true\n    badgeValue: 3\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    ActionCard {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 420
                        title: qsTr("Personalization")
                        description: qsTr("Background, colors, themes")
                        glyph: "\uE771"
                        badgeVisible: true
                        badgeValue: 3
                        badgeSeverity: 0
                        onClicked: resultLabel.text = qsTr("Opened Personalization")
                    }
                    ActionCard {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 420
                        title: qsTr("Network & internet")
                        description: qsTr("Wi‑Fi, airplane mode, VPN")
                        glyph: "\uE968"
                        glyphColor: Theme.systemAttention
                        showChevron: false
                        onClicked: resultLabel.text = qsTr("Opened Network")
                    }
                    Label {
                        id: resultLabel
                        text: qsTr("Tap a card")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

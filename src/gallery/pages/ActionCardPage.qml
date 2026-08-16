import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ActionCard.

CatalogPage {
    title: qsTr("ActionCard")
    subtitle: qsTr("Clickable card with symbol, badge, and animated chevron.")

    ControlExample {
        headerText: qsTr("Actions")
        qmlSource: "ActionCard {\n    symbol: FluentIcons.Color\n    badgeVisible: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ActionCard {
                Layout.maximumWidth: 420
                title: qsTr("Personalization")
                description: qsTr("Background, colors, themes")
                symbol: FluentIcons.Color
                badgeVisible: true
                badgeValue: 3
                badgeSeverity: 0
                onClicked: resultLabel.text = qsTr("Opened Personalization")
            }
            ActionCard {
                Layout.maximumWidth: 420
                title: qsTr("Network & internet")
                description: qsTr("Wi‑Fi, airplane mode, VPN")
                symbol: FluentIcons.Wifi
                glyphColor: Theme.systemAttention
                showChevron: false
                onClicked: resultLabel.text = qsTr("Opened Network")
            }
            Label {
                id: resultLabel
                Layout.fillWidth: true
                Layout.preferredHeight: implicitHeight
                text: qsTr("Tap a card")
                color: Theme.textSecondary
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

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
                title: qsTr("Tool / Round / Delay")
                subtitle: qsTr("Additional button variants for toolbars, compact actions, and hold-to-confirm.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("ToolButton and RoundButton")
                qmlSource: "ToolButton { text: \"Tool\" }\nRoundButton { text: \"+\" }\nRoundButton { text: \"A\"; highlighted: true }"

                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    ToolButton { text: qsTr("Tool") }
                    RoundButton { text: "+" }
                    RoundButton { text: "A"; highlighted: true }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("DelayButton")
                qmlSource: "DelayButton {\n    text: \"Hold to confirm\"\n    delay: 1200\n    onActivated: text = \"Activated\"\n}"

                DelayButton {
                    text: qsTr("Hold to confirm")
                    delay: 1200
                    onActivated: text = qsTr("Activated")
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

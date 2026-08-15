import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Delegates.
//
// List item delegates with check, switch, and radio affordances.

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
                title: qsTr("Delegates")
                subtitle: qsTr("List item delegates with check, switch, and radio affordances.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Check, Switch, and Radio delegates")
                qmlSource: "ListView {\n    CheckDelegate { text: \"Check\" }\n    SwitchDelegate { text: \"Switch\" }\n    RadioDelegate { text: \"Radio\" }\n}"

                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: contentHeight
                    clip: true
                    interactive: false
                    model: 1
                    spacing: 0
                    delegate: ColumnLayout {
                        width: ListView.view.width
                        spacing: 0

                        CheckDelegate {
                            Layout.fillWidth: true
                            text: qsTr("Check option")
                            checked: true
                        }
                        SwitchDelegate {
                            Layout.fillWidth: true
                            text: qsTr("Switch option")
                            checked: true
                        }
                        RadioDelegate {
                            Layout.fillWidth: true
                            text: qsTr("Radio option A")
                            checked: true
                            ButtonGroup.group: radioGroup
                        }
                        RadioDelegate {
                            Layout.fillWidth: true
                            text: qsTr("Radio option B")
                            ButtonGroup.group: radioGroup
                        }

                        ButtonGroup { id: radioGroup }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

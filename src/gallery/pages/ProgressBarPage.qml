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
                title: qsTr("ProgressBar")
                subtitle: qsTr("Shows the progress of an operation that has a known duration.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Determinate ProgressBar")
                qmlSource: "ProgressBar { value: 0.35 }\nProgressBar { value: 0.7 }"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    ProgressBar {
                        Layout.preferredWidth: 320
                        value: 0.35
                    }
                    ProgressBar {
                        Layout.preferredWidth: 320
                        value: 0.7
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Indeterminate ProgressBar")
                qmlSource: "ProgressBar {\n    indeterminate: true\n}"

                ProgressBar {
                    Layout.preferredWidth: 320
                    indeterminate: true
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

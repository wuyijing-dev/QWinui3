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
                title: qsTr("ComboBox")
                subtitle: qsTr("Fluent chevron indicator with popup-open rotation.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple ComboBox")
                qmlSource: "ComboBox {\n    model: [\"Red\", \"Green\", \"Blue\", \"Orange\"]\n}\nComboBox {\n    model: [\"One\", \"Two\", \"Three\"]\n    enabled: false\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    ComboBox {
                        Layout.preferredWidth: 240
                        model: [qsTr("Red"), qsTr("Green"), qsTr("Blue"), qsTr("Orange")]
                    }
                    ComboBox {
                        Layout.preferredWidth: 240
                        model: [qsTr("One"), qsTr("Two"), qsTr("Three")]
                        enabled: false
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

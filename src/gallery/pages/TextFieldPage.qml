import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — TextField.
//
// A single-line text input control. API: docs/components/TextField.md

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
                title: qsTr("TextField")
                subtitle: qsTr("A single-line text input control.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple TextField")
                qmlSource: "TextField {\n    placeholderText: \"Placeholder\"\n}\nTextField {\n    text: \"Sample text\"\n}\nTextField {\n    text: \"Disabled\"\n    enabled: false\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    TextField {
                        Layout.preferredWidth: 320
                        placeholderText: qsTr("Placeholder")
                    }
                    TextField {
                        Layout.preferredWidth: 320
                        text: qsTr("Sample text")
                    }
                    TextField {
                        Layout.preferredWidth: 320
                        text: qsTr("Disabled")
                        enabled: false
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

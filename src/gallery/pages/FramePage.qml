import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Frame.
//
// A simple styled container with padding and a surface fill. API: docs/components/Frame.md

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
                title: qsTr("Frame")
                subtitle: qsTr("A simple styled container with padding and a surface fill.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Content frame")
                qmlSource: "Frame {\n    Label { text: \"Inside a Frame\" }\n}"
                Frame {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 420
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: Theme.spacing
                        Label {
                            text: qsTr("Inside a Frame")
                            font.weight: Theme.fontWeightSemiBold
                        }
                        Label {
                            Layout.fillWidth: true
                            wrapMode: Text.Wrap
                            text: qsTr("Use Frame to group related content with a subtle surface background.")
                            color: Theme.textSecondary
                        }
                        Button {
                            text: qsTr("Action")
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

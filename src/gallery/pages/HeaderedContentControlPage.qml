import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — HeaderedContentControl.
//
// Content with symbol header and top/left headerPlacement. API: docs/components/HeaderedContentControl.md

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
                title: qsTr("HeaderedContentControl")
                subtitle: qsTr("Content with symbol header and top/left headerPlacement.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Top header")
                qmlSource: "HeaderedContentControl {\n    header: \"Account\"\n    description: \"…\"\n}"
                HeaderedContentControl {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 420
                    header: qsTr("Account")
                    description: qsTr("Signed-in identity and security options")
                    symbol: FluentIcons.Contact
                    Label {
                        text: qsTr("Signed in as alex@contoso.com")
                        color: Theme.textPrimary
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                    Button { text: qsTr("Manage") }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Left header")
                qmlSource: "HeaderedContentControl {\n    headerPlacement: \"left\"\n}"
                HeaderedContentControl {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 480
                    headerPlacement: "left"
                    header: qsTr("Storage")
                    description: qsTr("Local disk")
                    ProgressBar {
                        from: 0; to: 100; value: 62
                        Layout.fillWidth: true
                    }
                    Label {
                        text: qsTr("62 GB of 100 GB used")
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

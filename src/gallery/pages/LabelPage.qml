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
                title: qsTr("Label")
                subtitle: qsTr("A text label for captions and descriptions.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Typography")
                qmlSource: "Label { text: \"Body\" }\nLabel { text: \"Caption\"; font.pixelSize: 12 }"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Label { text: qsTr("Body label") }
                    Label {
                        text: qsTr("Secondary caption")
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                    }
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        text: qsTr("Wrapped label text for longer descriptions that span multiple lines.")
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

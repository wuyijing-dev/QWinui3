import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

Page {
    padding: 0
    Drawer {
        id: drawer
        edge: Qt.LeftEdge
        width: 280

        ColumnLayout {
            width: drawer.availableWidth
            spacing: Theme.spacingLoose

            Label {
                text: qsTr("Drawer content")
                font.pixelSize: Theme.fontSubtitle
                color: Theme.textPrimary
            }
            Label {
                text: qsTr("Use a Drawer for navigation or secondary actions.")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                color: Theme.textSecondary
            }
            Button {
                text: qsTr("Action")
                highlighted: true
            }
            Button {
                text: qsTr("Close")
                onClicked: drawer.close()
            }
        }
    }

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
                title: qsTr("Drawer")
                subtitle: qsTr("A slide-out panel that presents navigation or contextual content from an edge.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Left edge Drawer")
                qmlSource: "Button {\n    text: \"Open drawer\"\n    onClicked: drawer.open()\n}\nDrawer {\n    edge: Qt.LeftEdge\n    // content…\n}"

                Button {
                    text: qsTr("Open drawer")
                    onClicked: drawer.open()
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

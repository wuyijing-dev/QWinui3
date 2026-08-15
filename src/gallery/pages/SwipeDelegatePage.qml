import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SwipeDelegate.
//
// A list delegate that reveals actions when swiped. API: docs/components/SwipeDelegate.md

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
                title: qsTr("SwipeDelegate")
                subtitle: qsTr("A list delegate that reveals actions when swiped.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Swipe for actions")
                qmlSource: "SwipeDelegate {\n    swipe.right: SwipeAction { text: \"Delete\" }\n}"
                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 160
                    clip: true
                    spacing: 4
                    model: [qsTr("Inbox"), qsTr("Archive"), qsTr("Flagged")]
                    delegate: SwipeDelegate {
                        required property string modelData
                        width: ListView.view.width
                        text: modelData

                        // Drag content left → Delete on the right.
                        swipe.right: SwipeAction {
                            text: qsTr("Delete")
                            leading: false
                        }
                        // Drag content right → Flag on the left.
                        swipe.left: SwipeAction {
                            text: qsTr("Flag")
                            color: Theme.accent
                            leading: true
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SwipeDelegate.

CatalogPage {
    title: qsTr("SwipeDelegate")
    subtitle: qsTr("A list delegate that reveals actions when swiped.")

    ControlExample {
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

                swipe.right: SwipeAction {
                    text: qsTr("Delete")
                    leading: false
                }
                swipe.left: SwipeAction {
                    text: qsTr("Flag")
                    color: Theme.accent
                    leading: true
                }
            }
        }
    }
}

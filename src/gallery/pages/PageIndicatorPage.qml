import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — PageIndicator.

CatalogPage {
    title: qsTr("PageIndicator")
    subtitle: qsTr("Indicates the current page in a multi-page view such as a SwipeView.")

    ControlExample {
        headerText: qsTr("PageIndicator with SwipeView")
        qmlSource: "PageIndicator {\n    count: 5\n    currentIndex: swipe.currentIndex\n}\nSwipeView {\n    id: swipe\n    // pages…\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            PageIndicator {
                count: 5
                currentIndex: swipe.currentIndex
            }

            SwipeView {
                id: swipe
                Layout.preferredWidth: 280
                Layout.preferredHeight: 80
                clip: true
                Repeater {
                    model: 5
                    Rectangle {
                        color: Theme.bgCard
                        border.color: Theme.strokeCard
                        radius: Theme.cornerControl
                        Label {
                            anchors.centerIn: parent
                            text: qsTr("Page %1").arg(index + 1)
                            color: Theme.textPrimary
                        }
                    }
                }
            }
        }
    }
}

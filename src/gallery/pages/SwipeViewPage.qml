import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — SwipeView.
//
// Enables the user to navigate through pages by swiping sideways. API: docs/components/SwipeView.md

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
                title: qsTr("SwipeView")
                subtitle: qsTr("Enables the user to navigate through pages by swiping sideways.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("SwipeView with PageIndicator")
                qmlSource: "SwipeView {\n    id: swipe\n    // 3 pages…\n}\nPageIndicator {\n    count: swipe.count\n    currentIndex: swipe.currentIndex\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    SwipeView {
                        id: swipe
                        Layout.preferredWidth: 320
                        Layout.preferredHeight: 120
                        clip: true

                        Rectangle {
                            color: Theme.bgCard
                            border.color: Theme.strokeCard
                            radius: Theme.cornerControl
                            Label {
                                anchors.centerIn: parent
                                text: qsTr("Page 1")
                                color: Theme.textPrimary
                            }
                        }
                        Rectangle {
                            color: Theme.bgCard
                            border.color: Theme.strokeCard
                            radius: Theme.cornerControl
                            Label {
                                anchors.centerIn: parent
                                text: qsTr("Page 2")
                                color: Theme.textPrimary
                            }
                        }
                        Rectangle {
                            color: Theme.bgCard
                            border.color: Theme.strokeCard
                            radius: Theme.cornerControl
                            Label {
                                anchors.centerIn: parent
                                text: qsTr("Page 3")
                                color: Theme.textPrimary
                            }
                        }
                    }

                    PageIndicator {
                        count: swipe.count
                        currentIndex: swipe.currentIndex
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

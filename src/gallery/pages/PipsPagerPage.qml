import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — PipsPager.
//
// Page indicators with selectedIndex, keyboard nav, and WinUI previous/next visibility. API: docs/components/PipsPager.md

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
                title: qsTr("PipsPager")
                subtitle: qsTr("Page indicators with selectedIndex, keyboard nav, and WinUI previous/next visibility.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("With FlipView")
                qmlSource: "PipsPager {\n    count: flip.count\n    selectedIndex: flip.currentIndex\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    FlipView {
                        id: flip
                        Layout.fillWidth: true
                        Layout.preferredHeight: 140
                        wrap: true
                        Rectangle {
                            color: Theme.bgAcrylic
                            Label { anchors.centerIn: parent; text: "1"; color: Theme.textPrimary }
                        }
                        Rectangle {
                            color: Theme.bgAcrylic
                            Label { anchors.centerIn: parent; text: "2"; color: Theme.textPrimary }
                        }
                        Rectangle {
                            color: Theme.bgAcrylic
                            Label { anchors.centerIn: parent; text: "3"; color: Theme.textPrimary }
                        }
                        Rectangle {
                            color: Theme.bgAcrylic
                            Label { anchors.centerIn: parent; text: "4"; color: Theme.textPrimary }
                        }
                    }
                    PipsPager {
                        Layout.alignment: Qt.AlignHCenter
                        count: flip.count
                        selectedIndex: flip.currentIndex
                        wrap: true
                        previousButtonVisibility: "visible"
                        nextButtonVisibility: "visible"
                        onCurrentIndexEdited: function (index) {
                            flip.currentIndex = index
                        }
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Visible on pointer over")
                qmlSource: "PipsPager {\n    previousButtonVisibility: \"visibleOnPointerOver\"\n}"
                PipsPager {
                    Layout.alignment: Qt.AlignHCenter
                    count: 5
                    selectedIndex: 2
                    previousButtonVisibility: "visibleOnPointerOver"
                    nextButtonVisibility: "visibleOnPointerOver"
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

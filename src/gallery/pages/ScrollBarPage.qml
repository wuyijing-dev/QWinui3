import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — ScrollBar.
//
// A control that lets the user scroll content that is larger than its viewport. API: docs/components/ScrollBar.md

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
                title: qsTr("ScrollBar")
                subtitle: qsTr("A control that lets the user scroll content that is larger than its viewport.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Vertical ScrollBar")
                qmlSource: "Flickable {\n    ScrollBar.vertical: ScrollBar {\n        policy: ScrollBar.AlwaysOn\n    }\n}"

                Frame {
                    Layout.preferredWidth: 320
                    Layout.preferredHeight: 160
                    padding: 0
                    background: Rectangle {
                        color: Theme.bgCard
                        border.color: Theme.strokeCard
                        radius: Theme.cornerControl
                    }

                    Flickable {
                        id: flick
                        anchors.fill: parent
                        anchors.margins: 8
                        contentHeight: col.height
                        clip: true
                        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn }

                        Column {
                            id: col
                            width: flick.width
                            spacing: 8
                            Repeater {
                                model: 20
                                Label {
                                    text: qsTr("Scrollable row %1").arg(index + 1)
                                    color: Theme.textPrimary
                                }
                            }
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

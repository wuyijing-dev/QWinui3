import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — SplitView.
//
// A layout that divides available space between resizable panes. API: docs/components/SplitView.md

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
                title: qsTr("SplitView")
                subtitle: qsTr("A layout that divides available space between resizable panes.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Horizontal SplitView")
                qmlSource: "SplitView {\n    orientation: Qt.Horizontal\n    Pane { }\n    Pane { }\n}"

                SplitView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    orientation: Qt.Horizontal

                    Pane {
                        SplitView.preferredWidth: 200
                        SplitView.minimumWidth: 80
                        Label {
                            text: qsTr("Left pane")
                            color: Theme.textPrimary
                        }
                    }
                    Pane {
                        SplitView.fillWidth: true
                        SplitView.minimumWidth: 80
                        Label {
                            text: qsTr("Right pane")
                            color: Theme.textPrimary
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

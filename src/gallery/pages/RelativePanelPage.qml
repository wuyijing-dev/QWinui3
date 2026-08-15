import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

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
                title: qsTr("RelativePanel")
                subtitle: qsTr("Sibling/panel constraints with panelSpacing and paddingEdges.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Align and adjacent")
                qmlSource: "RelativePanel {\n    paddingEdges: 8\n    panelSpacing: 8\n}"
                RelativePanel {
                    id: panel
                    Layout.fillWidth: true
                    Layout.preferredHeight: 260
                    panelSpacing: 8
                    paddingEdges: 8

                    Rectangle {
                        id: headerBlock
                        property var alignLeftWith: panel
                        property var alignRightWith: panel
                        property var alignTopWith: panel
                        implicitHeight: 44
                        color: Theme.fillSubtle
                        border.width: 1
                        border.color: Theme.strokeCard
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Header (align panel)")
                            color: Theme.textPrimary
                        }
                    }
                    Rectangle {
                        id: sideBlock
                        property var alignLeftWith: panel
                        property var below: headerBlock
                        property var alignBottomWith: panel
                        implicitWidth: 110
                        color: Theme.systemAttentionBg
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Left")
                            color: Theme.textPrimary
                        }
                    }
                    Rectangle {
                        id: mainBlock
                        property var rightOf: sideBlock
                        property var below: headerBlock
                        property var alignRightWith: panel
                        property var alignBottomWith: panel
                        color: Theme.bgCard
                        border.width: 1
                        border.color: Theme.strokeCard
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Main (rightOf Left)")
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

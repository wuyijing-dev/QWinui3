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
                title: qsTr("TwoPaneView")
                subtitle: qsTr("Adaptive dual-pane layout with modeName, panePriority, and swapPanes().")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Wide")
                qmlSource: "TwoPaneView {\n    preferredMode: TwoPaneView.Wide\n    pane1: ...\n}"
                TwoPaneView {
                    id: twoPane
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    preferredMode: TwoPaneView.Wide
                    minWideWidth: 480
                    pane1: Rectangle {
                        color: Theme.systemAttentionBg
                        Label {
                            anchors.centerIn: parent
                            text: qsTr("Pane 1")
                            color: Theme.textPrimary
                        }
                    }
                    pane2: Rectangle {
                        color: Theme.bgCard
                        Label {
                            anchors.centerIn: parent
                            text: qsTr("Pane 2 — resize the window to see SinglePane")
                            color: Theme.textSecondary
                            wrapMode: Text.Wrap
                            width: parent.width - 24
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Mode")
                qmlSource: "preferredMode: TwoPaneView.Tall"
                RowLayout {
                    spacing: Theme.spacing
                    Button {
                        text: qsTr("Wide")
                        onClicked: twoPane.preferredMode = TwoPaneView.Wide
                    }
                    Button {
                        text: qsTr("Tall")
                        onClicked: twoPane.preferredMode = TwoPaneView.Tall
                    }
                    Label {
                        text: qsTr("Current: %1").arg(twoPane.modeName)
                        color: Theme.textSecondary
                    }
                    Button {
                        text: qsTr("Swap panes")
                        onClicked: twoPane.swapPanes()
                    }
                    Button {
                        text: qsTr("Priority pane 2")
                        onClicked: {
                            twoPane.panePriority = TwoPaneView.Pane2
                            twoPane.minWideWidth = 10000
                        }
                    }
                    Button {
                        text: qsTr("Reset wide")
                        onClicked: {
                            twoPane.panePriority = TwoPaneView.Pane1
                            twoPane.minWideWidth = 480
                            twoPane.preferredMode = TwoPaneView.Wide
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

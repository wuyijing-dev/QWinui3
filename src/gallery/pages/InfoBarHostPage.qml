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
                title: qsTr("InfoBarHost")
                subtitle: qsTr("Stacks InfoBars with maxVisible, openAll()/clearAll(), and openCount.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Stacked bars")
                qmlSource: "InfoBarHost {\n    maxVisible: 3\n    InfoBar { … }\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    RowLayout {
                        spacing: Theme.spacing
                        Button {
                            text: qsTr("Close all (%1 open)").arg(host.openCount)
                            onClicked: host.clearAll()
                        }
                        Button {
                            text: qsTr("Open all")
                            onClicked: host.openAll()
                        }
                        Label {
                            text: qsTr("%1 bars").arg(host.count)
                            color: Theme.textSecondary
                        }
                    }
                    InfoBarHost {
                        id: host
                        Layout.fillWidth: true
                        maxVisible: 3
                        InfoBar {
                            Layout.fillWidth: true
                            id: infoBar
                            title: qsTr("Update available")
                            message: qsTr("QWinUI3 0.2 is ready to install.")
                            severity: infoBar.informational
                            actionText: qsTr("Download")
                        }
                        InfoBar {
                            Layout.fillWidth: true
                            id: warnBar
                            title: qsTr("Sync paused")
                            message: qsTr("Reconnect to continue syncing.")
                            severity: warnBar.warning
                        }
                        InfoBar {
                            Layout.fillWidth: true
                            id: autoBar
                            message: qsTr("This tip closes automatically.")
                            severity: autoBar.success
                            durationMs: 5000
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

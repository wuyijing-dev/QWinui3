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
                title: qsTr("RefreshContainer")
                subtitle: qsTr("Pull to refresh with Fluent Refresh spin, isRefreshing, and ProgressRing fallback.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Pull to refresh")
                qmlSource: "RefreshContainer {\n    pullToRefreshEnabled: true\n    onRefreshRequested: …\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    CheckBox {
                        id: pullEn
                        text: qsTr("Pull to refresh enabled")
                        checked: true
                    }
                    Button {
                        text: qsTr("Refresh")
                        onClicked: refreshHost.beginRefresh()
                    }
                    RefreshContainer {
                        id: refreshHost
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        contentWidth: width
                        contentHeight: refreshColumn.implicitHeight
                        pullToRefreshEnabled: pullEn.checked
                        onRefreshRequested: refreshTimer.start()

                        Rectangle {
                            width: refreshHost.width
                            height: refreshColumn.implicitHeight
                            color: Theme.bgCard
                            border.width: 1
                            border.color: Theme.strokeCard
                            radius: Theme.cornerCard

                            ColumnLayout {
                                id: refreshColumn
                                width: parent.width
                                spacing: 0
                                Repeater {
                                    model: 8
                                    ItemDelegate {
                                        Layout.fillWidth: true
                                        text: qsTr("Inbox item %1 — updated %2")
                                              .arg(index + 1)
                                              .arg(refreshStamp.text)
                                    }
                                }
                            }
                        }
                    }
                    Label {
                        id: refreshStamp
                        text: qsTr("just now")
                        color: Theme.textSecondary
                    }
                    Timer {
                        id: refreshTimer
                        interval: 1200
                        onTriggered: {
                            refreshStamp.text = Qt.formatTime(new Date(), "hh:mm:ss")
                            refreshHost.endRefresh()
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — RefreshContainer.
//
// Pull to refresh with Fluent Refresh spin, isRefreshing, and ProgressRing fallback. API: docs/components/RefreshContainer.md

CatalogPage {
    title: qsTr("RefreshContainer")
    subtitle: qsTr("Pull to refresh with Fluent Refresh spin, isRefreshing, and ProgressRing fallback.")

    ControlExample {
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
            RowLayout {
                Label { text: qsTr("PullDirection"); color: Theme.textSecondary }
                ComboBox {
                    id: pullDir
                    model: ["top", "bottom"]
                    currentIndex: 0
                    Layout.preferredWidth: 120
                }
                Button {
                    text: qsTr("Refresh")
                    onClicked: refreshHost.beginRefresh()
                }
            }
            RefreshContainer {
                id: refreshHost
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                contentWidth: width
                contentHeight: refreshColumn.implicitHeight
                pullToRefreshEnabled: pullEn.checked
                pullDirection: pullDir.currentText
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
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.qmlmodels
import QWinUI3.Theme

// Gallery — TableView.
//
// Tabular data with styled horizontal and vertical headers.

CatalogPage {
    title: qsTr("TableView")
    subtitle: qsTr("Tabular data with styled horizontal and vertical headers.")

    ControlExample {
        headerText: qsTr("Headers + cells")
        qmlSource: "HorizontalHeaderView { syncView: table }\nVerticalHeaderView { syncView: table }\nTableView { }"

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 260

            HorizontalHeaderView {
                id: horizontalHeader
                anchors.left: verticalHeader.right
                anchors.right: parent.right
                anchors.top: parent.top
                syncView: table
                clip: true
            }

            VerticalHeaderView {
                id: verticalHeader
                anchors.top: horizontalHeader.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                syncView: table
                clip: true
            }

            TableView {
                id: table
                anchors.left: verticalHeader.right
                anchors.right: parent.right
                anchors.top: horizontalHeader.bottom
                anchors.bottom: parent.bottom
                clip: true
                columnSpacing: 1
                rowSpacing: 1
                model: TableModel {
                    TableModelColumn { display: "name" }
                    TableModelColumn { display: "role" }
                    TableModelColumn { display: "status" }
                    rows: [
                        { name: "Alex", role: "Design", status: "Active" },
                        { name: "Jordan", role: "Engineering", status: "Away" },
                        { name: "Sam", role: "Product", status: "Active" },
                        { name: "Riley", role: "Support", status: "Busy" },
                        { name: "Casey", role: "Research", status: "Active" }
                    ]
                }
                delegate: Rectangle {
                    required property var model
                    implicitWidth: 140
                    implicitHeight: Theme.navItemHeight
                    color: Theme.bgCard
                    Text {
                        anchors.fill: parent
                        anchors.margins: 10
                        text: model.display ?? ""
                        color: Theme.textPrimary
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                    }
                }
            }
        }
    }
}

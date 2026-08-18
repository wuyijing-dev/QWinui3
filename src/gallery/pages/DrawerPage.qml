import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Drawer.
//
// A slide-out panel that presents navigation or contextual content from an edge. API: docs/components/Drawer.md

CatalogPage {
    title: qsTr("Drawer")
    subtitle: qsTr("Edge panel on Overlay — title, handle, modal, all four edges. Parent window Overlay.")

    overlay: Drawer {
        id: drawer
        parent: Overlay.overlay
        edge: {
            var m = edgeBox.model
            var i = edgeBox.currentIndex
            if (m && i >= 0 && m[i])
                return m[i].edge
            return Qt.LeftEdge
        }
        modal: modalSwitch.checked
        interactive: dragSwitch.checked
        dim: modalSwitch.checked
        title: qsTr("Pane")
        showHandle: handleSwitch.checked
        width: (edge === Qt.LeftEdge || edge === Qt.RightEdge)
               ? Math.min(Theme.dp(320), (Overlay.overlay ? Overlay.overlay.width : 1280) * 0.85)
               : implicitWidth
        height: (edge === Qt.TopEdge || edge === Qt.BottomEdge)
                ? Math.min(Theme.dp(280), (Overlay.overlay ? Overlay.overlay.height : 800) * 0.45)
                : implicitHeight

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacingLoose

            Label {
                text: qsTr("Drawer content")
                font.pixelSize: Theme.fontSubtitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            Label {
                text: qsTr("Use a Drawer for navigation or secondary actions. Footer buttons stay centered.")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                color: Theme.textSecondary
                horizontalAlignment: Text.AlignHCenter
            }
            ItemDelegate {
                Layout.fillWidth: true
                text: qsTr("Home")
            }
            ItemDelegate {
                Layout.fillWidth: true
                text: qsTr("Settings")
            }
            Item { Layout.fillHeight: true }
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacing
                Item { Layout.fillWidth: true }
                Button {
                    text: qsTr("Action")
                    highlighted: true
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: drawer.close()
                }
                Button {
                    text: qsTr("Close")
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: drawer.close()
                }
                Item { Layout.fillWidth: true }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Left / right / top / bottom")
        qmlSource: "Drawer {\n    edge: Qt.LeftEdge\n    title: qsTr(\"Pane\")\n    modal: true\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: Theme.spacingLoose
                rowSpacing: Theme.spacing
                Label { text: qsTr("Edge"); color: Theme.textSecondary }
                ComboBox {
                    id: edgeBox
                    Layout.preferredWidth: 180
                    textRole: "label"
                    valueRole: "edge"
                    model: [
                        { label: qsTr("Left"), edge: Qt.LeftEdge },
                        { label: qsTr("Right"), edge: Qt.RightEdge },
                        { label: qsTr("Top"), edge: Qt.TopEdge },
                        { label: qsTr("Bottom"), edge: Qt.BottomEdge }
                    ]
                    currentIndex: 0
                }
                Switch {
                    id: modalSwitch
                    text: qsTr("Modal + dim")
                    checked: true
                    Layout.columnSpan: 2
                }
                Switch {
                    id: dragSwitch
                    text: qsTr("Interactive drag")
                    checked: true
                    Layout.columnSpan: 2
                }
                Switch {
                    id: handleSwitch
                    text: qsTr("Edge handle")
                    checked: true
                    Layout.columnSpan: 2
                }
            }
            Button {
                text: qsTr("Open drawer")
                onClicked: drawer.open()
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SplitWorkspace + LayoutPreset.

CatalogPage {
    id: page

    title: qsTr("SplitWorkspace")
    subtitle: qsTr("2–3 resizable panes + named LayoutPreset — docs/app-platform-3xx.md.")

    ControlExample {
        headerText: qsTr("When to use")
        qmlSource: "SplitWorkspace { paneCount: 3; ratios: [0.25, 0.5, 0.25] }\nLayoutPreset { workspace: split; save(\"Editor\") }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use SplitWorkspace for IDE/ops-style side-by-side panes (not a docking framework). Prefer TwoPaneView / ListDetailsView for adaptive master–detail that collapses on narrow widths. Ctrl+Alt+Arrow focuses the next pane.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Three-pane workspace")
        qmlSource: "SplitWorkspace {\n    paneCount: 3\n    minPaneWidth: 80\n    pane1: …; pane2: …; pane3: …\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                ComboBox {
                    id: paneCountBox
                    model: [2, 3]
                    currentIndex: 1
                    Layout.preferredWidth: 80
                    Accessible.name: qsTr("Pane count")
                    onActivated: workspace.paneCount = Number(model[currentIndex])
                }
                Button {
                    text: qsTr("Horizontal")
                    onClicked: workspace.orientation = Qt.Horizontal
                }
                Button {
                    text: qsTr("Vertical")
                    onClicked: workspace.orientation = Qt.Vertical
                }
                Button {
                    text: qsTr("Focus next")
                    onClicked: workspace.focusNextPane()
                }
                Label {
                    Layout.fillWidth: true
                    color: Theme.textSecondary
                    text: qsTr("Focused pane: %1").arg(workspace.focusedPane + 1)
                }
            }
            SplitWorkspace {
                id: workspace
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                paneCount: 3
                minPaneWidth: 72
                minPaneHeight: 48
                ratios: [0.25, 0.5, 0.25]
                pane1: Rectangle {
                    color: Theme.systemAttentionBg
                    focus: true
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Pane 1")
                        color: Theme.textPrimary
                    }
                    border.width: workspace.focusedPane === 0 ? 2 : 0
                    border.color: Theme.accent
                }
                pane2: Rectangle {
                    color: Theme.bgCard
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Pane 2 — drag the splitter")
                        color: Theme.textSecondary
                        wrapMode: Text.Wrap
                        width: parent.width - 16
                        horizontalAlignment: Text.AlignHCenter
                    }
                    border.width: workspace.focusedPane === 1 ? 2 : 0
                    border.color: Theme.accent
                }
                pane3: Rectangle {
                    color: Theme.bgAcrylic
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Pane 3")
                        color: Theme.textPrimary
                    }
                    border.width: workspace.focusedPane === 2 ? 2 : 0
                    border.color: Theme.accent
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("LayoutPreset")
        qmlSource: "LayoutPreset {\n    category: \"Gallery/SplitLayouts\"\n    workspace: workspace\n    save(\"Editor\")\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Item {
                width: 0
                height: 0
                visible: false
                LayoutPreset {
                    id: layouts
                    category: "Gallery/SplitLayouts"
                    workspace: workspace
                }
            }
            RowLayout {
                Button {
                    text: qsTr("Save “Editor”")
                    onClicked: {
                        workspace.paneCount = 2
                        workspace.orientation = Qt.Horizontal
                        workspace.setRatios([0.3, 0.7])
                        layouts.save("Editor")
                        presetStatus.text = qsTr("Saved Editor")
                    }
                }
                Button {
                    text: qsTr("Save “Monitor”")
                    onClicked: {
                        workspace.paneCount = 3
                        workspace.orientation = Qt.Horizontal
                        workspace.setRatios([0.2, 0.55, 0.25])
                        layouts.save("Monitor")
                        presetStatus.text = qsTr("Saved Monitor")
                    }
                }
                Button {
                    text: qsTr("Apply Editor")
                    onClicked: {
                        layouts.apply("Editor")
                        presetStatus.text = qsTr("Applied Editor")
                    }
                }
                Button {
                    text: qsTr("Apply Monitor")
                    onClicked: {
                        layouts.apply("Monitor")
                        presetStatus.text = qsTr("Applied Monitor")
                    }
                }
            }
            Label {
                id: presetStatus
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: {
                    var n = layouts.names
                    return n.length
                           ? qsTr("Saved presets: %1").arg(n.join(", "))
                           : qsTr("No presets yet — save Editor or Monitor.")
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TwoPaneView.
//
// Adaptive dual-pane with showPane1()/showPane2()/toggleSinglePane() and swapPanes(). API: docs/components/TwoPaneView.md

CatalogPage {
    title: qsTr("TwoPaneView")
    subtitle: qsTr("Adaptive dual-pane with showPane1()/showPane2()/toggleSinglePane() and swapPanes().")

    ControlExample {
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
                text: qsTr("Toggle single pane")
                onClicked: {
                    twoPane.minWideWidth = 10000
                    twoPane.toggleSinglePane()
                }
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
                    twoPane.wideModeConfiguration = "leftRight"
                    twoPane.tallModeConfiguration = "topBottom"
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Wide / Tall configuration")
        qmlSource: "wideModeConfiguration: \"rightLeft\"\ntallModeConfiguration: \"bottomTop\""
        ColumnLayout {
            spacing: Theme.spacing
            RowLayout {
                Label { text: qsTr("Wide"); color: Theme.textSecondary }
                ComboBox {
                    id: wideCfg
                    model: ["leftRight", "rightLeft", "singlePane"]
                    currentIndex: 0
                    Layout.preferredWidth: 160
                    onActivated: twoPane.wideModeConfiguration = currentText
                }
                Label { text: qsTr("Tall"); color: Theme.textSecondary }
                ComboBox {
                    id: tallCfg
                    model: ["topBottom", "bottomTop", "singlePane"]
                    currentIndex: 0
                    Layout.preferredWidth: 160
                    onActivated: twoPane.tallModeConfiguration = currentText
                }
            }
            Label {
                text: qsTr("Mode: %1 · wide=%2 · tall=%3")
                        .arg(twoPane.modeName)
                        .arg(twoPane.wideModeConfiguration)
                        .arg(twoPane.tallModeConfiguration)
                color: Theme.textSecondary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }
}

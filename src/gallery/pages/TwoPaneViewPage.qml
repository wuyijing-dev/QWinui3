import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TwoPaneView.
//
// Recipe: docs/adaptive-layout.md — breakpoints, SinglePane, ListDetailsView.

CatalogPage {
    id: page

    title: qsTr("TwoPaneView")
    subtitle: qsTr("Wide / Tall / SinglePane — docs/adaptive-layout.md.")

    ControlExample {
        headerText: qsTr("Adaptive recipe")
        qmlSource: "TwoPaneView {\n    preferredMode: TwoPaneView.Wide\n    minWideWidth: 720\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Ship Wide side-by-side above minWideWidth (default 720). Below that → SinglePane; use showPane1/showPane2 or ListDetailsView Back/Esc. NavigationView autoCompactThreshold is 1008 (rail only). Density is separate — docs/density.md. Full cheat sheet: docs/adaptive-layout.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textPrimary
                text: qsTr("Demo mode: %1 · width: %2 · minWideWidth: %3")
                        .arg(twoPane.modeName)
                        .arg(Math.round(twoPane.width))
                        .arg(Math.round(twoPane.minWideWidth))
            }
        }
    }

    ControlExample {
        headerText: qsTr("Wide (resize Gallery to collapse)")
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
                    text: qsTr("Pane 1 (master)")
                    color: Theme.textPrimary
                }
            }
            pane2: Rectangle {
                color: Theme.bgCard
                Label {
                    anchors.centerIn: parent
                    text: qsTr("Pane 2 — shrink the window / raise minWideWidth to see SinglePane")
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
                text: qsTr("Force SinglePane")
                onClicked: {
                    twoPane.minWideWidth = 10000
                    twoPane.showPane1()
                }
            }
            Button {
                text: qsTr("Toggle pane")
                onClicked: twoPane.toggleSinglePane()
            }
            Button {
                text: qsTr("Priority pane 2")
                onClicked: {
                    twoPane.panePriority = TwoPaneView.Pane2
                    twoPane.minWideWidth = 10000
                    twoPane.showPane2()
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
                    twoPane.showPane1()
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
                text: qsTr("Mode: %1 · wide=%2 · tall=%3 — master–detail apps should prefer ListDetailsView (docs/adaptive-layout.md).")
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

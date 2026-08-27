import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Platform

// PanelFloatHost — Detach a pane into ToolShellWindow and dock it back (3.08 W8).
//
//   PanelFloatHost {
//       title: qsTr("Filters")
//       geometryPersistenceKey: "MyAppFilterFloat"
//       content: Rectangle { /* pane body */ }
//   }
//
//   // --- API ---
//   // methods: floatPane(), dockPane()
//   // properties: floating, title, subtitle, geometryPersistenceKey, content, showChrome
//
// @notes
//   Mutual-exclusive Loaders share one Component — not a full dock framework.
//   Closing the tool window docks the pane.

Item {
    id: root

    property alias title: floatWin.title
    property alias subtitle: floatWin.subtitle
    property string geometryPersistenceKey: "PanelFloat"
    property Component content: null
    property bool floating: false
    property bool showChrome: true
    property real chromeHeight: 36

    signal floated()
    signal docked()

    implicitWidth: 240
    implicitHeight: 200

    function floatPane() {
        if (root.floating)
            return
        root.floating = true
        floatWin.visible = true
        floatWin.raise()
        floatWin.requestActivate()
        floated()
    }

    function dockPane() {
        if (!root.floating)
            return
        root.floating = false
        floatWin.visible = false
        docked()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacing
        visible: !root.floating

        RowLayout {
            Layout.fillWidth: true
            visible: root.showChrome
            Layout.preferredHeight: root.chromeHeight
            spacing: Theme.spacing

            Label {
                Layout.fillWidth: true
                text: root.title
                elide: Text.ElideRight
                color: Theme.textPrimary
                font.weight: Theme.fontWeightSemiBold
            }
            Button {
                text: qsTr("Float")
                flat: true
                onClicked: root.floatPane()
            }
        }

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            active: !root.floating && root.content !== null
            sourceComponent: root.content
        }
    }

    Label {
        anchors.centerIn: parent
        visible: root.floating
        width: parent.width - Theme.spacingSection
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        color: Theme.textSecondary
        text: qsTr("Pane is floating — use Dock in the tool window.")
    }

    ToolShellWindow {
        id: floatWin
        title: qsTr("Panel")
        subtitle: qsTr("Floated pane")
        symbol: FluentIcons.OpenInNewWindow
        width: 360
        height: 480
        visible: false
        backdrop: WindowHelper.BackdropSolid
        geometryPersistenceKey: root.geometryPersistenceKey

        onClosing: function (close) {
            close.accepted = true
            if (root.floating)
                root.dockPane()
        }

        Pane {
            anchors.fill: parent
            padding: Theme.spacing
            background: null

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacing

                RowLayout {
                    Layout.fillWidth: true
                    Button {
                        text: qsTr("Dock")
                        highlighted: true
                        onClicked: root.dockPane()
                    }
                    Item { Layout.fillWidth: true }
                }

                Loader {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    active: root.floating && root.content !== null
                    sourceComponent: root.content
                }
            }
        }
    }
}

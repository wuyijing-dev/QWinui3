import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — CommandBar.
//
// Fluent More/Chevron, toggle(), secondaryCommands, and open/close signals.
// Keyboard recipe: docs/commands.md (1.15).

CatalogPage {
    title: qsTr("CommandBar")
    subtitle: qsTr("Primary/secondary AppBar row with overflow. Tab · F10/Alt+↓ · Esc — docs/commands.md.")

    overlay: Item {
        anchors.fill: parent
        ToastHost {
            id: toasts
            width: 360
            placement: ToastHost.BottomCenter
        }
        TextEdit {
            id: clipBuf
            visible: false
            width: 0
            height: 0
            function put(s) {
                text = s
                selectAll()
                copy()
            }
        }
    }

    function runCommand(name) {
        status.text = name
        toasts.info(name, qsTr("CommandBar"))
    }

    ControlExample {
        headerText: qsTr("Keyboard model (1.15)")
        qmlSource: "// Tab into bar · Space/Enter activate\n// F10 or Alt+Down → overflow · Esc closes Menu"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Tab focuses the command bar. Space/Enter activates the focused AppBar or more button. F10 or Alt+Down opens overflow (…); Esc dismisses the overflow menu. Icon-only buttons need text or Accessible.name.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Primary commands")
        qmlSource: "CommandBar {\n    AppBarButton { … }\n    secondaryCommandsHost: AppBarButton { text: \"Share\" }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Label { text: qsTr("Label"); color: Theme.textSecondary }
                ComboBox {
                    id: labelPos
                    model: ["bottom", "right", "collapsed"]
                    currentIndex: 0
                    Layout.preferredWidth: 140
                }
                Label { text: qsTr("Closed"); color: Theme.textSecondary }
                ComboBox {
                    id: closedMode
                    model: ["compact", "minimal", "hidden"]
                    currentIndex: 0
                    Layout.preferredWidth: 140
                }
            }
            CommandBar {
                id: cmdBar
                Layout.fillWidth: true
                defaultLabelPosition: labelPos.currentText
                closedDisplayMode: closedMode.currentText
                compact: false
                secondaryCommands: [
                    {
                        text: qsTr("Select all"),
                        triggered: function () { runCommand(qsTr("Select all")) }
                    },
                    {
                        text: qsTr("Find"),
                        triggered: function () { runCommand(qsTr("Find")) }
                    }
                ]
                secondaryCommandsHost: [
                    AppBarButton {
                        symbol: FluentIcons.Share
                        text: qsTr("Share")
                        onClicked: runCommand(qsTr("Share (host)"))
                    },
                    AppBarToggleButton {
                        symbol: FluentIcons.Pin
                        text: qsTr("Pin")
                        onClicked: runCommand(checked ? qsTr("Pinned") : qsTr("Unpinned"))
                    }
                ]
                onOpened: status.text = qsTr("Command bar opened")
                onClosed: status.text = qsTr("Command bar closed")
                AppBarButton {
                    symbol: FluentIcons.Copy
                    text: qsTr("Copy")
                    keyboardAcceleratorText: "Ctrl+C"
                    onClicked: {
                        clipBuf.put(qsTr("Copied from CommandBar"))
                        runCommand(qsTr("Copy"))
                    }
                }
                AppBarButton {
                    symbol: FluentIcons.Cut
                    text: qsTr("Cut")
                    onClicked: {
                        clipBuf.put(qsTr("Cut from CommandBar"))
                        runCommand(qsTr("Cut"))
                    }
                }
                AppBarSeparator {}
                AppBarButton {
                    symbol: FluentIcons.Delete
                    text: qsTr("Delete")
                    onClicked: runCommand(qsTr("Delete"))
                }
            }
            Label {
                id: status
                text: qsTr("Ready — Tab here, then F10 for overflow · … opens JS overflow + AppBar secondaryCommandsHost.")
                color: Theme.textSecondary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }

    ControlExample {
        headerText: qsTr("Alignment + compact (beyond WinUI)")
        qmlSource: "CommandBar {\n    commandAlignment: \"center\"\n    compact: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Label { text: qsTr("Align"); color: Theme.textSecondary }
                ComboBox {
                    id: alignBox
                    model: ["stretch", "left", "center", "right"]
                    currentIndex: 2
                    Layout.preferredWidth: 140
                }
                Switch {
                    id: compactSwitch
                    text: qsTr("Compact")
                    checked: true
                }
            }
            CommandBar {
                Layout.fillWidth: true
                commandAlignment: alignBox.currentText
                compact: compactSwitch.checked
                defaultLabelPosition: "collapsed"
                isToggleButtonVisible: false
                secondaryCommands: [
                    { text: qsTr("More options"), triggered: function () {} }
                ]
                AppBarButton {
                    symbol: FluentIcons.Copy
                    text: qsTr("Copy")
                    onClicked: runCommand(qsTr("Copy"))
                }
                AppBarButton {
                    symbol: FluentIcons.Cut
                    text: qsTr("Cut")
                    onClicked: runCommand(qsTr("Cut"))
                }
                AppBarButton {
                    symbol: FluentIcons.Delete
                    text: qsTr("Delete")
                    onClicked: runCommand(qsTr("Delete"))
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("WinUI CommandBar is oversized and right-biased; compact ~40px icons and free alignment match Edge-style toolbars.")
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — SwipeControl.
//
// Reveal actions with ElevatedChrome panel, keyboard arrows / Esc, and isOpen.
// Deepen 2.42: thresholds, nested scroll, TeachingTip. docs/touch-pointer.md

CatalogPage {
    id: page

    title: qsTr("SwipeControl")
    subtitle: qsTr("Thresholds · nested scroll · teaching — docs/touch-pointer.md (2.42).")

    ControlExample {
        headerText: qsTr("Thresholds (2.42)")
        qmlSource: "SwipeControl {\n    revealThreshold: 36\n    dragThreshold: 12\n    nestedScrollFriendly: false\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("revealThreshold — release distance to snap open (or invoke in execute mode). dragThreshold — pointer travel before horizontal drag engages. nestedScrollFriendly raises dragThreshold inside vertical lists so flick scroll wins. docs/touch-pointer.md SwipeControl deepen.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Label { text: qsTr("revealThreshold"); color: Theme.textSecondary }
                SpinBox {
                    id: revealSpin
                    from: 16
                    to: 80
                    value: tuneSwipe.revealThreshold
                    onValueChanged: tuneSwipe.revealThreshold = value
                }
                Label { text: qsTr("dragThreshold"); color: Theme.textSecondary }
                SpinBox {
                    id: dragSpin
                    from: 4
                    to: 32
                    value: tuneSwipe.dragThreshold
                    onValueChanged: tuneSwipe.dragThreshold = value
                }
                CheckBox {
                    text: qsTr("nestedScrollFriendly")
                    checked: tuneSwipe.nestedScrollFriendly
                    onCheckedChanged: tuneSwipe.nestedScrollFriendly = checked
                }
            }
            SwipeControl {
                id: tuneSwipe
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                nestedScrollFriendly: true
                rightActions: [
                    SwipeAction {
                        width: 72
                        height: parent.height
                        text: qsTr("Done")
                        symbol: FluentIcons.Accept
                        behaviorOnInvoked: "close"
                        onTriggered: tuneStatus.text = qsTr("Done")
                    }
                ]
                content: [
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Tune thresholds · effective drag %1 px")
                                .arg(tuneSwipe.effectiveDragThreshold)
                    }
                ]
            }
            Label {
                id: tuneStatus
                color: Theme.textSecondary
                text: qsTr("Swipe to test thresholds")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Nested scroll list (2.42)")
        qmlSource: "ScrollView {\n    Column { SwipeControl { nestedScrollFriendly: true } }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Rows inside ScrollView use nestedScrollFriendly so vertical flick is not stolen by horizontal drag. Each row also exposes ⋯ overflow — swipe is not the only path.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                clip: true
                ColumnLayout {
                    width: parent.width
                    spacing: Theme.spacingTight
                    Repeater {
                        model: 6
                        delegate: SwipeControl {
                            required property int index
                            Layout.fillWidth: true
                            nestedScrollFriendly: true
                            rightActions: [
                                SwipeAction {
                                    width: 72
                                    height: parent.height
                                    text: qsTr("Remove")
                                    symbol: FluentIcons.Delete
                                    behaviorOnInvoked: "close"
                                    onTriggered: listStatus.text = qsTr("Removed row %1").arg(index + 1)
                                }
                            ]
                            content: [
                                RowLayout {
                                    anchors.fill: parent
                                    spacing: Theme.spacing
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Label {
                                            text: qsTr("Inbox item %1").arg(index + 1)
                                            font.weight: Theme.fontWeightSemiBold
                                        }
                                        Label {
                                            text: qsTr("Scroll vertically · swipe horizontally")
                                            color: Theme.textSecondary
                                            font.pixelSize: Theme.fontCaption
                                        }
                                    }
                                    IconButton {
                                        id: moreBtn
                                        symbol: FluentIcons.More
                                        Accessible.name: qsTr("More actions")
                                        onClicked: rowMenu.showAt(moreBtn)
                                    }
                                },
                                MenuFlyout {
                                    id: rowMenu
                                    title: qsTr("Row actions")
                                    MenuFlyoutItem {
                                        text: qsTr("Remove")
                                        symbol: FluentIcons.Delete
                                        onTriggered: listStatus.text = qsTr("Menu remove row %1").arg(index + 1)
                                    }
                                }
                            ]
                        }
                    }
                }
            }
            Label {
                id: listStatus
                color: Theme.textSecondary
                text: qsTr("Try vertical scroll + horizontal swipe")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Teaching tip (2.42)")
        qmlSource: "TeachingTip { target: swipeRow }\n// First-run only — also expose ⋯ menu"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("TeachingTip coaches first swipe — not a substitute for overflow/menu. Persist dismissed state with Settings or OnboardingCoach (docs/feedback.md).")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            SwipeControl {
                id: teachRow
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                rightActions: [
                    SwipeAction {
                        width: 72
                        height: parent.height
                        text: qsTr("Pin")
                        symbol: FluentIcons.Pinned
                        behaviorOnInvoked: "close"
                        onTriggered: teachStatus.text = qsTr("Pinned")
                    }
                ]
                content: [
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("First row — show teaching tip")
                    }
                ]
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Show swipe tip")
                    onClicked: swipeTip.open()
                }
                Label {
                    id: teachStatus
                    Layout.fillWidth: true
                    color: Theme.textSecondary
                    text: qsTr("Tip targets the row above")
                }
            }
            TeachingTip {
                id: swipeTip
                parent: Overlay.overlay
                target: teachRow
                preferredPlacement: Qt.AlignBottom
                title: qsTr("Swipe for actions")
                subtitle: qsTr("Or use keyboard ← → and Esc · overflow menu on list rows")
                actionText: qsTr("Got it")
                onActionClicked: swipeTip.close()
            }
        }
    }

    ControlExample {
        headerText: qsTr("Mail item")
        qmlSource: "SwipeControl {\n    leftActions: SwipeAction { symbol: FluentIcons.Flag }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: swipeStatus
                text: qsTr("Closed")
                color: Theme.textSecondary
            }
            SwipeControl {
                id: swipe
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                leftActions: [
                    SwipeAction {
                        width: 72
                        height: parent.height
                        leading: true
                        text: qsTr("Flag")
                        symbol: FluentIcons.Flag
                        color: Theme.systemCaution
                        onClicked: swipeStatus.text = qsTr("Flag")
                    }
                ]
                rightActions: [
                    SwipeAction {
                        width: 72
                        height: parent.height
                        text: qsTr("Delete")
                        symbol: FluentIcons.Delete
                        behaviorOnInvoked: "close"
                        onTriggered: swipeStatus.text = qsTr("Delete")
                    },
                    SwipeAction {
                        width: 72
                        height: parent.height
                        text: qsTr("Copy")
                        symbol: FluentIcons.Copy
                        color: Theme.systemAttention
                        behaviorOnInvoked: "remainOpen"
                        onTriggered: swipeStatus.text = qsTr("Copy (remain open)")
                    }
                ]
                content: [
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 2
                        Label {
                            text: qsTr("Weekly design sync")
                            font.weight: Theme.fontWeightSemiBold
                        }
                        Label {
                            text: qsTr("Swipe or use ← → / Esc")
                            color: Theme.textSecondary
                        }
                    }
                ]
                onOpened: function (mode) {
                    swipeStatus.text = mode === swipe.leftOpen
                            ? qsTr("Left open") : qsTr("Right open")
                }
                onClosed: swipeStatus.text = qsTr("Closed")
            }
            RowLayout {
                spacing: Theme.spacing
                Button { text: qsTr("Open left"); onClicked: swipe.openLeft() }
                Button { text: qsTr("Open right"); onClicked: swipe.openRight() }
                Button { text: qsTr("Close"); onClicked: swipe.close() }
            }
        }
    }
    ControlExample {
        headerText: qsTr("Execute mode")
        qmlSource: "SwipeControl {\n    swipeMode: \"execute\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: execStatus
                text: qsTr("Swipe past threshold to invoke")
                color: Theme.textSecondary
            }
            SwipeControl {
                Layout.fillWidth: true
                Layout.maximumWidth: 420
                swipeMode: "execute"
                revealThreshold: 48
                rightActions: [
                    SwipeAction {
                        width: 88
                        height: parent.height
                        text: qsTr("Archive")
                        symbol: FluentIcons.Folder
                        color: Theme.systemAttention
                        behaviorOnInvoked: "close"
                        onTriggered: execStatus.text = qsTr("Archived (execute)")
                    }
                ]
                content: [
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Swipe left to archive")
                    }
                ]
            }
        }
    }
}

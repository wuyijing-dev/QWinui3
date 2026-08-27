import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — NotificationCenter + feedback product stack.
//
// In-app history + grouping; NotificationBridge wiring; InfoBadge bell. docs/notification-center-263.md

CatalogPage {
    id: page
    title: qsTr("Notification center")
    subtitle: qsTr("Toast + history + bridge — experimental, docs/notification-center-263.md.")

    property int saveProgress: 0
    property bool saving: false

    readonly property var seedNotifications: [
        {
            title: qsTr("Build succeeded"),
            message: qsTr("Release pipeline finished."),
            category: qsTr("CI"),
            severity: 1,
            read: false
        },
        {
            title: qsTr("Review requested"),
            message: qsTr("Alex commented on PR #128."),
            category: qsTr("Social"),
            severity: 0,
            read: false,
            actionText: qsTr("Open")
        },
        {
            title: qsTr("Disk space"),
            message: qsTr("Volume D: below 10% free."),
            category: qsTr("System"),
            severity: 2,
            read: true
        }
    ]

    overlay: ColumnLayout {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Theme.spacingSection
        spacing: Theme.spacing

        ToastHost {
            id: toasts
            width: 340
            placement: ToastHost.TopRight
        }

        InfoBarHost {
            id: bars
            width: 340
            maxVisible: 2
            InfoBar {
                id: saveBar
                severity: saveBar.informational
                title: qsTr("Saving")
                message: qsTr("Uploading preferences…")
                isOpen: false
            }
        }
    }

    NotificationCenter {
        id: center
        model: seedNotifications.slice()
        maxHistory: 50
    }

    NotificationBridge {
        id: bridge
        toastHost: toasts
        notificationCenter: center
        recordInCenter: true
        defaultCategory: qsTr("Gallery")
        mirrorToSystem: false
    }

    Timer {
        id: saveTimer
        interval: 120
        repeat: true
        onTriggered: {
            page.saveProgress = Math.min(100, page.saveProgress + 8)
            if (page.saveProgress >= 100) {
                saveTimer.stop()
                page.saving = false
                saveBar.isOpen = false
                saveRing.isActive = false
                bridge.success(qsTr("Preferences saved."), qsTr("Saved"), "", "prefs-save")
            }
        }
    }

    ControlExample {
        headerText: qsTr("NotificationBridge product stack")
        qmlSource: "NotificationBridge {\n    toastHost: toasts\n    notificationCenter: center\n    recordInCenter: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("one bridge.success() → ToastHost ack + NotificationCenter history. Pass dedupe id to collapse repeats. maxHistory caps stored rows. docs/notification-center-263.md")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Bridge success (dedupe)")
                    onClicked: bridge.success(
                        qsTr("Sync complete."),
                        qsTr("Cloud"),
                        "",
                        "sync-status")
                }
                Button {
                    text: qsTr("Bridge warning")
                    onClicked: bridge.warning(
                        qsTr("Retry scheduled."),
                        qsTr("Network"),
                        "",
                        "net-retry")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Bell + InfoBadge")
        qmlSource: "NotificationCenter { model: […] }\nInfoBadge { value: unreadCount }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("ToastHost acks are transient. NotificationCenter keeps grouped history with mark read / clear. Pair InfoBadge on a nav bell with unreadCount.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                spacing: Theme.spacingLoose
                IconButton {
                    id: bell
                    symbol: FluentIcons.Ringer
                    Accessible.name: qsTr("Notifications")
                    onClicked: center.open()
                    InfoBadge {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.rightMargin: -2
                        anchors.topMargin: -2
                        visible: center.unreadCount > 0
                        value: center.unreadCount
                        severity: center.attention
                    }
                }
                Label {
                    text: qsTr("%1 unread · %2 total")
                        .arg(center.unreadCount).arg(center.model.length)
                    color: Theme.textSecondary
                }
                Button {
                    text: qsTr("Push sample")
                    onClicked: {
                        bridge.show(
                            qsTr("You were tagged in Docs."),
                            bridge.severityInformational,
                            qsTr("New mention"),
                            qsTr("View"),
                            "mention-demo")
                    }
                }
            }
            Label {
                id: actionHint
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
                text: qsTr("Click a row to mark read. Use Mark all read / Clear read in the drawer.")
            }
        }
    }

    Component.onCompleted: {
        center.notificationActionClicked.connect(function (index, item) {
            actionHint.text = qsTr("Action on row %1: %2").arg(index).arg(item.title || "")
            center.close()
        })
        center.notificationClicked.connect(function (index, item) {
            if (item && item.read)
                actionHint.text = qsTr("Opened read item: %1").arg(item.title || "")
        })
    }

    ControlExample {
        headerText: qsTr("ProgressRing + InfoBar save path")
        qmlSource: "ProgressRing { isActive: saving }\nInfoBar { … }\nToastHost.success(...)"
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            ProgressRing {
                id: saveRing
                Layout.preferredWidth: 44
                Layout.preferredHeight: 44
                maximum: 100
                value: page.saveProgress
                isActive: page.saving
            }
            ColumnLayout {
                spacing: 4
                Label {
                    text: page.saving
                         ? qsTr("Saving… %1%").arg(page.saveProgress)
                         : qsTr("Idle — start a save demo")
                    color: Theme.textPrimary
                }
                Label {
                    text: qsTr("Progress belongs next to the work — not a toast.")
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontCaption
                }
            }
            Button {
                text: qsTr("Simulate save")
                highlighted: true
                enabled: !page.saving
                onClicked: {
                    page.saving = true
                    page.saveProgress = 0
                    saveRing.isActive = true
                    saveBar.isOpen = true
                    saveTimer.start()
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("TeachingTip — first open")
        qmlSource: "TeachingTip { target: bell; title: … }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Coach the bell once — focus returns to target on dismiss (docs/feedback.md).")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
            RowLayout {
                Button {
                    text: qsTr("Show tip")
                    onClicked: bellTip.isOpen = true
                }
                Button {
                    flat: true
                    text: qsTr("Reset demo data")
                    onClicked: center.model = seedNotifications.slice()
                }
            }
            TeachingTip {
                id: bellTip
                target: bell
                title: qsTr("Notification center")
                subtitle: qsTr("Grouped history lives here — toasts still handle transient acks.")
                actionText: qsTr("Got it")
                preferredPlacement: Qt.AlignBottom
                isLightDismissEnabled: true
            }
        }
    }
}

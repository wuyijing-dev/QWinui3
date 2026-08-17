import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Dialogs & flyouts chooser (1.16 / 1.37 / 1.48).
//
// Recipe: docs/dialogs-flyouts.md · ContentDialogQueue deepen (1.48)

CatalogPage {
    title: qsTr("Dialogs & flyouts")
    subtitle: qsTr("ContentDialog queue · Flyout · TeachingTip · Drawer. Recipe: docs/dialogs-flyouts.md (1.48).")

    ControlExample {
        headerText: qsTr("When to use which (1.16 / 1.37 / 1.48)")
        qmlSource: "// ContentDialog — blocking + queue\n// Flyout / TeachingTip — light-dismiss\n// Drawer — edge panel"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("ContentDialog (+ ContentDialogQueue) for confirms and multi-step save/export chains. Flyout for short contextual UI. TeachingTip for coach marks (sequenced tours: Onboarding coach, 1.55). Drawer for edge navigation. MenuFlyout for action lists (see Commands). Queue FIFO / owner Overlay / Esc: docs/dialogs-flyouts.md (1.48).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("ContentDialog: Enter activates defaultButton; Esc uses the close path and honors onClosing cancel. Outside click does not dismiss. Stress demo: ContentDialog page → Enqueue A → B → C.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Queue / owner / Esc (1.48)")
        qmlSource: "parent: Overlay.overlay\nshow() → FIFO · replaceCurrent · onClosing"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Parent each ContentDialog on the owner window Overlay.overlay. show() opens immediately or enqueues FIFO. cancel drops pending only. clearQueue keeps the active dialog. replaceCurrent closes active without pumping pending. Esc → close path; onClosing can set args.cancel. Stress: ContentDialog → Enqueue A→B→C.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("busy=%1 · pendingCount=%2")
                    .arg(ContentDialogQueue.busy)
                    .arg(ContentDialogQueue.pendingCount)
            }
        }
    }

    ControlExample {
        headerText: qsTr("Open related demos")
        qmlSource: "// Gallery pages: ContentDialog, Flyout, TeachingTip, Drawer, MenuFlyout"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use the nav search or category Dialogs & flyouts / Recipes for:")
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("• ContentDialog — queue stress A→B→C, defaultButton, Closing cancel (1.48)\n• Flyout — placement + light dismiss\n• TeachingTip — coach mark + Onboarding coach sequence (1.55) + InfoBar recipe\n• Drawer — edge panel on Overlay\n• MenuFlyout — context actions (commands.md)")
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Quick ContentDialog")
        qmlSource: "ContentDialog { … }\ndlg.show()  // queue"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Button {
                text: qsTr("Show sample dialog")
                highlighted: true
                onClicked: sampleDlg.show()
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Try Esc with “Block close” checked on the ContentDialog page for Closing cancel. This sample uses default Esc → close.")
                color: Theme.textSecondary
            }
        }
    }

    overlay: ContentDialog {
        id: sampleDlg
        parent: Overlay.overlay
        anchors.centerIn: Overlay.overlay
        title: qsTr("Sample confirm")
        primaryButtonText: qsTr("OK")
        closeButtonText: qsTr("Cancel")
        defaultButton: "primary"
        Label {
            text: qsTr("Enter activates OK. Esc cancels via the close path (1.16).")
            wrapMode: Text.Wrap
            color: Theme.textPrimary
        }
    }
}

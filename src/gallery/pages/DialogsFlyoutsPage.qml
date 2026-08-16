import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Dialogs & flyouts chooser (1.16).
//
// Recipe: docs/dialogs-flyouts.md

CatalogPage {
    title: qsTr("Dialogs & flyouts")
    subtitle: qsTr("Modal vs light-dismiss. Recipe: docs/dialogs-flyouts.md — open each control page for demos.")

    ControlExample {
        headerText: qsTr("When to use which (1.16)")
        qmlSource: "// ContentDialog — blocking\n// Flyout / TeachingTip — light-dismiss\n// Drawer — edge panel"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("ContentDialog (+ queue) for confirms and save/discard. Flyout for short contextual UI. TeachingTip for coach marks. Drawer for edge navigation. MenuFlyout for action lists (see Commands).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("ContentDialog: Enter activates defaultButton; Esc uses the close path and honors onClosing cancel. Outside click does not dismiss.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textPrimary
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
                text: qsTr("Use the nav search or category Dialogs & flyouts / Layout for:")
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("• ContentDialog — queue, defaultButton, Closing cancel\n• Flyout — placement + light dismiss\n• TeachingTip — coach mark + InfoBar recipe page\n• Drawer — edge panel on Overlay\n• MenuFlyout — context actions (commands.md)")
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

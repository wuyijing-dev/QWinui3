import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — InfoBar.
//
// Severity alerts with Fluent ChromeClose, open()/close(), and Accessible.
// Recipe: docs/feedback.md (1.34) · API: docs/components/InfoBar.md

CatalogPage {
    title: qsTr("InfoBar")
    subtitle: qsTr("Inline severity banner. Stack via InfoBarHost — docs/feedback.md (1.34).")

    ControlExample {
        headerText: qsTr("Surface variants (2.67 A4)")
        qmlSource: "InfoBar {\n    appearance: \"outline\"\n    severity: warning\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            InfoBar {
                title: qsTr("Filled")
                message: qsTr("Default severity fill.")
                severity: informational
                appearance: "filled"
                closable: false
            }
            InfoBar {
                title: qsTr("Outline")
                message: qsTr("Transparent fill, severity stroke.")
                severity: warning
                appearance: "outline"
                closable: false
            }
            InfoBar {
                title: qsTr("Accent")
                message: qsTr("Tinted severity wash.")
                severity: success
                appearance: "accent"
                closable: false
            }
        }
    }

    ControlExample {
        headerText: qsTr("When to use (1.34)")
        qmlSource: "// InfoBar — stays on page\n// ToastHost — transient\n// docs/feedback.md"
        ColumnLayout {
            Layout.fillWidth: true
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Prefer InfoBar for page-level status and validation. Use ToastHost for short acks. ContentDialog for blocking confirms.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Severity levels")
        qmlSource: "InfoBar {\n    severity: informational\n    // severityName → \"informational\"\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            InfoBar {
                id: infoSample
                severity: infoSample.informational
                title: qsTr("Information")
                message: qsTr("This is an informational message. (%1)").arg(infoSample.severityName)
            }
            InfoBar {
                id: successSample
                severity: successSample.success
                title: qsTr("Success")
                message: qsTr("The operation completed successfully.")
            }
            InfoBar {
                id: warningSample
                severity: warningSample.warning
                title: qsTr("Warning")
                message: qsTr("Please review this setting before continuing.")
            }
            InfoBar {
                id: errorSample
                severity: errorSample.error
                title: qsTr("Error")
                message: qsTr("Something went wrong. Try again.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("With action")
        qmlSource: "InfoBar {\n    actionText: \"Fix now\"\n    onActionClicked: { … }\n}"

        InfoBar {
            id: actionBar
            severity: actionBar.warning
            title: qsTr("Update available")
            message: qsTr("A new version is ready to install.")
            actionText: qsTr("Install")
            onActionClicked: actionBar.message = qsTr("Installing…")
        }
    }

    ControlExample {
        headerText: qsTr("Content slot")
        qmlSource: "InfoBar {\n    title: …\n    HyperlinkButton { text: \"Learn more\" }\n}"

        InfoBar {
            id: contentBar
            severity: contentBar.informational
            title: qsTr("Privacy")
            message: qsTr("Review how your data is used.")
            Button {
                flat: true
                text: qsTr("Learn more")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Content-only (no title gap)")
        qmlSource: "InfoBar {\n    // no title / message\n    Label { text: \"Short message\" }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            InfoBar {
                id: contentOnlyBar
                severity: contentOnlyBar.informational
                Label {
                    text: qsTr("Content-only InfoBar — no empty title row (WinUI #8730).")
                    color: Theme.textPrimary
                    wrapMode: Text.Wrap
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                color: Theme.textSecondary
                text: qsTr("When title and message are empty, Content sits on the primary row beside the icon.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("open() / close()")
        qmlSource: "InfoBar {\n    collapseWhenClosed: true\n    onOpened: …\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                id: lifeStatus
                text: qsTr("Ready")
                color: Theme.textSecondary
            }
            InfoBar {
                id: collapseBar
                severity: collapseBar.informational
                title: qsTr("Dismiss me")
                message: qsTr("Closing collapses layout space immediately (vs WinUI IsOpen keeping StackPanel spacing).")
                collapseWhenClosed: true
                onOpened: lifeStatus.text = qsTr("Opened")
                onClosed: lifeStatus.text = qsTr("Closed")
            }
            Button {
                text: collapseBar.isOpen ? qsTr("Close InfoBar") : qsTr("Reopen InfoBar")
                onClicked: collapseBar.isOpen ? collapseBar.close() : collapseBar.open()
            }
        }
    }
}


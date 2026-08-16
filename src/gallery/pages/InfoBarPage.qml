import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — InfoBar.
//
// Severity alerts with Fluent ChromeClose, open()/close(), and Accessible. API: docs/components/InfoBar.md

CatalogPage {
    title: qsTr("InfoBar")
    subtitle: qsTr("Severity alerts with Fluent ChromeClose, open()/close(), and Accessible.")

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
        headerText: qsTr("open() / close()")
        qmlSource: "InfoBar {\n    onOpened: …\n    onClosed: …\n}"

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
                message: qsTr("Closing this bar collapses layout space (WinUI IsOpen).")
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

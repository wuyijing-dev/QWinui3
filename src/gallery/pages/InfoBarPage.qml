import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — InfoBar.
//
// Severity alerts with Fluent ChromeClose, open()/close(), and Accessible. API: docs/components/InfoBar.md

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection

            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("InfoBar")
                subtitle: qsTr("Severity alerts with Fluent ChromeClose, open()/close(), and Accessible.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Severity levels")
                qmlSource: "InfoBar {\n    severity: informational\n    // severityName → \"informational\"\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    InfoBar {
                        id: infoSample
                        Layout.fillWidth: true
                        severity: infoSample.informational
                        title: qsTr("Information")
                        message: qsTr("This is an informational message. (%1)").arg(infoSample.severityName)
                    }
                    InfoBar {
                        id: successSample
                        Layout.fillWidth: true
                        severity: successSample.success
                        title: qsTr("Success")
                        message: qsTr("The operation completed successfully.")
                    }
                    InfoBar {
                        id: warningSample
                        Layout.fillWidth: true
                        severity: warningSample.warning
                        title: qsTr("Warning")
                        message: qsTr("Please review this setting before continuing.")
                    }
                    InfoBar {
                        id: errorSample
                        Layout.fillWidth: true
                        severity: errorSample.error
                        title: qsTr("Error")
                        message: qsTr("Something went wrong. Try again.")
                    }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("With action")
                qmlSource: "InfoBar {\n    actionText: \"Fix now\"\n    onActionClicked: { … }\n}"

                InfoBar {
                    id: actionBar
                    Layout.fillWidth: true
                    severity: actionBar.warning
                    title: qsTr("Update available")
                    message: qsTr("A new version is ready to install.")
                    actionText: qsTr("Install")
                    onActionClicked: actionBar.message = qsTr("Installing…")
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Content slot")
                qmlSource: "InfoBar {\n    title: …\n    HyperlinkButton { text: \"Learn more\" }\n}"

                InfoBar {
                    id: contentBar
                    Layout.fillWidth: true
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
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
                        Layout.fillWidth: true
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

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

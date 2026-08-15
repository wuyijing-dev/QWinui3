import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

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
                subtitle: qsTr("An inline message to inform users about app-wide or page-level events.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Severity levels")
                qmlSource: "InfoBar {\n    severity: informational\n    title: \"Information\"\n    message: \"…\"\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    InfoBar {
                        id: infoSample
                        Layout.fillWidth: true
                        severity: infoSample.informational
                        title: qsTr("Information")
                        message: qsTr("This is an informational message.")
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
                headerText: qsTr("Close collapses height")
                qmlSource: "InfoBar {\n    isOpen: true\n    // closes to zero height\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    InfoBar {
                        id: collapseBar
                        Layout.fillWidth: true
                        severity: collapseBar.informational
                        title: qsTr("Dismiss me")
                        message: qsTr("Closing this bar collapses layout space (WinUI IsOpen).")
                    }
                    Button {
                        text: collapseBar.isOpen ? qsTr("Close InfoBar") : qsTr("Reopen InfoBar")
                        onClicked: collapseBar.isOpen = !collapseBar.isOpen
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

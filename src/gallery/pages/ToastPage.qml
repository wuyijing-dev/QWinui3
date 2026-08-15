import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
    Toast {
        id: toast
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        title: qsTr("Toast")
    }

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
                title: qsTr("Toast")
                subtitle: qsTr("Transient notification with Fluent severity icons, HyperlinkButton action, and progress.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Show toast")
                qmlSource: "Toast {\n    title: \"Saved\"\n    message: \"…\"\n}\ntoast.show(\"Done\", toast.success)"
                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    AccentButton {
                        text: qsTr("Info")
                        onClicked: {
                            toast.title = qsTr("Information")
                            toast.show(qsTr("Something happened."), toast.informational)
                        }
                    }
                    Button {
                        text: qsTr("Success")
                        onClicked: {
                            toast.title = qsTr("Success")
                            toast.show(qsTr("Your changes were saved."), toast.success)
                        }
                    }
                    Button {
                        text: qsTr("Warning")
                        onClicked: {
                            toast.title = qsTr("Warning")
                            toast.show(qsTr("Check your connection."), toast.warning)
                        }
                    }
                    Button {
                        text: qsTr("Error")
                        onClicked: {
                            toast.title = qsTr("Error")
                            toast.actionText = qsTr("Retry")
                            toast.show(qsTr("Unable to complete the request."), toast.error)
                        }
                    }
                    Button {
                        text: qsTr("With action")
                        onClicked: {
                            toast.title = qsTr("Clipboard")
                            toast.actionText = qsTr("View")
                            toast.pauseOnHover = true
                            toast.show(qsTr("Content copied — hover to pause."), toast.success)
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

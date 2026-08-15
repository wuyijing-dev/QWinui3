import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
    ToastHost {
        id: host
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        width: 360
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
                title: qsTr("ToastHost")
                subtitle: qsTr("Queues toasts; info()/successToast()/errorToast() helpers, newestOnTop, clear().")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Enqueue")
                qmlSource: "ToastHost { id: host }\nhost.show(\"Saved\", host.success, \"Done\")"
                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    AccentButton {
                        text: qsTr("Info")
                        onClicked: host.info(qsTr("Something happened."))
                    }
                    Button {
                        text: qsTr("Success")
                        onClicked: host.successToast(qsTr("Your changes were saved."))
                    }
                    Button {
                        text: qsTr("Warning")
                        onClicked: host.warningToast(qsTr("Check your connection."))
                    }
                    Button {
                        text: qsTr("Error + action")
                        onClicked: host.errorToast(qsTr("Unable to complete the request."), qsTr("Error"), qsTr("Retry"))
                    }
                    Button {
                        text: qsTr("Clear (%1)").arg(host.count)
                        onClicked: host.clear()
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

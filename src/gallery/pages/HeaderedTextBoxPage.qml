import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — HeaderedTextBox.
//
// Header, description, error icon, clear button, and optional characterLimit. API: docs/components/HeaderedTextBox.md

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
                title: qsTr("HeaderedTextBox")
                subtitle: qsTr("Header, description, error icon, clear button, and optional characterLimit.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Labeled field")
                qmlSource: "HeaderedTextBox {\n    header: \"Name\"\n    clearButtonVisible: true\n}"
                HeaderedTextBox {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 360
                    header: qsTr("Name")
                    description: qsTr("Displayed on your profile.")
                    placeholderText: qsTr("Enter a name")
                    clearButtonVisible: true
                    characterLimit: 32
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Validation error")
                qmlSource: "HeaderedTextBox { errorMessage: \"Required\" }"
                HeaderedTextBox {
                    id: emailBox
                    Layout.fillWidth: true
                    Layout.maximumWidth: 360
                    header: qsTr("Email")
                    placeholderText: qsTr("name@example.com")
                    clearButtonVisible: true
                    errorMessage: text.indexOf("@") < 0 && text.length > 0
                            ? qsTr("Enter a valid email address.") : ""
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Password")
                qmlSource: "HeaderedTextBox {\n    header: \"Password\"\n    echoMode: TextInput.Password\n}"
                HeaderedTextBox {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 360
                    header: qsTr("Password")
                    description: qsTr("Use at least 8 characters.")
                    placeholderText: qsTr("Password")
                    echoMode: TextInput.Password
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Header placement")
                qmlSource: "HeaderedTextBox {\n    headerPlacement: \"left\"\n}"
                HeaderedTextBox {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 420
                    header: qsTr("Display name")
                    description: qsTr("Shown beside the field when headerPlacement is left.")
                    headerPlacement: "left"
                    placeholderText: qsTr("Alex")
                    clearButtonVisible: true
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

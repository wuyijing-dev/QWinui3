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
                title: qsTr("TitleBar")
                subtitle: qsTr("WinUI TitleBar: Back, PaneToggle, Icon, Title/Subtitle, Content, RightHeader.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("WinUI anatomy")
                qmlSource: "TitleBar {\n    title: \"App\"\n    subtitle: \"Subtitle\"\n    symbol: FluentIcons.Home\n    isBackButtonVisible: true\n    isPaneToggleButtonVisible: true\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 56
                        color: Theme.bgAcrylic
                        border.width: 1
                        border.color: Theme.strokeDivider
                        radius: Theme.cornerControl
                        TitleBar {
                            id: anatomyBar
                            anchors.fill: parent
                            anchors.margins: 1
                            embedded: true
                            searchEnabled: false
                            title: qsTr("Contoso Photos")
                            subtitle: qsTr("Library")
                            symbol: FluentIcons.Home
                            isBackButtonVisible: true
                            isPaneToggleButtonVisible: true
                            onBackRequested: tip.text = qsTr("BackRequested")
                            onPaneToggleRequested: tip.text = qsTr("PaneToggleRequested")

                            Button {
                                text: qsTr("Share")
                                flat: true
                            }
                            Button {
                                text: qsTr("More")
                                flat: true
                            }
                        }
                    }
                    Label {
                        id: tip
                        Layout.fillWidth: true
                        text: qsTr("Interact with Back / Pane toggle — Share/More sit in RightHeader")
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Built-in search Content")
                qmlSource: "TitleBar {\n    searchEnabled: true\n    searchModel: […]\n}"
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    color: Theme.bgAcrylic
                    border.width: 1
                    border.color: Theme.strokeDivider
                    radius: Theme.cornerControl
                    TitleBar {
                        anchors.fill: parent
                        anchors.margins: 1
                        embedded: true
                        title: qsTr("Sample window")
                        subtitle: qsTr("Search is default Content when the Content slot is empty")
                        searchModel: [
                            { title: qsTr("Button"), component: "ButtonPage" },
                            { title: qsTr("Slider"), component: "SliderPage" }
                        ]
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

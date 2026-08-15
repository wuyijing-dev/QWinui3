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
                subtitle: qsTr("Application title bar with optional search. The gallery window hosts TitleBar inside PlatformTitleBar.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Embedded")
                qmlSource: "TitleBar {\n    title: \"App\"\n    embedded: true\n}"
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

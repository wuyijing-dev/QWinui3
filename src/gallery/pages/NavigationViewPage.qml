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
                title: qsTr("NavigationView")
                subtitle: qsTr("Top-level navigation with PaneDisplayMode (Left / LeftCompact / Top) and an optional Back button.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Embedded sample")
                qmlSource: "NavigationView {\n    paneDisplayMode: \"left\"\n    isBackButtonVisible: true\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacing
                        Label { text: qsTr("Pane mode"); color: Theme.textSecondary }
                        ComboBox {
                            id: paneMode
                            model: ["left", "leftCompact", "top"]
                            currentIndex: 0
                            Layout.preferredWidth: 160
                        }
                        CheckBox {
                            id: backVis
                            text: qsTr("Back button")
                            checked: true
                        }
                        CheckBox {
                            id: backEn
                            text: qsTr("Back enabled")
                            checked: true
                            enabled: backVis.checked
                        }
                    }
                    Label {
                        id: navStatus
                        text: qsTr("Ready")
                        color: Theme.textSecondary
                    }
                    NavigationView {
                        id: demoNav
                        Layout.fillWidth: true
                        Layout.preferredHeight: 360
                        headerText: qsTr("Demo")
                        footerText: qsTr("Settings")
                        footerComponent: ""
                        pageModule: "QWinUI3.Gallery"
                        currentKey: "home"
                        paneDisplayMode: paneMode.currentText
                        isBackButtonVisible: backVis.checked
                        isBackEnabled: backEn.checked
                        onBackRequested: navStatus.text = qsTr("Back requested")
                        model: [
                            {
                                type: "item",
                                key: "home",
                                title: qsTr("Home"),
                                icon: "\uE80F",
                                component: "HomePage"
                            },
                            {
                                type: "group",
                                key: "demo",
                                title: qsTr("Samples"),
                                icon: "\uE8F1",
                                children: [
                                    {
                                        title: qsTr("Button"),
                                        icon: "\uE8A7",
                                        component: "ButtonPage"
                                    },
                                    {
                                        title: qsTr("Slider"),
                                        icon: "\uE9E9",
                                        component: "SliderPage"
                                    }
                                ]
                            }
                        ]
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

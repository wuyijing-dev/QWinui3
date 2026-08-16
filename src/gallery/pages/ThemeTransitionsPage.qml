import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ContentThemeTransition + RepositionThemeTransition.
//
// Recipe: docs/animations.md (1.22)

CatalogPage {
    id: page
    title: qsTr("Theme transitions")
    subtitle: qsTr("Content swap + layout reflow. Recipe: docs/animations.md — honors Theme.reducedMotion.")

    property int panelIndex: 0
    property int chipCount: 5

    ControlExample {
        headerText: qsTr("Reduced motion")
        qmlSource: "Theme.reducedMotion // Content snaps; Reposition Behavior off"
        ColumnLayout {
            Layout.fillWidth: true
            Switch {
                text: qsTr("Theme.reducedMotion")
                checked: Theme.reducedMotion
                onToggled: Theme.reducedMotion = checked
            }
        }
    }

    ControlExample {
        headerText: qsTr("ContentThemeTransition")
        qmlSource: "ContentThemeTransition {\n    contentKey: pageId\n    …\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            RowLayout {
                spacing: Theme.spacing
                AccentButton {
                    text: qsTr("Next panel")
                    onClicked: page.panelIndex = (page.panelIndex + 1) % 3
                }
                Label {
                    text: qsTr("Panel %1").arg(page.panelIndex + 1)
                    color: Theme.textSecondary
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                radius: Theme.cornerCard
                color: Theme.bgCard
                border.width: 1
                border.color: Theme.strokeCard
                clip: true

                ContentThemeTransition {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingLoose
                    contentKey: page.panelIndex

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: page.panelIndex === 0 ? FluentIcons.Home
                                : (page.panelIndex === 1 ? FluentIcons.Settings : FluentIcons.Mail)
                            font.family: Theme.fontFamilyIcon
                            font.pixelSize: 28
                            color: Theme.accent
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: page.panelIndex === 0 ? qsTr("Home content")
                                : (page.panelIndex === 1 ? qsTr("Settings content")
                                                         : qsTr("Mail content"))
                            color: Theme.textPrimary
                        }
                    }
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("RepositionThemeTransition")
        qmlSource: "Flow {\n    RepositionThemeTransition { … }\n}"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose

            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Add chip")
                    onClicked: page.chipCount = Math.min(12, page.chipCount + 1)
                }
                Button {
                    text: qsTr("Remove chip")
                    onClicked: page.chipCount = Math.max(1, page.chipCount - 1)
                }
            }

            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing
                Repeater {
                    model: page.chipCount
                    RepositionThemeTransition {
                        required property int index
                        width: 72
                        height: 40
                        Rectangle {
                            anchors.fill: parent
                            radius: Theme.cornerControl
                            color: Theme.fillSubtle
                            border.width: 1
                            border.color: Theme.strokeControl
                            Label {
                                anchors.centerIn: parent
                                text: qsTr(" #%1").arg(index + 1)
                                color: Theme.textPrimary
                            }
                        }
                    }
                }
            }
        }
    }
}

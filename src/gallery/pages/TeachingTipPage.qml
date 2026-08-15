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
                title: qsTr("TeachingTip")
                subtitle: qsTr("Contextual tip with symbol, ElevatedChrome, and AccentButton action.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple TeachingTip")
                qmlSource: "TeachingTip {\n    symbol: FluentIcons.Info\n    target: tipTarget\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    Button {
                        id: tipTarget
                        text: qsTr("Show teaching tip")
                        onClicked: tip.isOpen = true
                    }

                    TeachingTip {
                        id: tip
                        parent: tipTarget.parent
                        target: tipTarget
                        preferredPlacement: Qt.AlignTop
                        symbol: FluentIcons.Info
                        title: qsTr("Quick tip")
                        subtitle: qsTr("TeachingTip can place above, below, left, or right of the target.")
                        actionText: qsTr("Got it")
                        onActionClicked: tipTarget.text = qsTr("Tip dismissed")

                        Rectangle {
                            width: parent ? parent.width : 280
                            height: 80
                            radius: Theme.cornerControl
                            gradient: Gradient {
                                GradientStop { position: 0; color: Theme.accent }
                                GradientStop { position: 1; color: Theme.accentDark1 }
                            }
                            Label {
                                anchors.centerIn: parent
                                text: qsTr("Hero content")
                                color: Theme.textOnAccent
                                font.weight: Theme.fontWeightSemiBold
                            }
                        }
                    }

                    RowLayout {
                        spacing: Theme.spacing
                        Button {
                            text: qsTr("Below")
                            onClicked: {
                                tip.preferredPlacement = Qt.AlignBottom
                                tip.isOpen = true
                            }
                        }
                        Button {
                            text: qsTr("Right")
                            onClicked: {
                                tip.preferredPlacement = Qt.AlignRight
                                tip.isOpen = true
                            }
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

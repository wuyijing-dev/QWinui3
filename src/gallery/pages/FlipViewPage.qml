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
                title: qsTr("FlipView")
                subtitle: qsTr("Swipeable pages with PipsPager, selectedIndex, and wrap.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Pages")
                qmlSource: "FlipView {\n    buttonVisibility: \"onHover\"\n    wrap: true\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    RowLayout {
                        Label { text: qsTr("Buttons"); color: Theme.textSecondary }
                        ComboBox {
                            id: btnVis
                            model: ["onHover", "always", "hidden"]
                            currentIndex: 0
                            Layout.preferredWidth: 140
                        }
                        CheckBox {
                            id: wrapBox
                            text: qsTr("Wrap")
                        }
                        CheckBox {
                            id: indBox
                            text: qsTr("Indicator")
                            checked: true
                        }
                    }
                    FlipView {
                        id: flip
                        Layout.fillWidth: true
                        Layout.preferredHeight: 180
                        buttonVisibility: btnVis.currentText
                        wrap: wrapBox.checked
                        isIndicatorVisible: indBox.checked
                        onSelectionChanged: function (index) {
                            // keep label binding live
                        }
                        Rectangle {
                            color: Theme.systemAttentionBg
                            Label {
                                anchors.centerIn: parent
                                text: qsTr("Page 1")
                                color: Theme.textPrimary
                            }
                        }
                        Rectangle {
                            color: Theme.systemSuccessBg
                            Label {
                                anchors.centerIn: parent
                                text: qsTr("Page 2")
                                color: Theme.textPrimary
                            }
                        }
                        Rectangle {
                            color: Theme.systemCautionBg
                            Label {
                                anchors.centerIn: parent
                                text: qsTr("Page 3")
                                color: Theme.textPrimary
                            }
                        }
                    }
                    Label {
                        text: qsTr("selectedIndex: %1 / %2").arg(flip.selectedIndex + 1).arg(flip.count)
                        color: Theme.textSecondary
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

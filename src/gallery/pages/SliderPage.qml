import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Slider.
//
// A control that lets the user select from a range of values by moving a thumb. API: docs/components/Slider.md

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
                title: qsTr("Slider")
                subtitle: qsTr("A control that lets the user select from a range of values by moving a thumb.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple Slider")
                qmlSource: "Slider {\n    from: 0\n    to: 100\n    value: 40\n}\nSlider {\n    from: 0\n    to: 100\n    value: 70\n    enabled: false\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    Slider {
                        Layout.preferredWidth: 320
                        from: 0
                        to: 100
                        value: 40
                    }
                    Slider {
                        Layout.preferredWidth: 320
                        from: 0
                        to: 100
                        value: 70
                        enabled: false
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

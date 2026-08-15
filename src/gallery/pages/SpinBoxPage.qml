import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

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
                title: qsTr("SpinBox")
                subtitle: qsTr("A control for selecting a numeric value within a range.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple SpinBox")
                qmlSource: "SpinBox {\n    from: 0\n    to: 100\n    value: 42\n}\nSpinBox {\n    from: 0\n    to: 10\n    value: 3\n    enabled: false\n}"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose

                    SpinBox {
                        from: 0
                        to: 100
                        value: 42
                    }
                    SpinBox {
                        from: 0
                        to: 10
                        value: 3
                        enabled: false
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}

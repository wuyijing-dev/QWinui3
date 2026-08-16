import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — StackView.
//
// A stack-based navigation container with animated transitions. API: docs/components/StackView.md

CatalogPage {
    title: qsTr("StackView")
    subtitle: qsTr("A stack-based navigation container with animated transitions.")

    Component {
        id: pageA
        Rectangle {
            color: Theme.bgCard
            Label {
                anchors.centerIn: parent
                text: qsTr("Page A")
                color: Theme.textPrimary
            }
        }
    }

    Component {
        id: pageB
        Rectangle {
            color: Theme.systemAttentionBg
            Label {
                anchors.centerIn: parent
                text: qsTr("Page B")
                color: Theme.textPrimary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Push and pop")
        qmlSource: "StackView {\n    initialItem: page1\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            RowLayout {
                spacing: Theme.spacing
                Button {
                    text: qsTr("Push")
                    highlighted: true
                    onClicked: stack.push(pageB)
                }
                Button {
                    text: qsTr("Pop")
                    enabled: stack.depth > 1
                    onClicked: stack.pop()
                }
                Label {
                    text: qsTr("Depth: %1").arg(stack.depth)
                    color: Theme.textSecondary
                }
            }
            StackView {
                id: stack
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                initialItem: pageA
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// Dashboard chrome around a chart: title, subtitle, trailing actions, soft entrance.
T.Control {
    id: root

    property string title: ""
    property string subtitle: ""
    property string footer: ""
    property bool animated: true
    property bool elevated: false
    property bool bordered: true
    property alias headerActions: actionsRow.data
    default property alias content: body.data

    implicitWidth: 320
    implicitHeight: 240
    padding: 12
    opacity: animated && !Theme.reducedMotion ? 0 : 1
    scale: animated && !Theme.reducedMotion ? 0.97 : 1

    Component.onCompleted: {
        opacity = 1
        scale = 1
    }

    Behavior on opacity {
        enabled: root.animated && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }
    Behavior on scale {
        enabled: root.animated && !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingEnter
        }
    }

    contentItem: ColumnLayout {
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: root.title.length > 0 || root.subtitle.length > 0 || actionsRow.children.length > 0

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    visible: root.title.length > 0
                    Layout.fillWidth: true
                    text: root.title
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    elide: Text.ElideRight
                }
                Text {
                    visible: root.subtitle.length > 0
                    Layout.fillWidth: true
                    text: root.subtitle
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                    elide: Text.ElideRight
                }
            }

            Row {
                id: actionsRow
                spacing: 4
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
        }

        Item {
            id: body
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Text {
            visible: root.footer.length > 0
            Layout.fillWidth: true
            text: root.footer
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            color: Theme.textSecondary
            elide: Text.ElideRight
        }
    }

    background: Rectangle {
        radius: Theme.cornerCard
        color: root.elevated ? Theme.bgCardElevated : Theme.bgCard
        border.width: root.bordered ? 1 : 0
        border.color: Theme.strokeCard
    }
}

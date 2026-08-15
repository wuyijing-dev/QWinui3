import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Pane {
    id: root

    property string title: ""
    property string description: ""
    property string headerIcon: ""
    property alias action: actionSlot.data
    property bool interactive: false
    property bool showChevron: interactive
    signal clicked()

    padding: 16
    implicitWidth: 420
    implicitHeight: Math.max(64, contentItem.implicitHeight + topPadding + bottomPadding)
    hoverEnabled: interactive
    Accessible.role: interactive ? Accessible.Button : Accessible.Grouping
    Accessible.name: title

    background: Rectangle {
        radius: Theme.cornerCard
        color: {
            if (root.interactive && root.hovered)
                return Theme.fillSubtle
            return Theme.bgCard
        }
        border.width: 1
        border.color: Theme.strokeCard

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.22 : 0.08
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 2
            blurMax: 12
            autoPaddingEnabled: true
        }
    }

    contentItem: RowLayout {
        spacing: Theme.spacingLoose

        Text {
            visible: root.headerIcon.length > 0
            text: root.headerIcon
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 20
            color: Theme.accent
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            Text {
                visible: root.description.length > 0
                text: root.description
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }

        Item {
            id: actionSlot
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }

        Text {
            visible: root.showChevron
            Layout.alignment: Qt.AlignVCenter
            text: "\uE76C"
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 12
            color: Theme.textSecondary
        }
    }

    TapHandler {
        enabled: root.interactive
        onTapped: root.clicked()
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Control {
    id: control

    property string title: ""
    property string subtitle: ""
    property string headerIcon: ""
    property alias footer: footerSlot.data
    property bool isClickable: false
    default property alias contentData: body.data
    signal clicked()

    padding: 16
    implicitWidth: 320
    implicitHeight: Math.max(80, contentItem.implicitHeight + topPadding + bottomPadding)
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    hoverEnabled: isClickable

    background: Rectangle {
        radius: Theme.cornerCard
        color: {
            if (control.isClickable && control.hovered)
                return Theme.fillSubtle
            return Theme.bgCardElevated
        }
        border.width: 1
        border.color: Theme.strokeCard

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.28 : 0.12
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 4
            blurMax: 18
            autoPaddingEnabled: true
        }

        scale: control.isClickable && control._pressed ? 0.99 : 1
    }

    property bool _pressed: false

    TapHandler {
        enabled: control.isClickable
        onPressedChanged: control._pressed = pressed
        onTapped: control.clicked()
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacing

        RowLayout {
            visible: control.title.length > 0 || control.headerIcon.length > 0
            Layout.fillWidth: true
            spacing: Theme.spacing

            Text {
                visible: control.headerIcon.length > 0
                text: control.headerIcon
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 20
                color: Theme.accent
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    visible: control.title.length > 0
                    text: control.title
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Text {
                    visible: control.subtitle.length > 0
                    text: control.subtitle
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }
            }
        }

        Rectangle {
            visible: control.title.length > 0 || control.headerIcon.length > 0
            Layout.fillWidth: true
            height: 1
            color: Theme.strokeDivider
        }

        Item {
            id: body
            Layout.fillWidth: true
            implicitHeight: childrenRect.height
            implicitWidth: width > 0 ? width : childrenRect.width

            onWidthChanged: Qt.callLater(fitChildren)
            onChildrenChanged: Qt.callLater(fitChildren)

            function fitChildren() {
                for (var i = 0; i < children.length; ++i) {
                    var ch = children[i]
                    if (!ch)
                        continue
                    if (ch.anchors && (ch.anchors.fill || ch.anchors.left || ch.anchors.right))
                        continue
                    ch.width = width
                }
            }
        }

        Rectangle {
            visible: footerSlot.children.length > 0
            Layout.fillWidth: true
            height: 1
            color: Theme.strokeDivider
        }

        Item {
            id: footerSlot
            visible: children.length > 0
            Layout.fillWidth: true
            implicitHeight: childrenRect.height
            implicitWidth: width > 0 ? width : childrenRect.width
        }
    }
}

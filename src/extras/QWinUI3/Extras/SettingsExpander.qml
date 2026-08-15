import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Control {
    id: control

    property string title: ""
    property string description: ""
    property string headerIcon: ""
    property bool expanded: false
    property alias isExpanded: control.expanded
    // WinUI ExpandDirection: down | up
    property string expandDirection: "down"
    default property alias contentData: contentHost.data

    readonly property bool _expandUp: expandDirection === "up"

    implicitWidth: Math.max(420, headerRow.implicitWidth + leftPadding + rightPadding)
    implicitHeight: topPadding + bottomPadding + headerItem.implicitHeight
                    + (expanded ? contentHost.implicitHeight + 8 + 1 : 0)
    padding: 12
    leftPadding: 16
    rightPadding: 16
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    clip: true

    Behavior on implicitHeight {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: control.expanded ? Theme.easingEnter : Theme.easingExit
        }
    }

    background: Rectangle {
        radius: Theme.cornerCard
        color: Theme.bgCard
        border.width: 1
        border.color: Theme.strokeCard

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.16 : 0.07
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 2
            blurMax: 12
            autoPaddingEnabled: true
        }
    }

    contentItem: GridLayout {
        columns: 1
        rows: 3
        rowSpacing: 0
        columnSpacing: 0

        Item {
            id: headerItem
            Layout.row: control._expandUp ? 2 : 0
            Layout.column: 0
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
            implicitHeight: Math.max(control.description.length > 0 ? 64 : 48,
                                     headerRow.implicitHeight + 16)

            RowLayout {
                id: headerRow
                anchors.fill: parent
                spacing: Theme.spacingLoose

                Text {
                    visible: control.headerIcon.length > 0
                    text: control.headerIcon
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 20
                    color: Theme.accent
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2
                    Text {
                        text: control.title
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Text {
                        visible: control.description.length > 0
                        text: control.description
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textSecondary
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                }

                Text {
                    text: "\uE70D"
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 12
                    color: Theme.textSecondary
                    Layout.alignment: Qt.AlignVCenter
                    rotation: {
                        if (control._expandUp)
                            return control.expanded ? 0 : 180
                        return control.expanded ? 180 : 0
                    }
                    Behavior on rotation {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.duration(Theme.motionNormal)
                            easing.type: Theme.easingStandard
                        }
                    }
                }
            }

            TapHandler {
                onTapped: control.expanded = !control.expanded
            }

            HoverHandler { id: headerHover }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -4
                radius: Theme.cornerControl
                color: headerHover.hovered ? Theme.fillSubtle : "transparent"
                z: -1
                Behavior on color {
                    enabled: !Theme.reducedMotion
                    ColorAnimation {
                        duration: Theme.duration(Theme.motionFast)
                    }
                }
            }
        }

        Rectangle {
            visible: control.expanded
            Layout.row: 1
            Layout.column: 0
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.strokeDivider
            opacity: 0.85
        }

        Item {
            id: contentHost
            visible: control.expanded
            Layout.row: control._expandUp ? 0 : 2
            Layout.column: 0
            Layout.fillWidth: true
            Layout.topMargin: control._expandUp ? 0 : 8
            Layout.bottomMargin: control._expandUp ? 8 : 0
            implicitHeight: childrenRect.height
            implicitWidth: childrenRect.width
            opacity: control.expanded ? 1 : 0
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                }
            }
        }
    }
}

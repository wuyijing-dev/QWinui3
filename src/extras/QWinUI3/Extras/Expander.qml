import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

T.Control {
    id: root

    property string title: ""
    property string subtitle: ""
    property bool expanded: false
    property alias isExpanded: root.expanded
    property var headerIcon: ""
    // WinUI ExpandDirection: down | up
    property string expandDirection: "down"
    default property alias contentData: contentHost.data

    signal expanding()
    signal collapsing()

    readonly property string effectiveHeaderIcon: IconSource.resolve(headerIcon, "")
    readonly property bool _expandUp: expandDirection === "up"

    onExpandedChanged: {
        if (expanded)
            expanding()
        else
            collapsing()
    }

    implicitWidth: Math.max(280, headerBtn.implicitWidth + leftPadding + rightPadding)
    // Include control padding when collapsed so the header is not cut off.
    implicitHeight: topPadding + bottomPadding + headerBtn.implicitHeight
                    + (expanded ? contentHost.implicitHeight + 8 : 0)
    padding: 12
    leftPadding: 16
    rightPadding: 16
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    clip: false
    Accessible.role: Accessible.Button
    Accessible.name: title
    Accessible.checkable: true
    Accessible.checked: expanded

    Behavior on implicitHeight {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: root.expanded ? Theme.easingEnter : Theme.easingExit
        }
    }

    background: ElevatedChrome {
        color: Theme.bgCard
        radius: Theme.cornerCard
        borderColor: Theme.strokeCard
        borderWidth: 1
        elevation: 2
        shadowOpacity: Theme.dark ? 0.16 : 0.07
    }

    contentItem: GridLayout {
        columns: 1
        rows: 2
        rowSpacing: 0
        columnSpacing: 0

        AbstractButton {
            id: headerBtn
            Layout.row: root._expandUp ? 1 : 0
            Layout.column: 0
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
            implicitHeight: Math.max(root.subtitle.length > 0 ? 64 : 48,
                                     headerContent.implicitHeight + 16)
            hoverEnabled: true
            focusPolicy: Qt.StrongFocus
            Accessible.name: root.title
            onClicked: root.expanded = !root.expanded
            scale: down && !Theme.reducedMotion ? 0.995 : 1
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }

            contentItem: RowLayout {
                id: headerContent
                spacing: Theme.spacing

                Text {
                    visible: root.effectiveHeaderIcon.length > 0
                    text: root.effectiveHeaderIcon
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 16
                    color: root.enabled ? Theme.accent : Theme.textDisabled
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    Text {
                        text: root.title
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        font.weight: Theme.fontWeightSemiBold
                        color: root.enabled ? Theme.textPrimary : Theme.textDisabled
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        visible: root.subtitle.length > 0
                        text: root.subtitle
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                        color: root.enabled ? Theme.textSecondary : Theme.textDisabled
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                Text {
                    text: "\uE70D"
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 10
                    color: root.enabled ? Theme.textSecondary : Theme.textDisabled
                    // Up direction: chevron points up when collapsed (content will open above)
                    rotation: {
                        if (root._expandUp)
                            return root.expanded ? 0 : 180
                        return root.expanded ? 180 : 0
                    }
                    Layout.alignment: Qt.AlignVCenter
                    Behavior on rotation {
                        enabled: !Theme.reducedMotion
                        NumberAnimation {
                            duration: Theme.duration(Theme.motionNormal)
                            easing.type: Theme.easingStandard
                        }
                    }
                }
            }

            background: Item {
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -4
                    radius: Theme.cornerControl
                    color: {
                        if (!headerBtn.enabled)
                            return "transparent"
                        if (headerBtn.down)
                            return Theme.fillSubtleTertiary
                        if (headerBtn.hovered || headerBtn.visualFocus)
                            return Theme.fillSubtle
                        return "transparent"
                    }
                    Behavior on color {
                        enabled: !Theme.reducedMotion
                        ColorAnimation {
                            duration: Theme.duration(Theme.motionFast)
                            easing.type: Theme.easingStandard
                        }
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -6
                    radius: Theme.cornerControl + 1
                    color: "transparent"
                    border.width: headerBtn.visualFocus ? Theme.strokeFocusOuter : 0
                    border.color: Theme.accent
                    visible: headerBtn.visualFocus
                }
            }
        }

        ColumnLayout {
            id: contentHost
            Layout.row: root._expandUp ? 0 : 1
            Layout.column: 0
            Layout.fillWidth: true
            clip: true
            visible: root.expanded || opacity > 0.01
            opacity: root.expanded ? 1 : 0
            Layout.topMargin: root._expandUp ? (root.expanded ? 4 : 0) : 4
            Layout.bottomMargin: root._expandUp ? 4 : (root.expanded ? 4 : 0)
            spacing: Theme.spacing
            transformOrigin: root._expandUp ? Item.Bottom : Item.Top
            scale: root.expanded || Theme.reducedMotion ? 1 : 0.98

            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingEnter
                }
            }
        }
    }
}

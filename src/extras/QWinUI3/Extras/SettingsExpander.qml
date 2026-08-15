import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// SettingsExpander — Expandable settings group.
//
//   SettingsExpander {
//       title: qsTr("Advanced")
//       SettingsCard { title: qsTr("Option") }
//   }

T.Control {
    id: control

    // Primary title text
    property string title: ""
    // Supporting description text
    property string description: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Header icon glyph
    property var headerIcon: ""
    // Expanded state
    property bool expanded: false
    // Alias of expanded
    property alias isExpanded: control.expanded
    // WinUI ExpandDirection: down | up
    property string expandDirection: "down"
    // Custom action slot
    property alias action: actionSlot.data
    // Default children / content slot
    default property alias contentData: contentHost.data

    // True while expanding
    signal expanding()
    // True while collapsing
    signal collapsing()

    // Resolved header icon
    readonly property string effectiveHeaderIcon: {
        var primary = (symbol !== undefined && symbol !== null && String(symbol).length)
                      ? symbol : headerIcon
        return IconSource.resolve(primary, iconGlyph)
    }
    readonly property bool _expandUp: expandDirection === "up"

    onExpandedChanged: {
        if (expanded)
            expanding()
        else
            collapsing()
    }

    implicitWidth: Math.max(420, headerRow.implicitWidth + leftPadding + rightPadding)
    implicitHeight: topPadding + bottomPadding + headerItem.implicitHeight
                    + (expanded ? contentHost.implicitHeight + 8 + 1 : 0)
    padding: 12
    leftPadding: 16
    rightPadding: 16
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    clip: false
    focusPolicy: Qt.StrongFocus
    activeFocusOnTab: true
    Accessible.role: Accessible.Button
    Accessible.name: title
    Accessible.description: description
    Accessible.checkable: true
    Accessible.checked: expanded
    Keys.onReturnPressed: expanded = !expanded
    Keys.onEnterPressed: expanded = !expanded
    Keys.onSpacePressed: expanded = !expanded

    Behavior on implicitHeight {
        enabled: !Theme.reducedMotion
        NumberAnimation {
            duration: Theme.duration(Theme.motionSlow)
            easing.type: control.expanded ? Theme.easingEnter : Theme.easingExit
        }
    }

    background: ElevatedChrome {
        color: Theme.bgCard
        radius: Theme.cornerCard
        borderWidth: control.activeFocus ? 2 : 1
        borderColor: control.activeFocus ? Theme.accent : Theme.strokeCard
        elevation: 2
        shadowOpacity: Theme.dark ? 0.16 : 0.07

        Behavior on borderColor {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
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
                    visible: control.effectiveHeaderIcon.length > 0
                    text: control.effectiveHeaderIcon
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

                Item {
                    id: actionSlot
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: childrenRect.width
                    implicitHeight: childrenRect.height
                }

                Text {
                    text: FluentIcons.ChevronDown
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
            clip: true
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

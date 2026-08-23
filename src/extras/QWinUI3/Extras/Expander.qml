import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// Expander — Collapsible header with expandable content.
//
//   Expander {
//       title: qsTr("Details")
//       Label { text: qsTr("Body") }
//   }
//
//   // --- API ---
//   // signals: onExpanding, onCollapsing
//   // header: string title/subtitle OR custom headerContent slot (WinUI Header)
//
// @notes
//   Header + expandable content; expanded / expand/collapse.
//   headerContent replaces the default title column when it has children.

T.Control {
    id: root

    Layout.fillWidth: true

    // Primary title text
    property string title: ""
    // Secondary subtitle text
    property string subtitle: ""
    // Expanded state
    property bool expanded: false
    // Alias of expanded
    property alias isExpanded: root.expanded
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Header icon glyph
    property var headerIcon: ""
    // WinUI ExpandDirection: down | up
    property string expandDirection: "down"
    // WinUI Header — custom header content (replaces title/subtitle when set)
    property alias headerContent: headerSlot.data
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
    readonly property bool _hasCustomHeader: headerSlot.children.length > 0

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
            implicitHeight: Math.max(root._hasCustomHeader ? 48 : (root.subtitle.length > 0 ? 64 : 48),
                                     headerRow.implicitHeight + 16)
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
                id: headerRow
                spacing: Theme.spacing

                Text {
                    visible: root.effectiveHeaderIcon.length > 0
                    text: root.effectiveHeaderIcon
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 16
                    color: root.enabled ? Theme.accent : Theme.textDisabled
                    Layout.alignment: Qt.AlignVCenter
                }

                Item {
                    id: headerSlot
                    visible: root._hasCustomHeader
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: childrenRect.height
                    implicitWidth: childrenRect.width
                    implicitHeight: Math.max(24, childrenRect.height)
                    onWidthChanged: {
                        for (var i = 0; i < children.length; ++i) {
                            if (children[i] && children[i].width !== undefined)
                                children[i].width = width
                        }
                    }
                }

                ColumnLayout {
                    visible: !root._hasCustomHeader
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    Text {
                        text: root.title
                        font.pixelSize: Theme.fontBody
                        font.weight: Theme.fontWeightSemiBold
                        color: root.enabled ? Theme.textPrimary : Theme.textDisabled
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        visible: root.subtitle.length > 0
                        text: root.subtitle
                        font.pixelSize: Theme.fontCaption
                        color: root.enabled ? Theme.textSecondary : Theme.textDisabled
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        Layout.fillWidth: true
                    }
                }

                Text {
                    text: FluentIcons.ChevronDown
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 10
                    color: root.enabled ? Theme.textSecondary : Theme.textDisabled
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

                FocusStroke {
                    anchors.fill: parent
                    anchors.margins: -6
                    show: headerBtn.visualFocus
                    frameRadius: Theme.cornerControl
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

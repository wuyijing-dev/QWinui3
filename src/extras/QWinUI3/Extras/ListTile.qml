import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// ListTile — List row: leading, title, subtitle, trailing.
//
//   ListTile {
//       title: qsTr("Item")
//       subtitle: qsTr("Detail")
//       symbol: FluentIcons.Document
//   }
//
// @notes
//   List row tile with leading symbol and trailing slot.

T.ItemDelegate {
    id: control

    Layout.fillWidth: true

    // Primary title text
    property string title: text
    // Secondary subtitle text
    property string subtitle: ""
    // Supporting description text
    property alias description: control.subtitle
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Fluent glyph drawn in the button
    property string glyph: ""
    // Leading content slot
    property alias leading: leadingSlot.data
    // Trailing slot
    default property alias trailing: trailingSlot.data
    // Show trailing chevron
    property bool showChevron: false
    // Selected state
    property bool isSelected: false
    // Row density: compact | normal | spacious | "" (follow Theme.density) — 2.67 A3
    property string density: ""
    // Compat alias
    property alias tileDensity: control.density
    // Leading preset: "icon" (default) | "avatar" | "checkbox" | "none" — 2.67 A3
    property string leadingPreset: "icon"
    // Avatar initials / PersonPicture displayName when leadingPreset is avatar
    property string avatarName: ""
    // Avatar image source (optional) — aliases PersonPicture.imageSource
    property url avatarSource: ""
    property alias profilePicture: control.avatarSource

    readonly property string _densityMode: {
        var d = String(density || "").toLowerCase()
        if (d === "compact" || d === "spacious" || d === "normal")
            return d
        if (Theme.density === "compact")
            return "compact"
        if (Theme.density === "spacious")
            return "spacious"
        return "normal"
    }
    readonly property real _rowPadV: {
        switch (_densityMode) {
        case "compact": return 6
        case "spacious": return 16
        default: return 12
        }
    }
    readonly property real _rowMinHeight: {
        switch (_densityMode) {
        case "compact": return Theme.navItemHeight - 4
        case "spacious": return Theme.navItemHeight + 16
        default: return Theme.navItemHeight + 8
        }
    }
    readonly property real _leadingSize: _densityMode === "compact" ? 32 : (_densityMode === "spacious" ? 48 : 40)
    readonly property string _leadingMode: {
        var p = String(leadingPreset || "icon").toLowerCase()
        if (p === "avatar" || p === "checkbox" || p === "none")
            return p
        return "icon"
    }

    // Resolved glyph string
    readonly property string effectiveGlyph: IconSource.resolve(symbol, glyph)

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    padding: control._rowPadV
    leftPadding: 16
    rightPadding: 12
    spacing: Theme.spacingLoose
    implicitWidth: 320
    implicitHeight: Math.max(control._rowMinHeight,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    font.pixelSize: Theme.fontBody

    PointerCursor { shape: Qt.PointingHandCursor }

    Accessible.role: Accessible.ListItem
    Accessible.name: title.length ? title : qsTr("List item")
    Accessible.description: subtitle
    Accessible.selectable: true
    Accessible.selected: isSelected || checked
    Accessible.checkable: checkable
    Accessible.checked: checked
    Accessible.onPressAction: if (enabled) clicked()

    scale: down && !Theme.reducedMotion ? 0.995 : 1
    Behavior on scale {
        enabled: !Theme.reducedMotion && (control.down || control.hovered)
        NumberAnimation {
            duration: Theme.duration(Theme.motionFast)
            easing.type: Theme.easingStandard
        }
    }

    contentItem: RowLayout {
        spacing: control.spacing

        Item {
            id: leadingSlot
            visible: children.length > 0
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }

        CheckBox {
            visible: control._leadingMode === "checkbox" && leadingSlot.children.length === 0
            Layout.alignment: Qt.AlignVCenter
            checked: control.checked
            onToggled: control.checked = checked
        }

        PersonPicture {
            visible: control._leadingMode === "avatar" && leadingSlot.children.length === 0
            Layout.preferredWidth: control._leadingSize
            Layout.preferredHeight: control._leadingSize
            Layout.alignment: Qt.AlignVCenter
            imageSource: control.avatarSource
            displayName: control.avatarName.length ? control.avatarName : control.title
            size: control._leadingSize
        }

        Rectangle {
            visible: control._leadingMode === "icon"
                     && control.effectiveGlyph.length > 0
                     && leadingSlot.children.length === 0
            Layout.preferredWidth: control._leadingSize
            Layout.preferredHeight: control._leadingSize
            Layout.alignment: Qt.AlignVCenter
            radius: Theme.cornerControl
            color: Theme.fillSubtle

            FontIcon {
                anchors.centerIn: parent
                glyph: control.effectiveGlyph
                fontSize: control._densityMode === "compact" ? 14 : 16
                selected: control.isSelected || control.checked
                iconColor: Theme.accent
                microMotionEnabled: false
                enabled: control.enabled
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            Text {
                Layout.fillWidth: true
                text: control.title
                font.family: control.font.family
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: control.enabled ? Theme.textPrimary : Theme.textDisabled
                elide: Text.ElideRight
            }
            Text {
                visible: control.subtitle.length > 0
                Layout.fillWidth: true
                text: control.subtitle
                font.family: control.font.family
                font.pixelSize: Theme.fontCaption
                color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 3
            }
        }

        Item {
            id: trailingSlot
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }

        FontIcon {
            visible: control.showChevron
            Layout.alignment: Qt.AlignVCenter
            glyph: FluentIcons.ChevronRight
            fontSize: 12
            iconColor: Theme.textSecondary
            microMotionEnabled: false
        }
    }

    background: Item {
        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            color: {
                if (!control.enabled)
                    return "transparent"
                if (control.isSelected || control.checked)
                    return Theme.fillSubtle
                if (control.down)
                    return Theme.fillSubtleTertiary
                if (control.hovered || control.highlighted)
                    return Theme.fillSubtleSecondary
                return "transparent"
            }
            border.width: 0
            border.color: "transparent"

            Behavior on color {
                enabled: !Theme.reducedMotion
                         && (control.hovered || control.down || control.isSelected
                             || control.checked || control.highlighted)
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
        FocusStroke {
            anchors.fill: parent
            show: control.visualFocus
            frameRadius: Theme.cornerControl
        }
        Rectangle {
            visible: control.isSelected || control.checked
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            width: 3
            height: Math.min(parent.height - 16, 24)
            radius: 1.5
            color: Theme.accent
        }
    }
}

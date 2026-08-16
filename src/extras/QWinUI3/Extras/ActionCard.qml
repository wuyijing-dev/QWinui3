import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ActionCard — Clickable card with symbol, title, description, and chevron.
//
//   ActionCard {
//       title: qsTr("Accounts")
//       description: qsTr("Manage profiles")
//       onClicked: open()
//   }
//
//   // --- API ---
//   // inherits AbstractButton (+ Qt Quick Controls base API)
//
// @notes
//   Clickable settings-style card with chevron; onClicked for navigation.

T.AbstractButton {
    id: control

    Layout.fillWidth: true

    // Primary title text
    property string title: text
    // Supporting description text
    property string description: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Fluent glyph drawn in the button
    property string glyph: ""
    // Glyph color
    property color glyphColor: Theme.accent
    // Glyph plate background
    property color glyphBackground: Theme.fillSubtle
    // Show trailing chevron
    property bool showChevron: true
    // Show avatar badge
    property bool badgeVisible: false
    // Numeric badge value (-1 hides count)
    property int badgeValue: 0
    // Badge caption
    property string badgeText: ""
    // Badge severity
    property int badgeSeverity: 0

    // Resolved glyph string
    readonly property string effectiveGlyph: {
        var g = IconSource.resolve(symbol, glyph)
        return g.length ? g : FluentIcons.Document
    }

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    implicitWidth: 280
    implicitHeight: Math.max(88, contentItem.implicitHeight + topPadding + bottomPadding)
    padding: 16
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.Button
    Accessible.name: title.length ? title : qsTr("Action")
    Accessible.description: description
    Accessible.onPressAction: if (enabled) clicked()

    // Hover chrome without pressed — avoids hover↔pressed fighting on click release
    readonly property bool _hovering: enabled && hovered && !down
    readonly property bool _pressing: enabled && down

    contentItem: RowLayout {
        spacing: Theme.spacingLoose

        Item {
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors.fill: parent
                radius: Theme.cornerControl
                color: control.glyphBackground
                scale: control._hovering && !Theme.reducedMotion ? 1.04 : 1
                Behavior on scale {
                    enabled: !Theme.reducedMotion && !control._pressing
                    NumberAnimation {
                        duration: Theme.duration(Theme.motionFast)
                        easing.type: Theme.easingStandard
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: control.effectiveGlyph
                    font.family: Theme.fontFamilyIcon
                    font.pixelSize: 22
                    color: control.enabled ? control.glyphColor : Theme.textDisabled
                }
            }

            InfoBadge {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: -4
                visible: control.badgeVisible
                value: control.badgeValue
                text: control.badgeText
                severity: control.badgeSeverity
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 4

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
                visible: control.description.length > 0
                Layout.fillWidth: true
                text: control.description
                font.family: control.font.family
                font.pixelSize: Theme.fontCaption
                color: control.enabled ? Theme.textSecondary : Theme.textDisabled
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 3
            }
        }

        Text {
            visible: control.showChevron
            Layout.alignment: Qt.AlignVCenter
            text: FluentIcons.ChevronRight
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 12
            color: Theme.textSecondary
            opacity: control.enabled ? (control._hovering ? 1 : 0.85) : 0.4
            // Avoid translating during press — reduces perceived flicker with color change
            x: control._hovering && !Theme.reducedMotion ? 2 : 0
            Behavior on x {
                enabled: !Theme.reducedMotion && !control._pressing
                NumberAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
            Behavior on opacity {
                enabled: !Theme.reducedMotion && !control._pressing
                NumberAnimation { duration: Theme.duration(Theme.motionFast) }
            }
        }
    }

    background: ElevatedChrome {
        // Pressed: immediate fill. Hover: elevated card. Idle: base card.
        color: {
            if (!control.enabled)
                return Theme.bgCard
            if (control._pressing)
                return Theme.fillSubtle
            if (control._hovering)
                return Theme.bgCardElevated
            return Theme.bgCard
        }
        radius: Theme.cornerCard
        borderWidth: control.visualFocus ? 2 : 1
        borderColor: control.visualFocus ? Theme.focusOuter : Theme.strokeCard
        // Keep elevation stable while pressing so MultiEffect doesn't rebuild mid-click
        elevation: control._hovering ? 4 : 2
        shadowOpacity: control._hovering ? (Theme.dark ? 0.24 : 0.11) : (Theme.dark ? 0.16 : 0.07)
        // No press scale — color+scale together reads as flicker on click
        scale: 1

        Behavior on color {
            // Skip animation while pressed so release lands on hover without a flash through idle
            enabled: !Theme.reducedMotion && !control._pressing
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
    }
}
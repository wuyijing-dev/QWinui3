import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QWinUI3.Theme

// ContentCard — Surface card with title, subtitle, symbol, and body slot.
//
//   ContentCard {
//       title: qsTr("Card")
//       Label { text: qsTr("Body") }
//   }
//
//   // --- API ---
//   // signals: onClicked
//
// @notes
//   Surface card with title/subtitle/symbol and body slot.

T.Control {
    id: control

    Layout.fillWidth: true

    // Primary title text
    property string title: ""
    // Secondary subtitle text
    property string subtitle: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Header icon glyph
    property string headerIcon: ""
    // Footer text
    property alias footer: footerSlot.data
    // Emit clicked when activated
    property bool isClickable: false
    // Card corner radius (binds ElevatedChrome)
    property real cornerRadius: Theme.cornerCard
    // Default children / content slot
    default property alias contentData: body.data
    // Emitted when clicked
    signal clicked()

    // Resolved header icon
    readonly property string effectiveHeaderIcon: IconSource.resolve(symbol, headerIcon)

    padding: 16
    implicitWidth: 320
    implicitHeight: Math.max(80, contentItem.implicitHeight + topPadding + bottomPadding)
    font.pixelSize: Theme.fontBody
    hoverEnabled: isClickable
    focusPolicy: isClickable ? Qt.StrongFocus : Qt.NoFocus
    Accessible.role: isClickable ? Accessible.Button : Accessible.Grouping
    Accessible.name: title
    Accessible.description: subtitle

    background: ElevatedChrome {
        color: {
            if (control.isClickable && control._pressed)
                return Theme.fillSubtleTertiary
            if (control.isClickable && control.hovered)
                return Theme.fillSubtle
            return Theme.bgCardElevated
        }
        radius: control.cornerRadius
        borderColor: control.activeFocus && control.isClickable ? Theme.focusOuter : Theme.strokeCard
        borderWidth: control.activeFocus && control.isClickable ? 2 : 1
        elevation: control.isClickable && control.hovered ? 6 : 4
        shadowOpacity: Theme.dark ? 0.28 : 0.12
        scale: control.isClickable && control._pressed && !Theme.reducedMotion ? 0.99 : 1

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }
        Behavior on scale {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on elevation {
            enabled: !Theme.reducedMotion
            NumberAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }

    property bool _pressed: false

    Keys.onReturnPressed: if (isClickable) clicked()
    Keys.onEnterPressed: if (isClickable) clicked()
    Keys.onSpacePressed: if (isClickable) clicked()

    TapHandler {
        enabled: control.isClickable
        onPressedChanged: control._pressed = pressed
        onTapped: control.clicked()
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacing

        RowLayout {
            visible: control.title.length > 0 || control.effectiveHeaderIcon.length > 0
            Layout.fillWidth: true
            spacing: Theme.spacing

            Text {
                visible: control.effectiveHeaderIcon.length > 0
                text: control.effectiveHeaderIcon
                font: Theme.iconFontFor(20)
                color: Theme.accent
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    visible: control.title.length > 0
                    text: control.title
                    font.pixelSize: Theme.fontBody
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Text {
                    visible: control.subtitle.length > 0
                    text: control.subtitle
                    font.pixelSize: Theme.fontCaption
                    color: Theme.textSecondary
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    maximumLineCount: 3
                    Layout.fillWidth: true
                }
            }
        }

        Rectangle {
            visible: control.title.length > 0 || control.effectiveHeaderIcon.length > 0
            Layout.fillWidth: true
            height: 1
            color: Theme.strokeDivider
        }

        ColumnLayout {
            id: body
            Layout.fillWidth: true
            spacing: 0

            onChildrenChanged: Qt.callLater(function () {
                if (control)
                    fitChildren()
            })
            Component.onCompleted: Qt.callLater(function () {
                if (control)
                    fitChildren()
            })

            function fitChildren() {
                for (var i = 0; i < children.length; ++i) {
                    var ch = children[i]
                    if (ch)
                        ch.Layout.fillWidth = true
                }
            }
        }

        Rectangle {
            visible: footerSlot.children.length > 0
            Layout.fillWidth: true
            height: 1
            color: Theme.strokeDivider
        }

        ColumnLayout {
            id: footerSlot
            visible: children.length > 0
            Layout.fillWidth: true
            spacing: 0

            onChildrenChanged: Qt.callLater(function () {
                if (control)
                    fitFooter()
            })
            Component.onCompleted: Qt.callLater(function () {
                if (control)
                    fitFooter()
            })

            function fitFooter() {
                for (var i = 0; i < children.length; ++i) {
                    var ch = children[i]
                    if (ch)
                        ch.Layout.fillWidth = true
                }
            }
        }
    }
}

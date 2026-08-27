import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// EmptyState — Placeholder illustration + title + optional action.
//
//   EmptyState {
//       title: qsTr("Nothing here")
//       description: qsTr("Try another filter.")
//   }
//
//   // --- API ---
//   // signals: onActionClicked, onSecondaryActionClicked
//
// @notes
//   Placeholder for empty lists; title/message (description alias) + optional action.
//   Neutral Document default (not Warning); bordered false by default for a lighter Fluent look.
//   illustration slot replaces the circular glyph when set.

T.Control {
    id: root

    Layout.fillWidth: true

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Fluent glyph drawn in the button
    property string glyph: ""
    // Primary title text
    property string title: qsTr("Nothing here yet")
    // Body / message text
    property string message: qsTr("When there is content, it will show up in this area.")
    // WinUI / docs alias of message
    property alias description: root.message
    // Optional action button label
    property string actionText: ""
    // Secondary action button label
    property string secondaryActionText: ""
    // Compact layout density
    property bool compact: false
    // Draw a border when true (default false — lighter empty surface)
    property bool bordered: false
    // Glyph color
    property color glyphColor: Theme.accent
    // Show leading glyph (ignored when illustration has children)
    property bool showGlyph: true
    // Custom illustration slot (replaces circular glyph)
    property alias illustration: illustrationSlot.data
    // Emitted when action is clicked
    signal actionClicked()
    // Secondary action clicked
    signal secondaryActionClicked()

    // Resolved glyph string — neutral Document, not Warning
    readonly property string effectiveGlyph: {
        var g = IconSource.resolve(symbol, glyph)
        return g.length ? g : FluentIcons.Document
    }
    readonly property bool _hasIllustration: illustrationSlot.children.length > 0

    implicitWidth: 320
    implicitHeight: column.implicitHeight + topPadding + bottomPadding
    padding: compact ? 16 : 24
    font.pixelSize: Theme.fontBody
    Accessible.role: Accessible.Grouping
    Accessible.name: title
    Accessible.description: message

    background: Rectangle {
        radius: Theme.cornerCard
        color: Theme.fillSubtleSecondary
        border.width: root.bordered ? 1 : 0
        border.color: Theme.strokeCard
    }

    contentItem: ColumnLayout {
        id: column
        spacing: root.compact ? Theme.spacing : Theme.spacingLoose

        Item {
            id: illustrationSlot
            visible: root._hasIllustration
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: childrenRect.width
            Layout.preferredHeight: childrenRect.height
            width: childrenRect.width
            height: childrenRect.height
            opacity: 0
            scale: 0.88
            Component.onCompleted: {
                opacity = 1
                scale = 1
            }
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingEnter
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

        Rectangle {
            visible: root.showGlyph && !root._hasIllustration
            Layout.alignment: Qt.AlignHCenter
            width: root.compact ? 40 : 56
            height: width
            radius: width / 2
            color: Theme.fillSubtle
            opacity: 0
            scale: 0.88
            Component.onCompleted: {
                opacity = 1
                scale = 1
            }
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingEnter
                }
            }
            Behavior on scale {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingEnter
                }
            }
            Text {
                anchors.centerIn: parent
                text: root.effectiveGlyph
                font: Theme.iconFontFor(root.compact ? 18 : 24)
                color: root.glyphColor
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            text: root.title
            font.pixelSize: root.compact ? Theme.fontBody : Theme.fontSubtitle
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            opacity: 0
            Component.onCompleted: opacity = 1
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingEnter
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            visible: root.message.length > 0
            text: root.message
            font.family: root.font.family
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 4
            spacing: Theme.spacing
            visible: root.actionText.length > 0 || root.secondaryActionText.length > 0

            Button {
                visible: root.secondaryActionText.length > 0
                text: root.secondaryActionText
                flat: true
                onClicked: root.secondaryActionClicked()
            }
            AccentButton {
                visible: root.actionText.length > 0
                text: root.actionText
                onClicked: root.actionClicked()
            }
        }
    }
}

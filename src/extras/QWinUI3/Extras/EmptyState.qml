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

T.Control {
    id: root

    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Fluent glyph drawn in the button
    property string glyph: ""
    // Primary title text
    property string title: qsTr("Nothing here yet")
    // Body / message text
    property string message: qsTr("When there is content, it will show up in this area.")
    // Optional action button label
    property string actionText: ""
    // Secondary action button label
    property string secondaryActionText: ""
    // Compact layout density
    property bool compact: false
    // Draw a border when true
    property bool bordered: true
    // Glyph color
    property color glyphColor: Theme.accent
    // Show leading glyph
    property bool showGlyph: true
    // Emitted when action is clicked
    signal actionClicked()
    // Secondary action clicked
    signal secondaryActionClicked()

    // Resolved glyph string
    readonly property string effectiveGlyph: {
        var g = IconSource.resolve(symbol, glyph)
        return g.length ? g : FluentIcons.Warning
    }

    implicitWidth: 320
    implicitHeight: column.implicitHeight + topPadding + bottomPadding
    padding: compact ? 16 : 24
    font.family: Theme.fontFamily
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

        Rectangle {
            visible: root.showGlyph
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
                font.family: Theme.fontFamilyIcon
                font.pixelSize: root.compact ? 18 : 24
                color: root.glyphColor
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            text: root.title
            font.family: Theme.fontFamilyDisplay
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

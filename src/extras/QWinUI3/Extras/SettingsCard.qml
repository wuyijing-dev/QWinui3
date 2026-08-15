import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

T.Pane {
    id: root

    property string title: ""
    property string description: ""
    property var symbol: ""
    property string iconGlyph: ""
    property var headerIcon: ""
    property alias action: actionSlot.data
    property alias content: contentSlot.data
    property bool interactive: false
    property bool showChevron: interactive
    signal clicked()

    readonly property string effectiveHeaderIcon: {
        var primary = (symbol !== undefined && symbol !== null && String(symbol).length)
                      ? symbol : headerIcon
        return IconSource.resolve(primary, iconGlyph)
    }

    padding: 16
    implicitWidth: 420
    implicitHeight: Math.max(64, contentItem.implicitHeight + topPadding + bottomPadding)
    hoverEnabled: interactive
    focusPolicy: interactive ? Qt.StrongFocus : Qt.NoFocus
    activeFocusOnTab: interactive
    Accessible.role: interactive ? Accessible.Button : Accessible.Grouping
    Accessible.name: title
    Accessible.description: description
    Keys.onReturnPressed: if (interactive) clicked()
    Keys.onEnterPressed: if (interactive) clicked()
    Keys.onSpacePressed: if (interactive) clicked()

    background: ElevatedChrome {
        color: {
            if (root.interactive && root.hovered)
                return Theme.fillSubtle
            return Theme.bgCard
        }
        radius: Theme.cornerCard
        borderWidth: root.interactive && root.activeFocus ? 2 : 1
        borderColor: root.interactive && root.activeFocus ? Theme.accent : Theme.strokeCard
        elevation: 2
        shadowOpacity: Theme.dark ? 0.22 : 0.08

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.duration(Theme.motionFast)
                easing.type: Theme.easingStandard
            }
        }
        Behavior on borderColor {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }

    contentItem: RowLayout {
        spacing: Theme.spacingLoose

        Text {
            visible: root.effectiveHeaderIcon.length > 0
            text: root.effectiveHeaderIcon
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 20
            color: Theme.accent
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.title
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            Text {
                visible: root.description.length > 0
                text: root.description
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            Item {
                id: contentSlot
                visible: children.length > 0
                Layout.fillWidth: true
                Layout.topMargin: 6
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height
            }
        }

        Item {
            id: actionSlot
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }

        Text {
            visible: root.showChevron
            Layout.alignment: Qt.AlignVCenter
            text: FluentIcons.ChevronRight
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 12
            color: Theme.textSecondary
        }
    }

    TapHandler {
        enabled: root.interactive
        onTapped: root.clicked()
    }
}

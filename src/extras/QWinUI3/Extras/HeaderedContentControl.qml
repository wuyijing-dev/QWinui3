import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects
import QWinUI3.Theme

T.Control {
    id: root

    property string header: ""
    property string description: ""
    property Component headerComponent: null
    // top | left
    property string headerPlacement: "top"
    default property alias contentData: body.data

    padding: 12
    spacing: 8
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontBody

    implicitWidth: Math.max(160, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    readonly property bool _headerLeft: headerPlacement === "left"

    contentItem: GridLayout {
        columns: root._headerLeft ? 2 : 1
        rows: root._headerLeft ? 1 : 3
        columnSpacing: root.spacing
        rowSpacing: root.spacing

        ColumnLayout {
            id: headerCol
            Layout.row: 0
            Layout.column: 0
            Layout.fillWidth: !root._headerLeft
            Layout.alignment: root._headerLeft ? Qt.AlignTop : Qt.AlignLeft
            Layout.preferredWidth: root._headerLeft ? 120 : -1
            spacing: 4
            visible: root.headerComponent !== null || root.header.length > 0 || root.description.length > 0

            Loader {
                id: headerLoader
                Layout.fillWidth: true
                active: root.headerComponent !== null || root.header.length > 0
                sourceComponent: root.headerComponent !== null ? root.headerComponent : defaultHeader
            }
            Text {
                visible: root.description.length > 0
                Layout.fillWidth: true
                text: root.description
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
                wrapMode: Text.Wrap
            }
        }

        Rectangle {
            visible: !root._headerLeft && headerCol.visible
            Layout.row: 1
            Layout.column: 0
            Layout.fillWidth: true
            height: 1
            color: Theme.strokeDivider
        }

        ColumnLayout {
            id: body
            Layout.row: root._headerLeft ? 0 : 2
            Layout.column: root._headerLeft ? 1 : 0
            Layout.fillWidth: true
            spacing: Theme.spacing
        }
    }

    Component {
        id: defaultHeader
        Text {
            text: root.header
            font.family: Theme.fontFamily
            font.pixelSize: root._headerLeft ? Theme.fontBody : Theme.fontCaption
            font.weight: Theme.fontWeightSemiBold
            color: root._headerLeft ? Theme.textPrimary : Theme.textSecondary
            elide: Text.ElideRight
            width: headerLoader.width
            wrapMode: Text.Wrap
        }
    }

    background: Rectangle {
        radius: Theme.cornerControl
        color: Theme.bgCard
        border.width: 1
        border.color: Theme.strokeCard

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: Theme.dark ? 0.2 : 0.08
            shadowColor: "#000000"
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 2
            blurMax: 12
            autoPaddingEnabled: true
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QWinUI3.Theme

// TreeViewDelegate — Fluent TreeView row with chevron expand / indent.
//
//   TreeView {
//       id: tree
//       model: treeModel
//       delegate: TreeViewDelegate {
//           // indentation / expansion affordance from style
//       }
//   }
//   // --- API ---
//   // inherits TreeViewDelegate: treeView, expanded, depth, indentation
//   // --- API ---
//   // inherits TreeViewDelegate: treeView, expanded, depth, indentation

T.TreeViewDelegate {
    id: control

    implicitWidth: leftMargin + __contentIndent + implicitContentWidth + rightPadding + rightMargin
    implicitHeight: Math.max(Theme.navItemHeight, implicitContentHeight + 8)

    indentation: 16
    leftMargin: 8
    rightMargin: 8
    spacing: 8
    topPadding: contentItem ? (height - contentItem.implicitHeight) / 2 : 0
    leftPadding: !mirrored ? leftMargin + __contentIndent : width - leftMargin - __contentIndent - implicitContentWidth

    highlighted: control.selected || control.current
               || ((control.treeView.selectionBehavior === TableView.SelectRows
               || control.treeView.selectionBehavior === TableView.SelectionDisabled)
               && control.row === control.treeView.currentRow)

    required property int row
    // Data model
    required property var model
    readonly property real __contentIndent: !isTreeNode ? 0
        : (depth * indentation) + (indicator ? indicator.width + spacing : 0)

    indicator: Item {
        readonly property real __indicatorIndent: control.leftMargin + (control.depth * control.indentation)
        x: !control.mirrored ? __indicatorIndent : control.width - __indicatorIndent - width
        y: (control.height - height) / 2
        implicitWidth: 20
        implicitHeight: 20
        visible: control.isTreeNode && control.hasChildren

        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerControl
            color: chevronHover.hovered ? Theme.fillSubtle : "transparent"
            HoverHandler { id: chevronHover }
        }

        Text {
            anchors.centerIn: parent
            text: FluentIcons.ChevronRight
            font.family: Theme.fontFamilyIcon
            font.pixelSize: 10
            color: Theme.textSecondary
            rotation: control.expanded ? 90 : (control.mirrored ? 180 : 0)
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
        implicitHeight: Theme.navItemHeight
        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4
            anchors.topMargin: 2
            anchors.bottomMargin: 2
            radius: Theme.cornerControl
            color: control.highlighted ? Theme.fillSubtle
                 : (control.hovered ? Theme.fillSubtleSecondary : "transparent")
            Behavior on color {
                enabled: !Theme.reducedMotion
                ColorAnimation {
                    duration: Theme.duration(Theme.motionFast)
                    easing.type: Theme.easingStandard
                }
            }
        }
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: 3
            height: control.highlighted ? 16 : 0
            radius: 1.5
            color: Theme.accent
            Behavior on height {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.duration(Theme.motionNormal)
                    easing.type: Theme.easingStandard
                }
            }
        }
    }

    contentItem: Label {
        clip: false
        text: control.model.display ?? ""
        elide: Text.ElideRight
        color: control.enabled ? Theme.textPrimary : Theme.textDisabled
        visible: !control.editing
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontBody
        font.weight: control.highlighted ? Theme.fontWeightSemiBold : Theme.fontWeightRegular
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// FormSection — Collapsible field group for FormLayout (2.67 D2).
//
//   FormLayout {
//       FormSection {
//           title: qsTr("Billing")
//           expanded: true
//           HeaderedTextBox { header: qsTr("Card") }
//       }
//   }
//
// @notes
//   Expands/collapses child fields; honors Theme.reducedMotion.
//   Set formBound: false on the section itself if you do not want labelWidth push
//   onto the header chrome (children still receive FormLayout defaults).

T.Pane {
    id: root

    Layout.fillWidth: true

    // Section header title
    property string title: ""
    // Expanded when true
    property bool expanded: true
    // Show expand/collapse chevron
    property bool collapsible: true
    // Optional formFieldId for FormLayout.setFieldVisible
    property string formFieldId: ""
    // Children / field slot
    default property alias content: body.data

    // Opt out of FormLayout labelWidth on the Pane chrome
    property bool formBound: false

    padding: 0
    background: null
    Accessible.role: Accessible.Grouping
    Accessible.name: title.length ? title : qsTr("Form section")

    contentItem: ColumnLayout {
        spacing: Theme.spacingTight
        width: root.availableWidth

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            Label {
                Layout.fillWidth: true
                text: root.title
                font.pixelSize: Theme.fontBody
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }

            ToolButton {
                visible: root.collapsible
                Accessible.name: root.expanded ? qsTr("Collapse section") : qsTr("Expand section")
                onClicked: root.expanded = !root.expanded
                contentItem: FontIcon {
                    glyph: root.expanded ? FluentIcons.ChevronUp : FluentIcons.ChevronDown
                    fontSize: 12
                    iconColor: Theme.textSecondary
                    microMotionEnabled: false
                }
            }
        }

        ColumnLayout {
            id: body
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            visible: root.expanded
            opacity: root.expanded ? 1 : 0
            Behavior on opacity {
                enabled: !Theme.reducedMotion
                NumberAnimation {
                    duration: Theme.motion.ms("fast")
                    easing.type: Theme.motion.easing("standard")
                }
            }
        }
    }
}

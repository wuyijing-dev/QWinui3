import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Templates as T
import QWinUI3.Theme

// SettingsCard — Settings row: icon, title, description, action (Toolkit ContentAlignment).
//
//   SettingsCard {
//       title: qsTr("Dark mode")
//       description: qsTr("Use a dark appearance.")
//       toggle: true
//       checked: Theme.dark
//       onToggled: Theme.dark = checked
//   }
//
//   SettingsCard {
//       title: qsTr("Density")
//       action: ComboBox { model: [qsTr("Standard"), qsTr("Compact")] }
//   }
//
//   // --- API ---
//   // signals: onClicked, onToggled
//   // inherits Pane (+ Qt Quick Controls base API)
//
// @notes
//   Toolkit SettingsCard: Header/Description/HeaderIcon, Content + Action slots,
//   ContentAlignment (right|left|vertical|center), IsClickEnabled, ActionIcon chevron,
//   cornerRadius for ElevatedChrome.
//   Set toggle: true for a built-in Switch (checked / onToggled) — no action glue.
//   Toggle rows are one Accessible CheckBox (title + Space/Enter); the Switch is mouse-only.
//   Empty title/description collapse; contentAlignment "center" centers content (illustration cards).
//   Layout.fillWidth defaults to true inside Column/Row/Grid layouts.

T.Pane {
    id: root

    Layout.fillWidth: true

    // Primary title text (Toolkit Header)
    property string title: ""
    // Toolkit Header alias
    property alias header: root.title
    // Supporting description text
    property string description: ""
    // FluentIcons symbol (preferred over iconGlyph)
    property var symbol: ""
    // Raw Fluent glyph string fallback
    property string iconGlyph: ""
    // Header icon glyph / symbol (Toolkit HeaderIcon)
    property var headerIcon: ""
    // Custom action slot (trailing control); ignored when toggle is true
    property alias action: actionSlot.data
    // Content slot / children host
    property alias content: contentSlot.data
    // Built-in Switch action (mutually exclusive with action:)
    property bool toggle: false
    // Switch checked state (when toggle is true)
    property alias checked: toggleSwitch.checked
    // Switch enabled (when toggle is true)
    property alias toggleEnabled: toggleSwitch.enabled
    // Optional Switch text beside the thumb
    property alias toggleText: toggleSwitch.text
    // Enable hover / click interaction
    property bool interactive: false
    // Toolkit IsClickEnabled
    property alias isClickEnabled: root.interactive
    // Toolkit ContentAlignment: "right" | "left" | "vertical" | "center"
    property string contentAlignment: "right"
    // Show trailing chevron when clickable
    property bool showChevron: interactive
    // Toolkit ActionIcon — Fluent symbol for the trailing affordance
    property var actionIcon: ""
    // Action icon glyph fallback
    property string actionIconGlyph: ""
    // Card corner radius (binds ElevatedChrome)
    property real cornerRadius: Theme.cornerCard
    // Emitted when clicked
    signal clicked()
    // Emitted when the built-in Switch toggles
    signal toggled(bool checked)

    readonly property string effectiveHeaderIcon: {
        var primary = (symbol !== undefined && symbol !== null && String(symbol).length)
                      ? symbol : headerIcon
        return IconSource.resolve(primary, iconGlyph)
    }
    readonly property string effectiveActionIcon: {
        var custom = IconSource.resolve(actionIcon, actionIconGlyph)
        if (custom.length)
            return custom
        return FluentIcons.ChevronRight
    }
    readonly property string _align: String(contentAlignment).toLowerCase()
    readonly property bool _vertical: _align === "vertical"
    readonly property bool _contentLeft: _align === "left"
    readonly property bool _contentCenter: _align === "center"
    readonly property bool _hasHeaderText: title.length > 0 || description.length > 0
    readonly property bool _showHeaderColumn: _hasHeaderText && !_contentCenter

    padding: 16
    implicitWidth: 420
    implicitHeight: Math.max(64, contentItem.implicitHeight + topPadding + bottomPadding)
    hoverEnabled: interactive
    // Toggle rows are one focusable CheckBox; Switch itself is ignored for AT / Tab.
    readonly property bool _rowFocusable: interactive || toggle
    focusPolicy: _rowFocusable ? Qt.StrongFocus : Qt.NoFocus
    activeFocusOnTab: _rowFocusable
    Accessible.role: interactive ? Accessible.Button
                   : (toggle ? Accessible.CheckBox : Accessible.Grouping)
    Accessible.name: title.length ? title : (toggle ? qsTr("Toggle") : qsTr("Settings row"))
    Accessible.description: description
    Accessible.checkable: toggle && !interactive
    Accessible.checked: toggle && !interactive ? checked : false
    Accessible.onToggleAction: {
        if (toggle && !interactive && toggleSwitch.enabled)
            toggleSwitch.toggle()
    }
    Keys.onReturnPressed: {
        if (interactive)
            clicked()
        else if (toggle && toggleSwitch.enabled)
            toggleSwitch.toggle()
    }
    Keys.onEnterPressed: {
        if (interactive)
            clicked()
        else if (toggle && toggleSwitch.enabled)
            toggleSwitch.toggle()
    }
    Keys.onSpacePressed: {
        if (interactive)
            clicked()
        else if (toggle && toggleSwitch.enabled)
            toggleSwitch.toggle()
    }

    background: ElevatedChrome {
        color: {
            if (root.interactive && root.hovered)
                return Theme.fillSubtle
            return Theme.bgCard
        }
        radius: root.cornerRadius
        borderWidth: root._rowFocusable && root.activeFocus ? 2 : 1
        borderColor: root._rowFocusable && root.activeFocus ? Theme.accent : Theme.strokeCard
        elevation: root.interactive && root.hovered && !Theme.reducedMotion ? 3 : 2
        shadowOpacity: Theme.dark ? 0.22 : 0.08

        Behavior on color {
            enabled: !Theme.reducedMotion
            ColorAnimation {
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }
        Behavior on elevation {
            enabled: !Theme.reducedMotion
            NumberAnimation {
                duration: Theme.motionMs("fast")
                easing.type: Theme.motionEasing("standard")
            }
        }
        Behavior on borderColor {
            enabled: !Theme.reducedMotion
            ColorAnimation { duration: Theme.duration(Theme.motionFast) }
        }
    }

    contentItem: ColumnLayout {
        spacing: Theme.spacing

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            visible: !root._vertical || root._showHeaderColumn || root.effectiveHeaderIcon.length > 0

            FontIcon {
                visible: root.effectiveHeaderIcon.length > 0 && !root._contentCenter
                glyph: root.effectiveHeaderIcon
                fontSize: 20
                selected: true
                iconColor: Theme.accent
                microMotionEnabled: false
                Layout.alignment: Qt.AlignVCenter
            }

            // Left: content before header text
            Item {
                id: contentSlotLeftHost
                visible: root._contentLeft && !root._vertical
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: visible ? Math.max(contentSlot.width, 1) : 0
                Layout.preferredHeight: visible ? Math.max(contentSlot.height, 1) : 0
            }

            ColumnLayout {
                visible: root._showHeaderColumn
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                Text {
                    visible: root.title.length > 0
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
                    elide: Text.ElideRight
                    maximumLineCount: 3
                    Layout.fillWidth: true
                }
            }

            // Center alignment: content fills and centers (illustration / media cards)
            Item {
                id: contentSlotCenterHost
                visible: root._contentCenter && !root._vertical
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredHeight: visible ? Math.max(contentSlot.height, 1) : 0
                Layout.minimumHeight: visible ? Math.max(contentSlot.height, 1) : 0
            }

            // Right (default): content beside action
            Item {
                id: contentSlotRightHost
                visible: !root._contentLeft && !root._vertical && !root._contentCenter
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: visible ? Math.max(contentSlot.width, 1) : 0
                Layout.preferredHeight: visible ? Math.max(contentSlot.height, 1) : 0
            }

            Item {
                id: actionSlotHost
                visible: !root._vertical && (root.toggle || actionSlot.children.length > 0)
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: visible ? Math.max(actionSlot.width, 1) : 0
                Layout.preferredHeight: visible ? Math.max(actionSlot.height, 1) : 0
            }

            FontIcon {
                visible: root.showChevron && !root._contentCenter
                glyph: root.effectiveActionIcon
                fontSize: 12
                iconColor: Theme.textSecondary
                microMotionEnabled: false
                Layout.alignment: Qt.AlignVCenter
            }
        }

        // Vertical: content + action under the header row
        ColumnLayout {
            visible: root._vertical
            Layout.fillWidth: true
            spacing: Theme.spacing
            Item {
                id: contentSlotVertHost
                visible: root._vertical
                Layout.fillWidth: true
                Layout.preferredHeight: visible ? Math.max(contentSlot.height, 1) : 0
            }
            Item {
                id: actionSlotVertHost
                visible: root._vertical && (root.toggle || actionSlot.children.length > 0)
                Layout.fillWidth: true
                Layout.preferredHeight: visible ? Math.max(actionSlot.height, 1) : 0
            }
        }
    }

    // Canonical slots (reparented visually via parent binding)
    Item {
        id: contentSlot
        parent: {
            if (root._vertical)
                return contentSlotVertHost
            if (root._contentCenter)
                return contentSlotCenterHost
            if (root._contentLeft)
                return contentSlotLeftHost
            return contentSlotRightHost
        }
        anchors.horizontalCenter: root._contentCenter ? parent.horizontalCenter : undefined
        width: childrenRect.width
        height: childrenRect.height
        visible: children.length > 0
    }

    Item {
        id: actionSlot
        parent: root._vertical ? actionSlotVertHost : actionSlotHost
        width: childrenRect.width
        height: childrenRect.height
        visible: children.length > 0
    }

    Switch {
        id: toggleSwitch
        parent: root.toggle ? actionSlot : null
        visible: root.toggle
        // Row owns Accessible + Tab; keep the thumb mouse-only.
        focusPolicy: Qt.NoFocus
        activeFocusOnTab: false
        Accessible.ignored: true
        onToggled: function (checked) { root.toggled(checked) }
    }

    TapHandler {
        enabled: root.interactive
        onTapped: root.clicked()
    }
}

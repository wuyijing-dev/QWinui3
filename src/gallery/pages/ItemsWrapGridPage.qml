import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ItemsWrapGrid (2.24).
//
// Variable-size wrap + filter + touch floor. Recipe: docs/items-wrap-grid.md

CatalogPage {
    title: qsTr("ItemsWrapGrid")
    subtitle: qsTr("Model-driven wrap with variable item sizes — experimental, docs/items-wrap-grid.md (2.24 / 2.29 a11y).")

    readonly property var tagModel: [
        { title: qsTr("Design"), wide: false },
        { title: qsTr("Engineering"), wide: true },
        { title: qsTr("Documentation"), wide: true },
        { title: qsTr("QA"), wide: false },
        { title: qsTr("Accessibility"), wide: true },
        { title: qsTr("Performance"), wide: false },
        { title: qsTr("Localization"), wide: true },
        { title: qsTr("Charts"), wide: false },
        { title: qsTr("Navigation"), wide: false },
        { title: qsTr("Settings"), wide: false },
        { title: qsTr("Touch & pointer"), wide: true },
        { title: qsTr("Keyboard"), wide: false },
        { title: qsTr("Theming"), wide: false },
        { title: qsTr("Packaging"), wide: true },
        { title: qsTr("Gallery"), wide: false }
    ]

    ControlExample {
        headerText: qsTr("Filter perf (2.49 / wave 8)")
        qmlSource: "ItemsWrapGrid { filterDebounceMs: 120 }  // low hundreds max"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("ItemsWrapGrid uses WrapPanel + Repeater — not virtualized. Debounce filterText (filterDebounceMs default 120). Cap tile count at low hundreds; use ItemsView or DataTable at scale. docs/performance.md wave 8 · docs/perf-signoff-2xx.md.")
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
        }
    }

    ControlExample {
        headerText: qsTr("Tag cloud (2.24)")
        qmlSource: "ItemsWrapGrid {\n    model: tags\n    delegate: Chip { text: modelData.title }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            TextField {
                id: tagFilter
                Layout.fillWidth: true
                placeholderText: qsTr("Filter tags")
                Accessible.name: qsTr("Filter tags")
            }
            ItemsWrapGrid {
                id: tagGrid
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                accessibleName: qsTr("Tags")
                filterText: tagFilter.text
                minItemSize: Theme.controlHeight
                horizontalSpacing: 8
                verticalSpacing: 8
                model: tagModel
                delegate: Chip {
                    required property int index
                    required property var modelData
                    text: modelData.title
                    implicitHeight: Math.max(implicitHeight, tagGrid.minItemSize)
                    onClicked: tagGrid.itemActivated(index, modelData)
                }
                onItemActivated: function (index, item) {
                    status.text = qsTr("Activated %1 (index %2, %3 visible)")
                        .arg(item.title).arg(index).arg(tagGrid.count)
                }
            }
            Label {
                id: status
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("%1 tags · minItemSize %2px — scroll when wrapped rows exceed height")
                    .arg(tagGrid.count).arg(Math.round(tagGrid.minItemSize))
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
        }
    }

    ControlExample {
        headerText: qsTr("Variable tile widths")
        qmlSource: "ItemsWrapGrid {\n    itemWidth: -1\n    delegate: Rectangle { implicitWidth: modelData.w }\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            ItemsWrapGrid {
                id: tileGrid
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                horizontalSpacing: 10
                verticalSpacing: 10
                model: [
                    { label: qsTr("S"), w: 72 },
                    { label: qsTr("Medium"), w: 120 },
                    { label: qsTr("Wide tile"), w: 200 },
                    { label: qsTr("M"), w: 96 },
                    { label: qsTr("Extra wide content"), w: 240 },
                    { label: qsTr("S2"), w: 64 },
                    { label: qsTr("Balanced"), w: 140 },
                    { label: qsTr("XL"), w: 260 }
                ]
                delegate: Rectangle {
                    required property int index
                    required property var modelData
                    radius: Theme.cornerControl
                    color: Theme.fillSubtle
                    border.width: 1
                    border.color: Theme.strokeCard
                    implicitWidth: modelData.w
                    implicitHeight: Math.max(Theme.controlHeight, 44)
                    Text {
                        anchors.centerIn: parent
                        text: modelData.label
                        font.pixelSize: Theme.fontCaption
                        color: Theme.textPrimary
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: tileGrid.itemActivated(index, modelData)
                    }
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Use WrapPanel + Repeater for static children; ItemsWrapGrid adds model + optional filterText like ItemsRepeater.")
                color: Theme.textSecondary
                font.pixelSize: Theme.fontCaption
            }
        }
    }
}

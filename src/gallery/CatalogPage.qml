import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// CatalogPage — Gallery scroll host (PageHeader + padded column).
//
//   CatalogPage {
//       title: qsTr("Button")
//       subtitle: qsTr("…")
//       ControlExample { headerText: qsTr("Basic"); … }
//   }
//
// Root is Item (not Page): Qt 6.8 Page.title / Page.footer / Pane.contentData are FINAL
// and cannot be redeclared or aliased.

Item {
    id: root

    property string title: ""
    property alias subtitle: header.subtitle
    // Gallery page component id for favorites (set by Main on open — 1.20)
    property alias componentId: header.componentId
    property real pagePadding: Theme.spacingSection
    property real sectionSpacing: Theme.spacingSection
    // Optional footer outside the scroll (e.g. StatusBar)
    property alias footer: footerSlot.data
    // Floating overlays (ToastHost, dialogs) — not scrolled
    property alias overlay: overlaySlot.data
    default property alias contentData: stack.data

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ScrollView {
            id: scroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            clip: true
            background: null

            ColumnLayout {
                width: scroll.availableWidth
                spacing: root.sectionSpacing

                PageHeader {
                    id: header
                    Layout.fillWidth: true
                    Layout.leftMargin: root.pagePadding
                    Layout.rightMargin: root.pagePadding
                    Layout.topMargin: root.pagePadding
                    title: root.title
                    visible: root.title.length > 0 || root.subtitle.length > 0
                }

                ColumnLayout {
                    id: stack
                    Layout.fillWidth: true
                    Layout.leftMargin: root.pagePadding
                    Layout.rightMargin: root.pagePadding
                    Layout.bottomMargin: root.pagePadding
                    spacing: root.sectionSpacing
                }
            }
        }

        Item {
            id: footerSlot
            Layout.fillWidth: true
            Layout.preferredHeight: children.length ? childrenRect.height : 0
            visible: children.length > 0

            Binding {
                target: footerSlot.children.length === 1 ? footerSlot.children[0] : null
                property: "width"
                value: footerSlot.width
                when: footerSlot.children.length === 1
            }
        }
    }

    Item {
        id: overlaySlot
        anchors.fill: parent
        z: 100
    }
}

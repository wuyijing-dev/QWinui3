import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Master–detail LoB shell — ListDetailsView (docs/data-collections.md).

StandardWindow {
    id: window
    width: 1000
    height: 680
    visible: true
    title: qsTr("Master–detail example")
    backdrop: WindowHelper.BackdropSolid

    readonly property var tickets: [
        {
            title: qsTr("Portal timeout"),
            subtitle: qsTr("INC-1042 · High"),
            status: qsTr("Open"),
            assignee: qsTr("Alex Chen"),
            body: qsTr("Customers report intermittent 504s on /api/v2/orders after deploy. Reproduce with a cold cache.")
        },
        {
            title: qsTr("Invoice PDF blank"),
            subtitle: qsTr("INC-1038 · Medium"),
            status: qsTr("In progress"),
            assignee: qsTr("Jordan Lee"),
            body: qsTr("PDF export renders an empty page for multi-currency invoices. Workaround: print from HTML.")
        },
        {
            title: qsTr("SSO redirect loop"),
            subtitle: qsTr("INC-1021 · Critical"),
            status: qsTr("Waiting"),
            assignee: qsTr("Sam Rivera"),
            body: qsTr("IdP callback returns to login when cookie SameSite=Lax on embedded WebView. Needs host allowlist.")
        },
        {
            title: qsTr("Dark theme contrast"),
            subtitle: qsTr("INC-1015 · Low"),
            status: qsTr("Open"),
            assignee: qsTr("Riley Park"),
            body: qsTr("Secondary labels fail WCAG AA on Mica dark. Prefer Theme.textSecondary tokens.")
        }
    ]

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
            subtitle: qsTr("ListDetailsView · docs/data-collections.md")
        }
    }

    ListDetailsView {
        id: listDetails
        anchors.fill: parent
        anchors.margins: Theme.spacing
        accessibleName: qsTr("Work items")
        listAccessibleName: qsTr("Ticket list")
        model: window.tickets
        listPaneWidth: 280
        Component.onCompleted: select(0)

        details: ScrollView {
            anchors.fill: parent
            contentWidth: availableWidth
            clip: true
            background: null

            ColumnLayout {
                width: Math.max(0, parent.width - Theme.spacing)
                spacing: Theme.spacingLoose

                Text {
                    Layout.fillWidth: true
                    text: listDetails.selectedItem
                          ? listDetails.selectedItem.title : qsTr("Select a ticket")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontTitle
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                    wrapMode: Text.Wrap
                }

                Text {
                    Layout.fillWidth: true
                    visible: !!listDetails.selectedItem
                    text: listDetails.selectedItem
                          ? listDetails.selectedItem.subtitle : ""
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    color: Theme.textSecondary
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    visible: !!listDetails.selectedItem

                    StatusDot {
                        id: ticketDot
                        status: {
                            var s = listDetails.selectedItem
                                    ? listDetails.selectedItem.status : ""
                            if (s === qsTr("In progress"))
                                return ticketDot.available
                            if (s === qsTr("Waiting"))
                                return ticketDot.away
                            if (s === qsTr("Open"))
                                return ticketDot.busy
                            return ticketDot.offline
                        }
                    }
                    Label {
                        text: listDetails.selectedItem
                              ? listDetails.selectedItem.status : ""
                        color: Theme.textPrimary
                    }
                    Item { Layout.fillWidth: true }
                    Label {
                        text: listDetails.selectedItem
                              ? qsTr("Assignee: %1").arg(listDetails.selectedItem.assignee)
                              : ""
                        color: Theme.textSecondary
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: Theme.dividerStroke
                }

                Text {
                    Layout.fillWidth: true
                    visible: !!listDetails.selectedItem
                    text: listDetails.selectedItem
                          ? listDetails.selectedItem.body : ""
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontBody
                    color: Theme.textPrimary
                    wrapMode: Text.Wrap
                }

                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: Theme.spacing
                    wrapMode: Text.Wrap
                    color: Theme.textSecondary
                    text: qsTr("Wide: list + details side by side. Narrow: select opens details — Back or Esc returns to the list.")
                }
            }
        }
    }
}

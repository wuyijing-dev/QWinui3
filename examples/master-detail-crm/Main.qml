import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Vertical kit V2 (3.07) — CRM: ListDetailsView + DataTable + CommandBar.
// Recipe: docs/data-collections.md · docs/app-platform-3xx.md

StandardWindow {
    id: window
    width: 1100
    height: 720
    visible: true
    title: qsTr("CRM — accounts")
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "MasterDetailCrmExample"

    property string statusHint: qsTr("Select an account · CommandBar acts on the selection.")

    readonly property var accounts: [
        {
            title: qsTr("Northwind Traders"),
            subtitle: qsTr("ACC-2041 · Enterprise"),
            owner: qsTr("Alex Chen"),
            stage: qsTr("Negotiation"),
            arr: 420000,
            contacts: [
                { name: qsTr("Jamie Ortiz"), role: qsTr("Buyer"), email: "jamie@northwind.example" },
                { name: qsTr("Pat Kim"), role: qsTr("IT"), email: "pat@northwind.example" }
            ]
        },
        {
            title: qsTr("Contoso Labs"),
            subtitle: qsTr("ACC-1988 · Mid-market"),
            owner: qsTr("Jordan Lee"),
            stage: qsTr("Qualified"),
            arr: 96000,
            contacts: [
                { name: qsTr("Sam Rivera"), role: qsTr("Champion"), email: "sam@contoso.example" }
            ]
        },
        {
            title: qsTr("Fabrikam Health"),
            subtitle: qsTr("ACC-2110 · Enterprise"),
            owner: qsTr("Riley Park"),
            stage: qsTr("Closed won"),
            arr: 780000,
            contacts: [
                { name: qsTr("Casey Ng"), role: qsTr("CISO"), email: "casey@fabrikam.example" },
                { name: qsTr("Morgan Ellis"), role: qsTr("Ops"), email: "morgan@fabrikam.example" }
            ]
        },
        {
            title: qsTr("Adventure Works"),
            subtitle: qsTr("ACC-1872 · SMB"),
            owner: qsTr("Alex Chen"),
            stage: qsTr("Prospect"),
            arr: 24000,
            contacts: [
                { name: qsTr("Taylor Brooks"), role: qsTr("Owner"), email: "taylor@adventure.example" }
            ]
        }
    ]

    header: PlatformTitleBar {
        targetWindow: window
        TitleBar {
            embedded: true
            title: window.title
            subtitle: qsTr("V2 · ListDetailsView · DataTable · CommandBar")
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing
        spacing: Theme.spacing

        CommandBar {
            Layout.fillWidth: true
            compact: false
            isDynamicOverflowEnabled: true
            isToggleButtonVisible: true
            defaultLabelPosition: "bottom"

            AppBarButton {
                text: qsTr("New")
                symbol: FluentIcons.Add
                onClicked: window.statusHint = qsTr("New account — wire to your create flow.")
            }
            AppBarButton {
                text: qsTr("Edit")
                symbol: FluentIcons.Edit
                enabled: !!listDetails.selectedItem
                onClicked: window.statusHint = qsTr("Edit %1").arg(listDetails.selectedItem.title)
            }
            AppBarSeparator {}
            AppBarButton {
                text: qsTr("Log call")
                symbol: FluentIcons.Phone
                enabled: !!listDetails.selectedItem
                onClicked: window.statusHint = qsTr("Logged call for %1").arg(listDetails.selectedItem.title)
            }
            AppBarButton {
                text: qsTr("Email")
                symbol: FluentIcons.Mail
                enabled: !!listDetails.selectedItem
                onClicked: window.statusHint = qsTr("Compose email for %1").arg(listDetails.selectedItem.title)
            }
        }

        Label {
            Layout.fillWidth: true
            text: window.statusHint
            color: Theme.textSecondary
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontCaption
        }

        ListDetailsView {
            id: listDetails
            Layout.fillWidth: true
            Layout.fillHeight: true
            accessibleName: qsTr("Accounts")
            listAccessibleName: qsTr("Account list")
            model: window.accounts
            listPaneWidth: 280
            Component.onCompleted: select(0)

            details: ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacing

                Text {
                    Layout.fillWidth: true
                    text: listDetails.selectedItem
                          ? listDetails.selectedItem.title : qsTr("Select an account")
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
                          ? qsTr("%1 · Owner %2 · ARR %3")
                                .arg(listDetails.selectedItem.subtitle)
                                .arg(listDetails.selectedItem.owner)
                                .arg(listDetails.selectedItem.arr)
                          : ""
                    font.pixelSize: Theme.fontBody
                    color: Theme.textSecondary
                    wrapMode: Text.Wrap
                }

                Text {
                    Layout.fillWidth: true
                    text: qsTr("Contacts")
                    font.pixelSize: Theme.fontBody
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                DataTable {
                    id: contacts
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    filterPlaceholder: qsTr("Filter contacts")
                    columns: [
                        { title: qsTr("Name"), role: "name", width: 160, sortable: true },
                        { title: qsTr("Role"), role: "role", width: 120, sortable: true },
                        { title: qsTr("Email"), role: "email", width: 220, sortable: true }
                    ]
                    rows: listDetails.selectedItem ? listDetails.selectedItem.contacts : []
                }
            }
        }
    }
}

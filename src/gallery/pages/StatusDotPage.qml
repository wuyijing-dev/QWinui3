import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — StatusDot.

CatalogPage {
    title: qsTr("StatusDot")
    subtitle: qsTr("Presence and health indicators with optional pulse and tooltip.")

    ControlExample {
        headerText: qsTr("States")
        qmlSource: "StatusDot { status: available; label: \"Online\"; pulse: true }"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            RowLayout {
                spacing: Theme.spacingSection
                StatusDot { id: s1; status: s1.available; label: qsTr("Available"); pulse: true }
                StatusDot { id: s2; status: s2.away; label: qsTr("Away") }
                StatusDot { id: s3; status: s3.busy; label: qsTr("Busy"); pulse: false }
                StatusDot { id: s4; status: s4.offline; label: qsTr("Offline"); pulse: false }
            }
            RowLayout {
                spacing: Theme.spacingLoose
                Label {
                    text: qsTr("Tooltip only (hover):")
                    color: Theme.textSecondary
                }
                StatusDot { id: tipDot; status: tipDot.available; pulse: true }
                Label {
                    text: tipDot.statusName
                    color: Theme.textSecondary
                }
            }
            ListTile {
                Layout.maximumWidth: 420
                title: qsTr("Alex Rivera")
                subtitle: qsTr("In a meeting")
                symbol: FluentIcons.Contact
                StatusDot {
                    id: presence
                    status: presence.busy
                    pulse: false
                }
            }
        }
    }
}

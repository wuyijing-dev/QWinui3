import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — PersonPicture.

CatalogPage {
    title: qsTr("PersonPicture")
    subtitle: qsTr("Avatar, initials, Contact glyph when empty, focus ring, and status / count badges.")

    ControlExample {
        headerText: qsTr("Initials, status, and counts")
        qmlSource: "PersonPicture {\n    displayName: \"Alex Rivera\"\n    badgeVisible: true\n    badgeValue: 3\n}"
        RowLayout {
            spacing: Theme.spacingLoose
            PersonPicture {
                displayName: "Alex Rivera"
                size: 32
            }
            PersonPicture {
                displayName: "Jordan Lee"
                initials: "JL"
                size: 48
                badgeVisible: true
                badgeSeverity: 1
            }
            PersonPicture {
                displayName: "Sam Chen"
                size: 72
                badgeVisible: true
                badgeColor: Theme.systemCaution
                badgeSymbol: FluentIcons.Important
            }
            PersonPicture {
                displayName: "Casey Ng"
                size: 48
                badgeVisible: true
                badgeSeverity: 3
                badgeValue: 3
            }
            PersonPicture {
                displayName: "Riley Fox"
                size: 56
                isOutOfOffice: true
            }
            CheckBox {
                text: qsTr("IsOutOfOffice (demo)")
                checked: oofDemo.isOutOfOffice
                onToggled: oofDemo.isOutOfOffice = checked
            }
            PersonPicture {
                id: oofDemo
                displayName: "Morgan Yu"
                size: 48
                isOutOfOffice: true
            }
            PersonPicture {
                displayName: "Avery Kim"
                size: 56
                badgeVisible: true
                badgeSeverity: 0
                badgeValue: 128
                badgeMaxValue: 99
            }
            PersonPicture {
                displayName: "Taylor Kim"
                size: 48
                badgeVisible: true
                badgeText: "NEW"
                badgeSeverity: 2
            }
            PersonPicture {
                displayName: ""
                size: 48
                selected: true
            }
            PersonPicture {
                displayName: qsTr("Design team")
                size: 48
                isGroup: true
            }
            PersonPicture {
                displayName: ""
                size: 48
                isGroup: true
                badgeVisible: true
                badgeSeverity: 1
            }
            PersonPicture {
                profilePicture: "data:image/svg+xml," + encodeURIComponent(
                    '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64">'
                    + '<rect width="64" height="64" fill="#0078D4"/>'
                    + '<text x="32" y="40" text-anchor="middle" fill="white" font-size="22" font-family="Segoe UI">AR</text>'
                    + '</svg>')
                size: 48
                badgeVisible: true
                badgeImageSource: "data:image/svg+xml," + encodeURIComponent(
                    '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16">'
                    + '<circle cx="8" cy="8" r="8" fill="#107C10"/>'
                    + '</svg>')
            }
            PersonPicture {
                displayName: ""
                size: 48
                enabled: false
                badgeVisible: true
                badgeSeverity: 3
            }
        }
    }
}

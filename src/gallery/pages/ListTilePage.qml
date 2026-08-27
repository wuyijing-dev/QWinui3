import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — ListTile.

CatalogPage {
    title: qsTr("ListTile")
    subtitle: qsTr("Density + leading presets. List row with symbol / avatar / checkbox.")

    ControlExample {
        headerText: qsTr("Rows")
        qmlSource: "ListTile {\n    title: \"Mail\"\n    symbol: FluentIcons.Mail\n    isSelected: true\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            ListTile {
                title: qsTr("Mail")
                description: qsTr("2 unread messages")
                symbol: FluentIcons.Mail
                showChevron: true
                isSelected: true
            }
            ListTile {
                title: qsTr("Alex Rivera")
                description: qsTr("Available")
                leading: PersonPicture {
                    displayName: "Alex Rivera"
                    size: 36
                    badgeVisible: true
                    badgeSeverity: 1
                }
                Switch { checked: true }
            }
            ListTile {
                title: qsTr("Storage")
                description: qsTr("12 GB free of 128 GB")
                symbol: FluentIcons.Folder
                InfoBadge { value: 3 }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Density + leading presets")
        qmlSource: "ListTile {\n    density: \"compact\"\n    leadingPreset: \"avatar\"\n    avatarName: \"Alex\"\n}"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            ListTile {
                title: qsTr("Compact icon")
                subtitle: qsTr("density: compact")
                symbol: FluentIcons.Mail
                density: "compact"
            }
            ListTile {
                title: qsTr("Normal avatar")
                subtitle: qsTr("leadingPreset: avatar")
                density: "normal"
                leadingPreset: "avatar"
                avatarName: qsTr("Jordan Lee")
            }
            ListTile {
                title: qsTr("Spacious checkbox")
                subtitle: qsTr("density: spacious · leadingPreset: checkbox")
                density: "spacious"
                leadingPreset: "checkbox"
                checkable: true
                checked: true
            }
        }
    }
}

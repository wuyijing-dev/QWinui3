import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — PagerControl.

CatalogPage {
    title: qsTr("PagerControl")
    subtitle: qsTr("Numbered page navigation with previous / next.")

    ControlExample {
        headerText: qsTr("Browse pages")
        qmlSource: "PagerControl {\n    numberOfPages: 12\n    selectedIndex: 0\n}"
        ColumnLayout {
            spacing: Theme.spacing
            Label {
                text: qsTr("Page %1 of %2").arg(pager.selectedIndex + 1).arg(pager.numberOfPages)
                color: Theme.textSecondary
            }
            PagerControl {
                id: pager
                numberOfPages: 12
                selectedIndex: 2
                maxVisiblePages: 7
            }
            CheckBox {
                text: qsTr("Wrap")
                checked: pager.wrap
                onToggled: pager.wrap = checked
            }
        }
    }
}

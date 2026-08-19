import QtQuick
import QtQuick.Layouts
import QWinUI3.Theme
import QWinUI3.Extras

// DataTableFilterOverlay — lightweight filter UI for DataTable.
//
// @notes
//   DataTable already provides filterText/filterPlaceholder/filterDebounceMs.
//   This component gives a ready-to-use filter bar that binds those properties.

ColumnLayout {
    id: root

    // Target DataTable instance.
    property var dataTable: null

    // Placeholder for the filter input.
    property string filterPlaceholder: dataTable && dataTable.filterPlaceholder
                                        ? dataTable.filterPlaceholder
                                        : qsTr("Filter rows")

    property bool showMatchCount: true

    // Content slot (usually a DataTable).
    default property alias contentData: body.data
    Item {
        id: body
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    SearchBoxRecipe {
        id: search
        Layout.fillWidth: true

        model: [] // suggestions off; we only use query typing + clear.
        placeholderText: root.filterPlaceholder

        // Bind input <-> DataTable.filterText
        text: root.dataTable ? root.dataTable.filterText : ""

        onTextChanged: {
            if (!root.dataTable)
                return
            // Avoid unnecessary writes.
            if (root.dataTable.filterText !== text)
                root.dataTable.filterText = text
        }

        onCleared: {
            if (root.dataTable)
                root.dataTable.filterText = ""
        }
    }

    Text {
        visible: root.showMatchCount && root.dataTable
        Layout.fillWidth: true
        color: Theme.textSecondary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontCaption

        text: root.dataTable.rowCount + " " + qsTr("rows match")
    }
}


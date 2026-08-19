"""Python port of src/gallery/DemoTreeModel.cpp — QML type DemoTreeModel."""

from __future__ import annotations

from qwinui3 import _qt

_qt.init()

QStandardItem = _qt.QtGui.QStandardItem
QStandardItemModel = _qt.QtGui.QStandardItemModel
QmlElement = _qt.QmlElement

QML_IMPORT_NAME = "QWinUI3.Gallery"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
class DemoTreeModel(QStandardItemModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setColumnCount(1)
        self.setHorizontalHeaderLabels([self.tr("Name")])

        documents = QStandardItem(self.tr("Documents"))
        projects = QStandardItem(self.tr("Projects"))
        qwinui = QStandardItem(self.tr("QWinUI3"))
        pictures = QStandardItem(self.tr("Pictures"))
        downloads = QStandardItem(self.tr("Downloads"))

        projects.appendRow(qwinui)
        documents.appendRow(projects)
        documents.appendRow(pictures)
        self.invisibleRootItem().appendRow(documents)
        self.invisibleRootItem().appendRow(downloads)

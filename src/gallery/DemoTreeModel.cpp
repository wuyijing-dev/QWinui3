#include "DemoTreeModel.h"

#include <QStandardItem>

DemoTreeModel::DemoTreeModel(QObject *parent)
    : QStandardItemModel(parent)
{
    setColumnCount(1);
    setHorizontalHeaderLabels({ tr("Name") });

    auto *documents = new QStandardItem(tr("Documents"));
    auto *projects = new QStandardItem(tr("Projects"));
    auto *qwinui = new QStandardItem(tr("QWinUI3"));
    auto *pictures = new QStandardItem(tr("Pictures"));
    auto *downloads = new QStandardItem(tr("Downloads"));

    projects->appendRow(qwinui);
    documents->appendRow(projects);
    documents->appendRow(pictures);
    invisibleRootItem()->appendRow(documents);
    invisibleRootItem()->appendRow(downloads);
}

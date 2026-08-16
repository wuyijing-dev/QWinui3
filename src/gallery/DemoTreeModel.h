#pragma once

#include <QStandardItemModel>
#include <QtQml/qqmlregistration.h>

// Small folder-style tree for Gallery TreeView demos (expand / collapse).
class DemoTreeModel : public QStandardItemModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit DemoTreeModel(QObject *parent = nullptr);
};

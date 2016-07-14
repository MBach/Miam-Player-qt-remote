#include "lastconnectionsmodel.h"

#include <QSettings>

#include <QtDebug>

LastConnectionsModel::LastConnectionsModel(QObject *parent)
	: QStringListModel(parent)
{
	QSettings settings;
	QList<QVariant> lastHosts = settings.value("lastHosts").toList();
	QStringList l;
	for (QVariant v : lastHosts) {
		l << v.toString();
	}
	setStringList(l);
}

QHash<int, QByteArray> LastConnectionsModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[IpRole] = "ip";
	roles[DateRole] = "date";
	return roles;
}

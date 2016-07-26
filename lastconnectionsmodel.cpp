#include "lastconnectionsmodel.h"

#include <QDate>
#include <QHostAddress>
#include <QNetworkInterface>
#include <QSettings>
#include <QUdpSocket>

#include <QtDebug>

LastConnectionsModel::LastConnectionsModel(QObject *parent)
	: QStandardItemModel(parent)
{
	this->reloadModel();
}

QHash<int, QByteArray> LastConnectionsModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[HostNameRole] = "host";
	roles[IpRole] = "ip";
	roles[DateRole] = "date";
	return roles;
}

void LastConnectionsModel::addConnection(const QString &hostName, const QString &ip)
{
	QSettings settings;
	QMap<QString, QVariant> lastHosts = settings.value("lastHosts").toMap();

	// Exising IP -> update hostName and date
	QList<QVariant> values;
	if (lastHosts.contains(ip)) {
		values.append(hostName);
		values.append(QDate::currentDate().toString(Qt::SystemLocaleLongDate));
	} else {
		values = lastHosts.value(ip).toList();
		values.append(hostName);
		values.append(QDate::currentDate().toString(Qt::SystemLocaleLongDate));
	}
	qDebug() << Q_FUNC_INFO << ip << values;
	QVariant v(values);
	lastHosts.insert(ip, v);
	settings.setValue("lastHosts", lastHosts);

	this->reloadModel();
}

void LastConnectionsModel::removeConnection(const QString &ip)
{
	QSettings settings;
	QMap<QString, QVariant> lastHosts = settings.value("lastHosts").toMap();
	lastHosts.remove(ip);
	settings.setValue("lastHosts", lastHosts);
	this->reloadModel();
}

void LastConnectionsModel::reloadModel()
{
	this->removeRows(0, this->rowCount());

	QMap<QString, QVariant> lastHosts = QSettings().value("lastHosts").toMap();
	QMapIterator<QString, QVariant> it(lastHosts);
	while (it.hasNext()) {
		it.next();
		QList<QVariant> values = it.value().toList();
		QStandardItem *item = new QStandardItem(values.at(0).toString());
		item->setData(it.key(), IpRole);
		item->setData(values.at(1), DateRole);
		qDebug() << Q_FUNC_INFO << item->data(Qt::DisplayRole).toString() << item->data(IpRole).toString() << item->data(DateRole).toString();
		this->appendRow(item);
	}
}

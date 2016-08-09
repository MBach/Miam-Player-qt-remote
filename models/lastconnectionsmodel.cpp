#include "lastconnectionsmodel.h"

#include <QDate>
#include <QHostAddress>
#include <QNetworkInterface>
#include <QSettings>
#include <QUdpSocket>

LastConnectionsModel::LastConnectionsModel(QObject *parent)
	: QStandardItemModel(parent)
{
	this->reloadModel();
}

QHash<int, QByteArray> LastConnectionsModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[HostNameRole] = "host";
	roles[IpRole] = "ip";
	roles[ReadableDateRole] = "date";
	roles[IsoDateRole] = "isoDate";
	return roles;
}

void LastConnectionsModel::addConnection(const QString &hostName, const QString &ip)
{
	QSettings settings;
	QMap<QString, QVariant> lastHosts = settings.value("lastHosts").toMap();

	// Exising IP -> update hostName, date and ISO date
	QList<QVariant> values;
	if (lastHosts.contains(ip)) {
		values.append(hostName);
		values.append(QDate::currentDate().toString(Qt::SystemLocaleLongDate));
		values.append(QDate::currentDate().toString(Qt::ISODate));
	} else {
		values = lastHosts.value(ip).toList();
		values.append(hostName);
		values.append(QDate::currentDate().toString(Qt::SystemLocaleLongDate));
		values.append(QDate::currentDate().toString(Qt::ISODate));
	}

	QVariant v(values);
	lastHosts.insert(ip, v);
	settings.setValue("lastHosts", lastHosts);

	this->reloadModel();
}

QString LastConnectionsModel::lastConnectionIP() const
{
	QMap<QString, QVariant> lastHosts = QSettings().value("lastHosts").toMap();
	QMapIterator<QString, QVariant> it(lastHosts);
	QDate maxDate(1, 1, 1);
	QString ip;
	while (it.hasNext()) {
		it.next();
		QList<QVariant> values = it.value().toList();
		QDate d = values.at(2).toDate();
		if (d > maxDate) {
			maxDate = d;
			ip = it.key();
		}
	}
	return ip;
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
		item->setData(values.at(1), ReadableDateRole);
		item->setData(values.at(2), IsoDateRole);
		this->appendRow(item);
	}
}

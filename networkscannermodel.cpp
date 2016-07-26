#include "networkscannermodel.h"

#include <QHostAddress>
#include <QNetworkInterface>
#include <QSettings>
#include <QUdpSocket>

#include <QtDebug>

NetworkScannerModel::NetworkScannerModel(QObject *parent)
	: QStringListModel(parent)
{
	QString serverIp = "192.168.0.1";
	QStringList l;
	l << serverIp;
	setStringList(l);
	qDebug() << Q_FUNC_INFO << l;
}

QHash<int, QByteArray> NetworkScannerModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[HostNameRole] = "host";
	roles[IpRole] = "ip";
	roles[DateRole] = "date";
	return roles;
}

void NetworkScannerModel::scanNetwork()
{
	qDebug() << Q_FUNC_INFO;

	// Fetch own address IP
	QString ip;
	for (const QHostAddress &address : QNetworkInterface::allAddresses()) {
		if (address.protocol() == QAbstractSocket::IPv4Protocol && address != QHostAddress(QHostAddress::LocalHost)) {
			ip = address.toString();
			break;
		}
	}

	QByteArray datagram;
	datagram.append(ip);

	QUdpSocket *udpSocket = new QUdpSocket(this);
	uint port = QSettings().value("port", 5600).toUInt();
	//udpSocket->writeDatagram(datagram.data(), datagram.size(), QHostAddress::Broadcast, port);

	connect(udpSocket, &QUdpSocket::readyRead, this, [=]() {
		qDebug() << Q_FUNC_INFO << "I've received a response from server, yay";
		if (udpSocket->hasPendingDatagrams()) {
			QByteArray datagram;
			datagram.resize(udpSocket->pendingDatagramSize());
			udpSocket->readDatagram(datagram.data(), datagram.size());
			qDebug() << Q_FUNC_INFO << "The server told me his IP address:" << datagram.toStdString().data();
		}
	});

	QString serverIp = "192.168.0.1";
	//emit serverFound(serverIp);

	QStringList l;
	l << serverIp;
	setStringList(l);

	qDebug() << Q_FUNC_INFO << l;
}

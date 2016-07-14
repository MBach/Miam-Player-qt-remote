#include "remoteclient.h"

#include <QHostAddress>
#include <QSettings>

#include <QtDebug>

RemoteClient::RemoteClient(QObject *parent)
	: QObject(parent)
	, _socket(new QTcpSocket(this))
	, _isConnecting(false)
{
	_in.setDevice(_socket);
	_in.setVersion(QDataStream::Qt_5_6);

	connect(_socket, &QTcpSocket::stateChanged, this, [=](QAbstractSocket::SocketState state) {
		if (QAbstractSocket::ConnectedState == state) {
			qDebug() << "About to receive data from Host";
			QSettings settings;
			QList<QVariant> hosts = settings.value("lastHosts").toList();
			QString ip = _socket->peerAddress().toString();
			if (!hosts.contains(ip)) {
				hosts.append(ip);
				settings.setValue("lastHosts", hosts);
			}
			_isConnecting = false;
		} else if (QAbstractSocket::ConnectingState == state) {
			_isConnecting = true;
		} else {
			_isConnecting = false;
		}
	});
	connect(_socket, &QTcpSocket::readyRead, this, [=]() {
		_in.startTransaction();

		QString greetings;
		_in >> greetings;
		qDebug() << "QTcpSocket::readyRead" << greetings;

		if (!_in.commitTransaction()) {
			return;
		}

	});
}

void RemoteClient::ipAddressFilled(const QString &ip)
{
	qDebug() << Q_FUNC_INFO << ip;
	QHostAddress hostAddress(ip);
	bool ok = false;
	hostAddress.toIPv4Address(&ok);
	if (ok) {
		QSettings settings;
		uint port = settings.value("port", 5600).toUInt();
		qDebug() << Q_FUNC_INFO << "Connecting to" << hostAddress.toString() << ":" << port;
		if (_socket->state() == QTcpSocket::ConnectingState) {
			qDebug() << Q_FUNC_INFO << "But first, a previous connection is still pending. Trying to close it!";
			_socket->disconnectFromHost();
		}
		_socket->connectToHost(hostAddress, port, QTcpSocket::ReadWrite);
	} else {
		qDebug() << Q_FUNC_INFO << "Your IP cannot be processed!";
	}
}

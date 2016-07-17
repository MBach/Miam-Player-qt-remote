#include "remoteclient.h"

#include <QHostAddress>
#include <QMediaPlayer>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QSettings>

#include <QtDebug>

RemoteClient::RemoteClient(CoverProvider *coverProvider, QObject *parent)
	: QObject(parent)
	, _coverProvider(coverProvider)
	, _socket(new QTcpSocket(this))
	, _isConnecting(false)
{
	connect(_socket, &QTcpSocket::stateChanged, this, &RemoteClient::socketStateChanged);
	connect(_socket, &QIODevice::readyRead, this, &RemoteClient::socketReadyRead);
}

void RemoteClient::socketStateChanged(QAbstractSocket::SocketState state)
{
	qDebug() << Q_FUNC_INFO << state;
	if (QAbstractSocket::ConnectedState == state) {
		qDebug() << "About to receive data from Host" << _socket->peerName();
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
}

void RemoteClient::socketReadyRead()
{
	QDataStream in;
	in.setDevice(_socket);
	in.startTransaction();

	int command;
	QByteArray message;
	in >> command;
	in >> message;

	if (!in.commitTransaction()) {
		qDebug() << Q_FUNC_INFO << "cannot read?" << command << message;
		return;
	}

	switch (command) {
	case CMD_Player:
		qDebug() << Q_FUNC_INFO << "cmd:player";
		// Nothing
		break;
	case CMD_State: {
		qDebug() << Q_FUNC_INFO << "cmd:state";
		QMediaPlayer::State state = (QMediaPlayer::State)(message.toInt());
		switch (state) {
		case QMediaPlayer::PlayingState:
		case QMediaPlayer::StoppedState:
			emit playing();
			break;
		case QMediaPlayer::PausedState:
			emit paused();
			break;
		}
		break;
	}
	case CMD_Track:
		qDebug() << Q_FUNC_INFO << "cmd:track";
		break;
	case CMD_Volume:
		qDebug() << Q_FUNC_INFO << "cmd:volume";
		break;
	case CMD_Connection:
		qDebug() << Q_FUNC_INFO << "cmd:connect";
		emit aboutToDisplayGreetings(QString::fromStdString(message.toStdString()));
		break;
	case CMD_Cover:
		qDebug() << Q_FUNC_INFO << "cmd:cover";
		_coverProvider->generateCover(message);
		break;
	default:
		qDebug() << Q_FUNC_INFO << "warning, cmd not found from client" << command;
		break;
	}
}

void RemoteClient::establishConnectionToServer(const QString &ip)
{
	QHostAddress hostAddress(ip);
	bool ok = false;
	hostAddress.toIPv4Address(&ok);
	if (ok) {
		QSettings settings;
		uint port = settings.value("port", 5600).toUInt();
		if (_socket->state() == QTcpSocket::ConnectingState) {
			// A previous connection is still pending. Trying to close it!
			_socket->disconnectFromHost();
		}
		_socket->connectToHost(hostAddress, port, QTcpSocket::ReadWrite);
	} else {
		qDebug() << Q_FUNC_INFO << "Your IP cannot be processed!";
	}
}

void RemoteClient::sendCommandToServer(const QString &command)
{
	QByteArray data;
	QDataStream out(&data, QIODevice::ReadWrite);
	out << CMD_Player;
	out << QByteArray::fromStdString(command.toStdString());
	qint64 r = _socket->write(data);
	qDebug() << Q_FUNC_INFO << command << ", bytes written" << r;
	bool b = _socket->flush();
	qDebug() << Q_FUNC_INFO << "flush:" << b;
}

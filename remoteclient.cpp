#include "remoteclient.h"

#include <QDateTime>
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
	, _isConnected(false)
{
	_socket->open(QIODevice::ReadWrite);
	connect(_socket, &QTcpSocket::stateChanged, this, &RemoteClient::socketStateChanged);
	connect(_socket, &QIODevice::readyRead, this, &RemoteClient::socketReadyRead);
}

void RemoteClient::requestActivePlaylists()
{
	QByteArray data;
	QDataStream out(&data, QIODevice::ReadWrite);
	out.setVersion(QDataStream::Qt_5_5);
	out << CMD_ActivePlaylists;
	out << QString();
	_socket->write(data);
}

void RemoteClient::requestAllPlaylists()
{
	QByteArray data;
	QDataStream out(&data, QIODevice::ReadWrite);
	out.setVersion(QDataStream::Qt_5_5);
	out << CMD_AllPlaylists;
	out << QString();
	_socket->write(data);
}

void RemoteClient::socketStateChanged(QAbstractSocket::SocketState state)
{
	switch (state) {
	case QAbstractSocket::ConnectedState: {
		QSettings settings;
		QList<QVariant> hosts = settings.value("lastHosts").toList();
		QString ip = _socket->peerAddress().toString();
		if (!hosts.contains(ip)) {
			hosts.append(ip);
			settings.setValue("lastHosts", hosts);
		}
		_isConnecting = false;
		_isConnected = true;
		break;
	}
	case QAbstractSocket::HostLookupState:
	case QAbstractSocket::ConnectingState:
		_isConnecting = true;
		_isConnected = false;
		break;
	case QAbstractSocket::UnconnectedState:
		_isConnecting = false;
		_isConnected = false;
		emit connectionFailed();
		break;
	default:
		break;
	}
}

void RemoteClient::socketReadyRead()
{
	//qDebug() << Q_FUNC_INFO << "bytesAvailable:" << _socket->bytesAvailable() << "sizeof(Command)" << sizeof(Command);
	QDataStream in;
	in.setDevice(_socket);
	in.setVersion(QDataStream::Qt_5_5);
	int command;
	in >> command;

	switch (command) {
	case CMD_Playback:
		qDebug() << Q_FUNC_INFO << "cmd:playback";
		// Nothing
		break;
	case CMD_State: {
		QString message;
		in >> message;
		qDebug() << Q_FUNC_INFO << "cmd:state" << message;
		if (message == "paused") {
			emit paused();
		} else if (message == "playing"){
			emit playing();
		} else {
			emit stopped();
		}
		break;
	}
	case CMD_Track: {
		qDebug() << Q_FUNC_INFO << "cmd:track";
		QString uri, artistAlbum, album, title, trackNumber;
		int stars;
		in >> uri;
		in >> artistAlbum;
		in >> album;
		in >> title;
		in >> trackNumber;
		in >> stars;
		qDebug() << Q_FUNC_INFO << "cmd:track" << uri << artistAlbum << album << title << trackNumber << stars;
		emit aboutToUpdateTrack(title, album, artistAlbum, stars);
		break;
	}
	case CMD_Position: {
		qint64 pos, duration;
		in >> pos;
		in >> duration;
		qreal ratio = (qreal)pos / (qreal)duration;

		uint t = round(duration / 1000);
		QString formattedTime = QDateTime::fromTime_t(pos / 1000).toString("mm:ss").append(" / ").append(QDateTime::fromTime_t(t).toString("mm:ss"));


		emit progressChanged(ratio, formattedTime);
		break;
	}
	case CMD_Volume: {
		QByteArray message;
		in >> message;
		qreal v = QString::fromStdString(message.toStdString()).toFloat();
		qDebug() << Q_FUNC_INFO << "cmd:volume" << v;
		emit aboutToUpdateVolume(v);
		break;
	}
	case CMD_Connection: {
		QString hostName;
		in >> hostName;
		qDebug() << Q_FUNC_INFO << "cmd:connect" << hostName << _socket->peerAddress() << _socket->peerName();
		/// TODO detect from message in with mode are we (playlists vs unique)
		emit connectionSucceded(hostName, _socket->peerAddress().toString());
		break;
	}
	case CMD_Cover: {
		qDebug() << Q_FUNC_INFO << "cmd:cover";
		int coverSize;
		in >> coverSize;
		qDebug() << Q_FUNC_INFO << "coverSize" << coverSize << "_socket->bytesAvailable()" << _socket->bytesAvailable();

		if (coverSize > _socket->bytesAvailable()) {
			qDebug() << Q_FUNC_INFO << "we didn't receive enough bytes to display cover! Waiting...";
			//_socket->readAll();
			//return;
			_socket->waitForReadyRead(1000);
			qDebug() << Q_FUNC_INFO << "coverSize" << coverSize << "_socket->bytesAvailable()" << _socket->bytesAvailable();
		}
		QByteArray message;
		in >> message;
		_coverProvider->generateCover(message);
		emit newCoverReceived(qrand());
		break;
	}
	case CMD_AllPlaylists: {
		int count;
		in >> count;
		QStringList playlists;
		for (int i = 0; i < count; i++) {
			QString title;
			in >> title;
			playlists << title;
		}
		emit aboutToSendPlaylists(playlists);
		break;
	}
	default:
		qDebug() << Q_FUNC_INFO << "warning, cmd not found from client" << command;
		qDebug() << Q_FUNC_INFO << _socket->errorString();
		break;
	}

	// Recursive call
	if (_socket->bytesAvailable()) {
		qDebug() << Q_FUNC_INFO << "there is more to read!";
		socketReadyRead();
	}
}

void RemoteClient::establishConnectionToServer(const QString &ip)
{
	if (_isConnecting) {
		return;
	}
	QHostAddress hostAddress(ip);
	bool ok = false;
	hostAddress.toIPv4Address(&ok);
	if (ok) {
		uint port = QSettings().value("port", 5600).toUInt();
		if (_socket->state() == QTcpSocket::ConnectingState) {
			// A previous connection is still pending. Trying to close it!
			_socket->disconnectFromHost();
		}
		_socket->connectToHost(hostAddress, port, QTcpSocket::ReadWrite);
	}
}

void RemoteClient::sendPlaybackCommand(const QString &command)
{
	QByteArray data;
	QDataStream out(&data, QIODevice::ReadWrite);
	out << CMD_Playback;
	out << QByteArray::fromStdString(command.toStdString());
	qint64 r = _socket->write(data);
	qDebug() << Q_FUNC_INFO << command << ", bytes written" << r;
}

void RemoteClient::setPosition(qreal p)
{
	QByteArray data;
	QDataStream out(&data, QIODevice::ReadWrite);
	out.setVersion(QDataStream::Qt_5_5);
	out << CMD_Position;
	QByteArray ba;
	ba.append(QString::number(p));
	out << ba;
	_socket->write(data);
}

void RemoteClient::setVolume(qreal v)
{
	QByteArray data;
	QDataStream out(&data, QIODevice::ReadWrite);
	out.setVersion(QDataStream::Qt_5_5);
	out << CMD_Volume;
	QByteArray ba;
	ba.append(QString::number(v));
	out << ba;
	_socket->write(data);
}

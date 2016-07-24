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
	out.setVersion(QDataStream::Qt_5_7);
	out << CMD_ActivePlaylists;
	out << QString();
	_socket->write(data);
}

void RemoteClient::requestAllPlaylists()
{
	QByteArray data;
	QDataStream out(&data, QIODevice::ReadWrite);
	out.setVersion(QDataStream::Qt_5_7);
	out << CMD_AllPlaylists;
	out << QString();
	_socket->write(data);
}

void RemoteClient::setVolume(qreal v)
{
	QByteArray data;
	QDataStream out(&data, QIODevice::ReadWrite);
	out.setVersion(QDataStream::Qt_5_7);
	out << CMD_Volume;
	QByteArray ba;
	ba.append(reinterpret_cast<const char*>(&v), sizeof(v));
	out << ba;
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

#include "trackdao.h"

void RemoteClient::socketReadyRead()
{
	//qDebug() << Q_FUNC_INFO << "bytesAvailable:" << _socket->bytesAvailable() << "sizeof(Command)" << sizeof(Command);
	QDataStream in;
	in.setDevice(_socket);
	in.setVersion(QDataStream::Qt_5_7);
	int command;
	in >> command;

	//qDebug() << Q_FUNC_INFO << "command:" << command;

	switch (command) {
	case CMD_Playback:
		qDebug() << Q_FUNC_INFO << "cmd:playback";
		// Nothing
		break;
	case CMD_State: {
		qDebug() << Q_FUNC_INFO << "cmd:state";
		QByteArray message;
		in >> message;
		QMediaPlayer::State state = (QMediaPlayer::State)(message.toInt());
		//int state = s.toInt();
		//in >> state;
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
	case CMD_Track: {
		qDebug() << Q_FUNC_INFO << "cmd:track";
		//QDataStream ds(message);
		/*int daoSize;
		in >> daoSize;
		if (daoSize > _socket->bytesAvailable()) {
			qDebug() << Q_FUNC_INFO << "we don't have enough data to create a TrackDao!";
		}*/
		QString uri, artistAlbum, album, title, trackNumber;
		//TrackDAO track;
		//in >> track;
		//qDebug() << Q_FUNC_INFO << "decoded track" << track.uri() << track.artistAlbum() << track.album() << track.title();
		in >> uri;
		in >> artistAlbum;
		in >> album;
		in >> title;
		in >> trackNumber;
		qDebug() << Q_FUNC_INFO << "decoded track" << uri << artistAlbum << album << title << trackNumber;

		break;
	}
	case CMD_Volume: {
		QByteArray message;
		in >> message;
		qreal v = QString::fromStdString(message.toStdString()).toFloat();
		//qreal v = *reinterpret_cast<const qreal*>(message.data());
		qDebug() << Q_FUNC_INFO << "cmd:volume" << v;
		emit aboutToUpdateVolume(v);
		break;
	}
	case CMD_Connection: {
		qDebug() << Q_FUNC_INFO << "cmd:connect";
		QByteArray message;
		in >> message;
		//emit aboutToDisplayGreetings(QString::fromStdString(message.toStdString()));

		/// TODO detect from message in with mode are we (playlists vs unique)

		emit connectionSucceded();
		break;
	}
	case CMD_Cover: {
		qDebug() << Q_FUNC_INFO << "cmd:cover";
		int coverSize;
		in >> coverSize;
		qDebug() << Q_FUNC_INFO << "coverSize" << coverSize << "_socket->bytesAvailable()" << _socket->bytesAvailable();

		if (coverSize > _socket->bytesAvailable()) {
			//qDebug() << Q_FUNC_INFO << "we don't received enough bytes to display cover! Waiting...";
			_socket->readAll();
			return;
			//_socket->waitForReadyRead(1000);
			//qDebug() << Q_FUNC_INFO << "coverSize" << coverSize << "_socket->bytesAvailable()" << _socket->bytesAvailable();
		}
		QByteArray message;
		in >> message;
		_coverProvider->generateCover(message);
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
	} else {
		qDebug() << Q_FUNC_INFO << "Your IP cannot be processed!";
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

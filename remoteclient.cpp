#include "remoteclient.h"

#include <QDateTime>
#include <QHostAddress>
#include <QMediaPlayer>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QSettings>

RemoteClient::RemoteClient(CoverProvider *coverProvider, QObject *parent)
	: QObject(parent)
	, _coverProvider(coverProvider)
	, _socket(new QWebSocket("remote", QWebSocketProtocol::VersionLatest, this))
	, _isConnecting(false)
	, _isConnected(false)
{
	connect(_socket, &QWebSocket::stateChanged, this, &RemoteClient::socketStateChanged);
	connect(_socket, &QWebSocket::binaryMessageReceived, this, &RemoteClient::processBinaryMessage);
	connect(_socket, &QWebSocket::textMessageReceived, this, &RemoteClient::processTextMessage);
}

void RemoteClient::requestActivePlaylists()
{
	QStringList args = { QString::number(CMD_ActivePlaylists), QString() };
	_socket->sendTextMessage(args.join(QChar::Null));
}

void RemoteClient::requestAllPlaylists()
{
	QStringList args = { QString::number(CMD_AllPlaylists), QString() };
	_socket->sendTextMessage(args.join(QChar::Null));
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

void RemoteClient::processBinaryMessage(const QByteArray &message)
{
	_coverProvider->generateCover(message);
	emit newCoverReceived(qrand());
}

void RemoteClient::processTextMessage(const QString &message)
{
	if (message.isEmpty()) {
		return;
	}

	QStringList list = message.split(QChar::Null);
	if (list.size() <= 1) {
		return;
	}

	int command = list.first().toInt();
	switch (command) {
	case CMD_Playback:
		// Nothing
		break;
	case CMD_State: {
		QMediaPlayer::State state = (QMediaPlayer::State) list.at(1).toInt();
		if (state == QMediaPlayer::PlayingState) {
			emit playing();
		} else if (state == QMediaPlayer::PausedState) {
			emit paused();
		} else {
			emit stopped();
		}
		break;
	}
	case CMD_Track: {
		QString uri, artistAlbum, album, title, trackNumber;
		int stars;
		if (list.size() != 7) {
			return;
		}

		int i = 0;
		uri = list.at(++i);
		artistAlbum = list.at(++i);
		album = list.at(++i);
		title = list.at(++i);
		trackNumber = list.at(++i);
		stars = list.at(++i).toInt();
		if (stars < 0) {
			stars = 0;
		}
		emit aboutToUpdateTrack(title, album, artistAlbum, stars);
		break;
	}
	case CMD_Volume: {
		qreal v = list.at(1).toFloat();
		emit aboutToUpdateVolume(v);
		break;
	}
	case CMD_Connection: {
		QString hostName = list.at(1);
		/// TODO detect from message in with mode are we (playlists vs unique)
		emit connectionSucceded(hostName, _socket->peerAddress().toString());
		break;
	}
	case CMD_Position: {
		qint64 pos, duration;
		pos = list.at(1).toLongLong();
		duration = list.at(2).toLongLong();
		qreal ratio = (qreal)pos / (qreal)duration;

		uint t = round(duration / 1000);
		QString formattedTime = QDateTime::fromTime_t(pos / 1000).toString("mm:ss").append(" / ").append(QDateTime::fromTime_t(t).toString("mm:ss"));

		emit progressChanged(ratio, formattedTime);
		break;
	}
	case CMD_AllPlaylists: {
		list.removeFirst();
		emit allPlaylistsReceived(list);
		break;
	}
	case CMD_ActivePlaylists: {
		list.removeFirst();
		emit activePlaylistsReceived(list);
		break;
	}
	case CMD_LoadActivePlaylist: {
		/*int trackCount, playlistSize;
		in >> trackCount;
		in >> playlistSize;

		if (playlistSize > _socket->bytesAvailable()) {
			_socket->waitForReadyRead(1000);
		}


		QStringList tracks;
		QList<QByteArray> t = incomingBuffer.split('\0');
		for (QByteArray b : t) {
			qDebug() << "splitting" << QString(b);
			tracks << QString(b);
		}

		QStringList tracks;
		for (int i = 0; i < trackCount; i++) {
			QString title, trackNumber, album, artistAlbum, year, rating;
			//int rating;
			in >> title;
			in >> trackNumber;
			in >> album;
			in >> artistAlbum;
			in >> year;
			in >> rating;
			tracks << title << trackNumber << album << artistAlbum << year << rating;
		}
		emit activePlaylistReceived(tracks);*/
		break;
	}
	default:
		break;
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
			_socket->close();
		}
		_socket->open(QUrl("ws://" + hostAddress.toString() + ":" + QString::number(port)));
	}
}

void RemoteClient::loadActivePlaylist(int index)
{
	QStringList args = { QString::number(CMD_LoadActivePlaylist), QString::number(index) };
	_socket->sendTextMessage(args.join(QChar::Null));
}

void RemoteClient::sendPlaybackCommand(const QString &command)
{
	QStringList args = { QString::number(CMD_Playback), command };
	_socket->sendTextMessage(args.join(QChar::Null));
}

void RemoteClient::setPosition(qreal p)
{
	QStringList args = { QString::number(CMD_Position), QString::number(p) };
	_socket->sendTextMessage(args.join(QChar::Null));
}

void RemoteClient::setVolume(qreal v)
{
	QStringList args = { QString::number(CMD_Volume), QString::number(v) };
	_socket->sendTextMessage(args.join(QChar::Null));
}

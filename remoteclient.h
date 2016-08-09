#ifndef REMOTECLIENT_H
#define REMOTECLIENT_H

#include <QDataStream>
#include <QWebSocket>

#include "coverprovider.h"

/**
 * \brief		The RemoteClient class is used to managed bidirectionnal connection and commands.
 * \details
 * \author      Matthieu Bachelier
 * \copyright   GNU General Public License v3
 */
class RemoteClient : public QObject
{
    Q_OBJECT
	Q_ENUMS(Command)
	Q_PROPERTY(bool _isConnecting READ isConnecting)

private:
	CoverProvider *_coverProvider;

	QWebSocket *_socket;

	bool _isConnecting;
	bool _isConnected;

public:
	enum Command : int {	CMD_Playback			= 0,
							CMD_State				= 1,
							CMD_Track				= 2,
							CMD_Volume				= 3,
							CMD_Connection			= 4,
							CMD_Cover				= 5,
							CMD_Position			= 6,
							CMD_ActivePlaylists		= 7,
							CMD_AllPlaylists		= 8,
							CMD_LoadActivePlaylist	= 9};

	explicit RemoteClient(CoverProvider *coverProvider, QObject *parent = 0);

	Q_INVOKABLE inline bool isConnecting() const { return _isConnecting; }

	Q_INVOKABLE inline bool isConnected() const { return _isConnected; }

	void requestActivePlaylists();

	void requestAllPlaylists();

private slots:

	void socketStateChanged(QAbstractSocket::SocketState state);

	void processBinaryMessage(const QByteArray &message);

	void processTextMessage(const QString &message);

public slots:
	void establishConnectionToServer(const QString& ip);

	void loadActivePlaylist(int index);

	void sendPlaybackCommand(const QString &command);

	void setPosition(qreal p);

	void setVolume(qreal v);

signals:
	void aboutToUpdateTrack(const QString &title, const QString &album, const QString &artist, int stars);
	void aboutToUpdateVolume(qreal volume);
	void activePlaylistsReceived(const QStringList &playlists);
	void activePlaylistReceived(const QStringList &tracks);
	void allPlaylistsReceived(const QStringList &playlists);
	void connectionSucceded(const QString &hostName, const QString &ip);
	void connectionFailed();
	void newCoverReceived(int random);
	void paused();
	void playing();
	void stopped();
	void progressChanged(qreal progress, const QString &formattedTime);
};

#endif // REMOTECLIENT_H

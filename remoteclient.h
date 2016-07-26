#ifndef REMOTECLIENT_H
#define REMOTECLIENT_H

#include <QDataStream>
#include <QTcpSocket>

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

	QTcpSocket *_socket;

	bool _isConnecting;
	bool _isConnected;

public:
	enum Command : int {	CMD_Playback		= 0,
							CMD_State			= 1,
							CMD_Track			= 2,
							CMD_Volume			= 3,
							CMD_Connection		= 4,
							CMD_Cover			= 5,
							CMD_ActivePlaylists	= 7,
							CMD_AllPlaylists	= 6};

	explicit RemoteClient(CoverProvider *coverProvider, QObject *parent = 0);

	Q_INVOKABLE inline bool isConnecting() const { return _isConnecting; }

	inline bool isConnected() const { return _isConnected; }

	void requestActivePlaylists();

	void requestAllPlaylists();

private slots:

	void socketStateChanged(QAbstractSocket::SocketState state);

	void socketReadyRead();

public slots:
	void establishConnectionToServer(const QString& ip);

	void sendPlaybackCommand(const QString &command);

	void setVolume(qreal v);

signals:
	void aboutToUpdateVolume(qreal volume);
	void aboutToSendPlaylists(const QStringList &playlists);
	void connectionSucceded(const QString &hostName, const QString &ip);
	void connectionFailed();
	void playing();
	void paused();
};

#endif // REMOTECLIENT_H

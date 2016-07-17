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
	Q_PROPERTY(bool isConnecting READ isConnecting NOTIFY connectingChanged)

private:
	CoverProvider *_coverProvider;

	QTcpSocket *_socket;

	bool _isConnecting;

public:
	enum Command : int {	CMD_Player		= 0,
							CMD_State		= 1,
							CMD_Track		= 2,
							CMD_Volume		= 3,
							CMD_Connection	= 4,
							CMD_Cover		= 5};

	explicit RemoteClient(CoverProvider *coverProvider, QObject *parent = 0);

	inline bool isConnecting() const { return _isConnecting; }

private slots:
	void socketStateChanged(QAbstractSocket::SocketState state);

	void socketReadyRead();

public slots:
	void establishConnectionToServer(const QString& ip);

	void sendCommandToServer(const QString &command);

signals:
	void connectingChanged();
	void aboutToDisplayGreetings(const QVariant &greetings);
	void playing();
	void paused();
};

#endif // REMOTECLIENT_H

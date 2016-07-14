#ifndef REMOTECLIENT_H
#define REMOTECLIENT_H

#include <QDataStream>
#include <QTcpSocket>

class RemoteClient : public QObject
{
    Q_OBJECT

	Q_PROPERTY(bool isConnecting READ isConnecting NOTIFY connectingChanged)

private:
	QTcpSocket *_socket;

	QDataStream _in;

	bool _isConnecting;

public:
    explicit RemoteClient(QObject *parent = 0);

	inline bool isConnecting() const { return _isConnecting; }

public slots:
    void ipAddressFilled(const QString& ip);

signals:
	void connectingChanged();
};

#endif // REMOTECLIENT_H

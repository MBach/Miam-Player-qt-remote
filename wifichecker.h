#ifndef WIFICHECKER_H
#define WIFICHECKER_H

#include <QObject>
#include <QNetworkConfigurationManager>

class WifiChecker : public QObject
{
	Q_OBJECT
private:
	QNetworkConfigurationManager _manager;

public:
	explicit WifiChecker(QObject *parent = 0);

	Q_INVOKABLE bool isOk() const;

private slots:
	void checkConfiguration(const QNetworkConfiguration &);

signals:
	void closeStartupPopup();
};

#endif // WIFICHECKER_H

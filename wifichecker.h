#ifndef WIFICHECKER_H
#define WIFICHECKER_H

#include <QNetworkConfigurationManager>

/**
 * \brief		The WifiChecker class checks if one has WiFi enabled and can switch on through the JNI.
 * \author		Matthieu Bachelier
 * \copyright   GNU General Public License v3
 */
class WifiChecker : public QObject
{
	Q_OBJECT
private:
	QNetworkConfigurationManager _manager;

public:
	/** Default constructor. */
	explicit WifiChecker(QObject *parent = 0);

	/** Checks if WiFi is activated on the device. */
	Q_INVOKABLE bool isOk() const;

public slots:
	/** This slot makes a call to the JNI to activate WiFi. */
	void enableWifi();

private slots:
	/** When a network interface state changes, check if it's the one for WiFi. */
	void checkConfiguration(const QNetworkConfiguration &);

signals:
	/** Closes the modal popup on startup. */
	void closeStartupPopup();
};

#endif // WIFICHECKER_H

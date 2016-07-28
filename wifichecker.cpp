#include "wifichecker.h"

#if defined(Q_OS_ANDROID)
#include <QtAndroidExtras/QAndroidJniObject>
#endif

/** Default constructor. */
WifiChecker::WifiChecker(QObject *parent)
	: QObject(parent)
{
	connect(&_manager, &QNetworkConfigurationManager::configurationAdded, this, &WifiChecker::checkConfiguration);
}

/** Checks if WiFi is activated on the device. */
bool WifiChecker::isOk() const
{
	QList<QNetworkConfiguration> actives = _manager.allConfigurations(QNetworkConfiguration::Active);
	for (QNetworkConfiguration config : actives) {
		if (config.bearerType() == QNetworkConfiguration::BearerWLAN) {
			return true;
		}
	}
	return _manager.isOnline();
}

/** This slot makes a call to the JNI to activate WiFi. */
void WifiChecker::enableWifi()
{
#if defined(Q_OS_ANDROID)
	QAndroidJniObject::callStaticMethod<void>("org/miamplayer/remote/utils/WifiActivator",
											  "activate",
											  "()V");
#endif
}

/** When a network interface state changes, check if it's the one for WiFi. */
void WifiChecker::checkConfiguration(const QNetworkConfiguration &)
{
	if (this->isOk()) {
		emit closeStartupPopup();
	}
}

#include "wifichecker.h"

#include <QtDebug>

WifiChecker::WifiChecker(QObject *parent)
	: QObject(parent)
{
	connect(&_manager, &QNetworkConfigurationManager::configurationAdded, this, &WifiChecker::checkConfiguration);
}

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

void WifiChecker::checkConfiguration(const QNetworkConfiguration &)
{
	if (this->isOk()) {
		emit closeStartupPopup();
	}
}

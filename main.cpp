#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#define COMPANY "MmeMiamMiam"
#define SOFT "MiamPlayerRemote"
#define VERSION "0.1"

#include "models/lastconnectionsmodel.h"
#include "models/networkscannermodel.h"
#include "models/playlistmanagermodel.h"
#include "models/playlistmodel.h"
#include "coverprovider.h"
#include "mediaplayercontrol.h"
#include "remoteclient.h"
#include "wifichecker.h"

#include <QQuickStyle>
#include <QTranslator>

int main(int argc, char *argv[])
{
	QGuiApplication::setOrganizationName(COMPANY);
	QGuiApplication::setApplicationName(SOFT);
	QGuiApplication::setApplicationVersion(VERSION);
	QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	// Register some classes first
	qmlRegisterType<PlaylistManagerModel>("org.miamplayer.remote", 1, 0, "PlaylistManagerModel");
	qmlRegisterType<PlaylistModel>("org.miamplayer.remote", 1, 0, "PlaylistModel");
	qmlRegisterType<NetworkScannerModel>("org.miamplayer.remote", 1, 0, "NetworkScannerModel");

	// Translate the UI
	QGuiApplication app(argc, argv);

	QString language = QLocale::system().uiLanguages().first().left(2);
	QTranslator playerTranslator;
	/*bool b =*/ playerTranslator.load(":/translations/miam-player-remote_" + language + ".qm");
	/*bool c =*/ QGuiApplication::installTranslator(&playerTranslator);
	//qDebug() << Q_FUNC_INFO << language << b << c;

	QQuickStyle::setStyle("Material");
	QQmlApplicationEngine engine;
	CoverProvider *coverProvider = new CoverProvider;
	RemoteClient remoteClient(coverProvider);
	LastConnectionsModel lastConnectionsModel;
	MediaPlayerControl mediaPlayerControl(&remoteClient);
	WifiChecker wifiChecker;

	engine.rootContext()->setContextProperty("wifiChecker", &wifiChecker);
	engine.rootContext()->setContextProperty("lastConnectionsModel", &lastConnectionsModel);
	engine.rootContext()->setContextProperty("remoteClient", &remoteClient);
	engine.rootContext()->setContextProperty("mediaPlayerControl", &mediaPlayerControl);
	engine.addImageProvider(QString("coverprovider"), coverProvider);

	QObject::connect(&engine, &QQmlApplicationEngine::quit, qApp, &QCoreApplication::quit);

	engine.load(QUrl("qrc:/pages/mainPage"));
	return app.exec();
}

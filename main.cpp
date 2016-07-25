#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#define COMPANY "MmeMiamMiam"
#define SOFT "MiamPlayerRemote"
#define VERSION "0.1"

#include "coverprovider.h"
#include "lastconnectionsmodel.h"
#include "mediaplayercontrol.h"
#include "playlistmanagermodel.h"
#include "remoteclient.h"
#include "wifichecker.h"
#include "trackdao.h"

#include <QQuickStyle>
#include <QTranslator>

#include <QtDebug>

int main(int argc, char *argv[])
{
    QGuiApplication::setOrganizationName(COMPANY);
    QGuiApplication::setApplicationName(SOFT);
    QGuiApplication::setApplicationVersion(VERSION);
	QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	// Register some classes first
	qRegisterMetaType<GenericDAO>();
	qRegisterMetaType<TrackDAO>();
	qRegisterMetaTypeStreamOperators<TrackDAO>("TrackDAO");
	qmlRegisterType<PlaylistManagerModel>("org.miamplayer.remote", 1, 0, "PlaylistManagerModel");

	// Translate the UI
    QGuiApplication app(argc, argv);
	QString language = QLocale::system().uiLanguages().first().left(2);
	QTranslator playerTranslator;
	bool b = playerTranslator.load(":/translations/miam-player-remote_" + language + ".qm");
	bool c = QGuiApplication::installTranslator(&playerTranslator);
	qDebug() << Q_FUNC_INFO << language << b << c;

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

	engine.load(QUrl("qrc:/pages/mainPage"));
    return app.exec();
}

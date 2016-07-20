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

int main(int argc, char *argv[])
{
    QGuiApplication::setOrganizationName(COMPANY);
    QGuiApplication::setApplicationName(SOFT);
    QGuiApplication::setApplicationVersion(VERSION);
	QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	qRegisterMetaType<GenericDAO>();
	qRegisterMetaType<TrackDAO>();
	qRegisterMetaTypeStreamOperators<TrackDAO>("TrackDAO");

    QGuiApplication app(argc, argv);

	QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine;
	CoverProvider *coverProvider = new CoverProvider;
	RemoteClient remoteClient(coverProvider);
	LastConnectionsModel lastConnectionsModel;
	MediaPlayerControl mediaPlayerControl(&remoteClient);
	WifiChecker wifiChecker;
	PlaylistManagerModel playlistManagerModel;
	engine.rootContext()->setContextProperty("wifiChecker", &wifiChecker);
	engine.rootContext()->setContextProperty("lastConnectionsModel", &lastConnectionsModel);
	engine.rootContext()->setContextProperty("remoteClient", &remoteClient);
	engine.rootContext()->setContextProperty("mediaPlayerControl", &mediaPlayerControl);
	engine.rootContext()->setContextProperty("playlistManagerModel", &playlistManagerModel);
	engine.addImageProvider(QString("coverprovider"), coverProvider);

	engine.load(QUrl("qrc:/pages/mainPage"));

    return app.exec();
}

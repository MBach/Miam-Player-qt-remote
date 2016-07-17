#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#define COMPANY "MmeMiamMiam"
#define SOFT "MiamPlayerRemote"
#define VERSION "0.1"

#include "lastconnectionsmodel.h"
#include "mediaplayercontrol.h"
#include "remoteclient.h"
#include "coverprovider.h"

#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication::setOrganizationName(COMPANY);
    QGuiApplication::setApplicationName(SOFT);
    QGuiApplication::setApplicationVersion(VERSION);
	QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

	QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/miamplayer-remote.qml"));

	CoverProvider *coverProvider = new CoverProvider;
	RemoteClient remoteClient(coverProvider);
	LastConnectionsModel lastConnectionsModel;
	MediaPlayerControl mediaPlayerControl(&remoteClient);
	engine.rootContext()->setContextProperty("lastConnectionsModel", &lastConnectionsModel);
	engine.rootContext()->setContextProperty("remoteClient", &remoteClient);
	engine.rootContext()->setContextProperty("mediaPlayerControl", &mediaPlayerControl);
	engine.addImageProvider(QLatin1String("coverprovider"), coverProvider);

    return app.exec();
}

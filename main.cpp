#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#define COMPANY "MmeMiamMiam"
#define SOFT "MiamPlayerRemote"
#define VERSION "0.1"

#include "lastconnectionsmodel.h"
#include "remoteclient.h"

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

    RemoteClient remoteClient;
	LastConnectionsModel lastConnectionsModel;
	engine.rootContext()->setContextProperty("remoteClient", &remoteClient);
	engine.rootContext()->setContextProperty("lastConnectionsModel", &lastConnectionsModel);

    return app.exec();
}

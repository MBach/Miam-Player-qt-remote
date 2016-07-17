#include "mediaplayercontrol.h"

#include <QtDebug>

MediaPlayerControl::MediaPlayerControl(RemoteClient *remoteClient, QObject *parent)
	: QObject(parent)
	, _remoteClient(remoteClient)
{

}

void MediaPlayerControl::previous()
{
	_remoteClient->sendCommandToServer("skip-backward");
}

void MediaPlayerControl::playPause()
{
	_remoteClient->sendCommandToServer("play-pause");
}

void MediaPlayerControl::next()
{
	_remoteClient->sendCommandToServer("skip-forward");
}

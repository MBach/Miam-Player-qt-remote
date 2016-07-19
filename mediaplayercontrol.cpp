#include "mediaplayercontrol.h"

#include <QtDebug>

MediaPlayerControl::MediaPlayerControl(RemoteClient *remoteClient, QObject *parent)
	: QObject(parent)
	, _remoteClient(remoteClient)
{

}

void MediaPlayerControl::previous()
{
	_remoteClient->sendPlaybackCommand("skip-backward");
}

void MediaPlayerControl::playPause()
{
	_remoteClient->sendPlaybackCommand("play-pause");
}

void MediaPlayerControl::next()
{
	_remoteClient->sendPlaybackCommand("skip-forward");
}

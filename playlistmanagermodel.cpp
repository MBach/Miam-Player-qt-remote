#include "playlistmanagermodel.h"

PlaylistManagerModel::PlaylistManagerModel(QObject *parent)
	: QStringListModel(parent)
{
	QStringList l;
	setStringList(l);
}

void PlaylistManagerModel::requestAllPlaylists(RemoteClient *remoteClient)
{
	if (remoteClient && remoteClient->isConnected()) {
		remoteClient->requestAllPlaylists();
	}
}

void PlaylistManagerModel::requestActivePlaylists(RemoteClient *remoteClient)
{
	if (remoteClient && remoteClient->isConnected()) {
		remoteClient->requestActivePlaylists();
	}
}

void PlaylistManagerModel::updateModel(const QStringList &playlists)
{
	setStringList(playlists);
}

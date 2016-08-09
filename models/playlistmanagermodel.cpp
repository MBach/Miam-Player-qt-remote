#include "playlistmanagermodel.h"

PlaylistManagerModel::PlaylistManagerModel(QObject *parent)
	: QStandardItemModel(parent)
{
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

QHash<int, QByteArray> PlaylistManagerModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[Qt::DisplayRole] = "name";
	return roles;
}

void PlaylistManagerModel::updateModel(const QStringList &playlists)
{
	this->removeRows(0, this->rowCount());

	for (QString playlist : playlists) {
		QStandardItem *item = new QStandardItem(playlist);
		this->appendRow(item);
	}
}

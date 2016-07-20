#include "playlistmanagermodel.h"

PlaylistManagerModel::PlaylistManagerModel(QObject *parent)
	: QStringListModel(parent)
{
	QStringList l;
	l << "Playlist 1" << "Playlist 2" << "Playlist 3" << "Playlist 4" << "Playlist 5";
	setStringList(l);
}

#ifndef PLAYLISTMANAGERMODEL_H
#define PLAYLISTMANAGERMODEL_H

#include <QStringListModel>
#include "remoteclient.h"

class PlaylistManagerModel : public QStringListModel
{
	Q_OBJECT
public:
	explicit PlaylistManagerModel(QObject *parent = 0);

	Q_INVOKABLE void requestAllPlaylists(RemoteClient *remoteClient);

public slots:
	void updateModel(const QStringList &playlists);
};

#endif // PLAYLISTMANAGERMODEL_H

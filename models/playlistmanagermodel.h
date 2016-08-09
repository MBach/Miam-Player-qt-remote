#ifndef PLAYLISTMANAGERMODEL_H
#define PLAYLISTMANAGERMODEL_H

#include <QStandardItemModel>
#include "remoteclient.h"

/**
 * \brief		The PlaylistManagerModel class
 * \author		Matthieu Bachelier
 * \copyright   GNU General Public License v3
 */
class PlaylistManagerModel : public QStandardItemModel
{
	Q_OBJECT
public:
	explicit PlaylistManagerModel(QObject *parent = 0);

	Q_INVOKABLE void requestAllPlaylists(RemoteClient *remoteClient);

	Q_INVOKABLE void requestActivePlaylists(RemoteClient *remoteClient);

	virtual QHash<int, QByteArray> roleNames() const override;

public slots:
	void updateModel(const QStringList &playlists);
};

#endif // PLAYLISTMANAGERMODEL_H

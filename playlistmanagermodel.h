#ifndef PLAYLISTMANAGERMODEL_H
#define PLAYLISTMANAGERMODEL_H

#include <QStringListModel>

class PlaylistManagerModel : public QStringListModel
{
	Q_OBJECT
public:
	explicit PlaylistManagerModel(QObject *parent = 0);
};

#endif // PLAYLISTMANAGERMODEL_H

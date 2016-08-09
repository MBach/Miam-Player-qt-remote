#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QStandardItemModel>

class PlaylistModel : public QStandardItemModel
{
	Q_OBJECT
public:
	explicit PlaylistModel(QObject *parent = nullptr);

	virtual QHash<int, QByteArray> roleNames() const override;

public slots:
	void updateModel(const QStringList &tracks);
};

#endif // PLAYLISTMODEL_H

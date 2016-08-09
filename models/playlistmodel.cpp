#include "playlistmodel.h"

PlaylistModel::PlaylistModel(QObject *parent)
	: QStandardItemModel(parent)
{

}

QHash<int, QByteArray> PlaylistModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[Qt::DisplayRole] = "title";
	roles[Qt::UserRole + 1] = "trackNumber";
	roles[Qt::UserRole + 2] = "artist";
	roles[Qt::UserRole + 3] = "album";
	roles[Qt::UserRole + 4] = "album";
	roles[Qt::UserRole + 5] = "album";
	return roles;
}

void PlaylistModel::updateModel(const QStringList &tracks)
{
	this->removeRows(0, this->rowCount());

	for (int i = 0; i < tracks.count(); i++) {
		QStandardItem *item = new QStandardItem(tracks.at(i++));
		item->setData(tracks.at(i++), Qt::UserRole + 1);
		item->setData(tracks.at(i++), Qt::UserRole + 2);
		item->setData(tracks.at(i++), Qt::UserRole + 3);
		item->setData(tracks.at(i++), Qt::UserRole + 4);
		item->setData(tracks.at(i), Qt::UserRole + 5);
		this->appendRow(item);
	}
}

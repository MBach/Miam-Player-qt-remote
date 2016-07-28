#ifndef LASTCONNECTIONSMODEL_H
#define LASTCONNECTIONSMODEL_H

#include <QStandardItemModel>

/**
 * \brief		The LastConnectionsModel class manages successful connections to a server.
 * \author		Matthieu Bachelier
 * \copyright   GNU General Public License v3
 */
class LastConnectionsModel : public QStandardItemModel
{
	Q_OBJECT
public:
	explicit LastConnectionsModel(QObject *parent = 0);

	enum CustomRoles {
		HostNameRole		= Qt::DisplayRole,
		IpRole				= Qt::UserRole + 1,
		ReadableDateRole	= Qt::UserRole + 2,
		IsoDateRole			= Qt::UserRole + 3
	};

	virtual QHash<int, QByteArray> roleNames() const override;

	Q_INVOKABLE void addConnection(const QString &hostName, const QString &ip);

	Q_INVOKABLE QString lastConnectionIP() const;

	Q_INVOKABLE void removeConnection(const QString &ip);

private:
	void reloadModel();
};

#endif // LASTCONNECTIONSMODEL_H

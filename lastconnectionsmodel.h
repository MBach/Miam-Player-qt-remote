#ifndef LASTCONNECTIONSMODEL_H
#define LASTCONNECTIONSMODEL_H

#include <QStandardItemModel>

class LastConnectionsModel : public QStandardItemModel
{
	Q_OBJECT
public:
	explicit LastConnectionsModel(QObject *parent = 0);

	enum CustomRoles {
		HostNameRole	= Qt::DisplayRole,
		IpRole			= Qt::UserRole + 1,
		DateRole		= Qt::UserRole + 2
	};

	virtual QHash<int, QByteArray> roleNames() const override;

	Q_INVOKABLE void addConnection(const QString &hostName, const QString &ip);

	Q_INVOKABLE void removeConnection(const QString &ip);

private:
	void reloadModel();
};

#endif // LASTCONNECTIONSMODEL_H

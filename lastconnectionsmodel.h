#ifndef LASTCONNECTIONSMODEL_H
#define LASTCONNECTIONSMODEL_H

#include <QStringListModel>

class LastConnectionsModel : public QStringListModel
{
	Q_OBJECT
public:
	explicit LastConnectionsModel(QObject *parent = 0);

	enum AnimalRoles {
		IpRole   = Qt::DisplayRole,
		DateRole
	};

	virtual QHash<int, QByteArray> roleNames() const override;

	Q_INVOKABLE void removeConnection(const QString &host);
};

#endif // LASTCONNECTIONSMODEL_H

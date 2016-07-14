#ifndef LASTCONNECTIONSMODEL_H
#define LASTCONNECTIONSMODEL_H

#include <QStringListModel>

class LastConnectionsModel : public QStringListModel
{
	Q_OBJECT
public:
	explicit LastConnectionsModel(QObject *parent = 0);

	enum AnimalRoles {
		//IpRole   = Qt::UserRole + 1,
		IpRole   = Qt::DisplayRole,
		DateRole
	};

	virtual QHash<int, QByteArray> roleNames() const override;

signals:

public slots:
};

#endif // LASTCONNECTIONSMODEL_H

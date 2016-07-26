#ifndef NETWORKSCANNERMODEL_H
#define NETWORKSCANNERMODEL_H

#include <QStringListModel>

class NetworkScannerModel : public QStringListModel
{
	Q_OBJECT
public:
	explicit NetworkScannerModel(QObject *parent = 0);

	enum CustomRoles {
		HostNameRole	= Qt::DisplayRole,
		IpRole			= Qt::UserRole + 1,
		DateRole		= Qt::UserRole + 2
	};

	virtual QHash<int, QByteArray> roleNames() const override;

public slots:
	void scanNetwork();

//signals:
//	void serverFound(const QString &server);
};

#endif // NETWORKSCANNERMODEL_H

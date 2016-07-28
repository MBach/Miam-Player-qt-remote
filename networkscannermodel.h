#ifndef NETWORKSCANNERMODEL_H
#define NETWORKSCANNERMODEL_H

#include <QStringListModel>

/**
 * \brief		The NetworkScannerModel class sends a small broadcast and seeks for servers.
 * \author		Matthieu Bachelier
 * \copyright   GNU General Public License v3
 */
class NetworkScannerModel : public QStringListModel
{
	Q_OBJECT
public:
	explicit NetworkScannerModel(QObject *parent = 0);

	enum CustomRoles {
		HostNameRole		= Qt::DisplayRole,
		IpRole				= Qt::UserRole + 1,
		ReadableDateRole	= Qt::UserRole + 2,
		IsoDateRole			= Qt::UserRole + 3
	};

	virtual QHash<int, QByteArray> roleNames() const override;

public slots:
	void scanNetwork();
};

#endif // NETWORKSCANNERMODEL_H

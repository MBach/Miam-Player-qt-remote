#ifndef GENERICDAO_H
#define GENERICDAO_H

#include <QMetaType>
#include <QObject>

namespace Miam
{
	enum ItemType : int
	{
		IT_Artist		= QMetaType::User + 1,
		IT_Album		= QMetaType::User + 2,
		IT_ArtistAlbum	= QMetaType::User + 3,
		IT_Disc			= QMetaType::User + 4,
		IT_Separator	= QMetaType::User + 5,
		IT_Track		= QMetaType::User + 6,
		IT_Year			= QMetaType::User + 7,
		IT_Playlist		= QMetaType::User + 8,
		IT_UnknownType	= QMetaType::User + 9,
		IT_Cover		= QMetaType::User + 10
	};
}

/**
 * \brief		The GenericDAO class is a simple wrapper which contains basic informations about a file.
 * \author		Matthieu Bachelier
 * \copyright   GNU General Public License v3
 */
class GenericDAO : public QObject
{
	Q_OBJECT
private:
	QString _checksum, _host, _icon, _id, _title, _titleNormalized;

	GenericDAO *_parent;

	Miam::ItemType _type;

public:
	explicit GenericDAO(Miam::ItemType itemType = Miam::IT_UnknownType, QObject *parent = nullptr);

	GenericDAO(const GenericDAO &remoteObject);

	GenericDAO& operator=(const GenericDAO& other);

	virtual ~GenericDAO();

	QString checksum() const;
	void setChecksum(const QString &checksum);

	QString host() const;
	void setHost(const QString &host);

	QString icon() const;
	void setIcon(const QString &icon);

	QString id() const;
	void setId(const QString &id);

	void setParentNode(GenericDAO *parentNode);
	GenericDAO* parentNode() const;

	QString title() const;
	void setTitle(const QString &title);

	QString titleNormalized() const;
	void setTitleNormalized(const QString &titleNormalized);

	Miam::ItemType type() const;

	virtual uint hash() const;
};

/** Register this class to convert in QVariant. */
Q_DECLARE_METATYPE(GenericDAO)

#endif // GENERICDAO_H

#ifndef COVERPROVIDER_H
#define COVERPROVIDER_H

#include <QQuickImageProvider>

/**
 * \brief		The CoverProvider class loads remote covers streamed from server.
 * \author		Matthieu Bachelier
 * \copyright   GNU General Public License v3
 */
class CoverProvider : public QQuickImageProvider
{
private:
	bool _hasReceivedRemoteData;
	QByteArray _cover;

public:
	explicit CoverProvider();

	virtual QImage requestImage(const QString &id, QSize *, const QSize &) override;

	void generateCover(const QByteArray &cover);

	virtual ImageType imageType() const override;

};

#endif // COVERPROVIDER_H

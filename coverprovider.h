#ifndef COVERPROVIDER_H
#define COVERPROVIDER_H

#include <QQuickImageProvider>

class CoverProvider : public QQuickImageProvider
{
private:
	bool _hasReceivedRemoteData;
	QByteArray _cover;

public:
	explicit CoverProvider();

	virtual QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

	void generateCover(const QByteArray &cover);
};

#endif // COVERPROVIDER_H

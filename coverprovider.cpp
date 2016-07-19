#include "coverprovider.h"

#include <QtDebug>

CoverProvider::CoverProvider()
	: QQuickImageProvider(QQuickImageProvider::Image)
	, _hasReceivedRemoteData(false)
{

}

QImage CoverProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
	qDebug() << Q_FUNC_INFO << _hasReceivedRemoteData << id;
	if (_hasReceivedRemoteData) {
		_hasReceivedRemoteData = false;
		return QImage::fromData(_cover);
	} else {
		QImage img(":/images/disc.png");
		return img;
	}
}

void CoverProvider::generateCover(const QByteArray &cover)
{
	_hasReceivedRemoteData = true;
	_cover = cover;
}

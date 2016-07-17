#include "coverprovider.h"

#include <QtDebug>

CoverProvider::CoverProvider()
	: QQuickImageProvider(QQuickImageProvider::Image)
	, _hasReceviedRemoteData(false)
{

}

QImage CoverProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
	qDebug() << Q_FUNC_INFO << _hasReceviedRemoteData << id;
	if (_hasReceviedRemoteData) {
		return QImage::fromData(_cover);
	} else {
		QImage img(":/images/disc.png");
		return img;
	}
}

void CoverProvider::generateCover(const QByteArray &cover)
{
	_hasReceviedRemoteData = true;
	_cover = cover;
}

#include "coverprovider.h"

CoverProvider::CoverProvider()
	: QQuickImageProvider(QQuickImageProvider::Image)
	, _hasReceivedRemoteData(false)
{

}

QImage CoverProvider::requestImage(const QString &, QSize *, const QSize &)
{
	//qDebug() << Q_FUNC_INFO << _hasReceivedRemoteData << id;
	if (_hasReceivedRemoteData) {
		_hasReceivedRemoteData = false;
		QImage img = QImage::fromData(_cover);
		_cover.clear();
		if (!img.isNull()) {
			return img;
		}
	}
	QImage img(":/images/disc.png");
	return img;
}

void CoverProvider::generateCover(const QByteArray &cover)
{
	_hasReceivedRemoteData = true;
	_cover = cover;
}

QQmlImageProviderBase::ImageType CoverProvider::imageType() const
{
	return QQmlImageProviderBase::Image;
}

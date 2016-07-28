#ifndef MEDIAPLAYERCONTROL_H
#define MEDIAPLAYERCONTROL_H

#include <QObject>

#include "remoteclient.h"

/**
 * \brief		The MediaPlayerControl class
 * \author		Matthieu Bachelier
 * \copyright   GNU General Public License v3
 */
class MediaPlayerControl : public QObject
{
	Q_OBJECT
private:
	RemoteClient *_remoteClient;

public:
	MediaPlayerControl(RemoteClient *remoteClient, QObject *parent = nullptr);

public slots:
	void previous();

	void playPause();

	void next();
};

#endif // MEDIAPLAYERCONTROL_H

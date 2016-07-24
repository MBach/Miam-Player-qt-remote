import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import org.miamplayer.remote 1.0

Pane {
    id: playlistsPane

    PlaylistManagerModel {
        id: playlistManagerModel
        Component.onCompleted: requestActivePlaylists(remoteClient)
    }

    ListView {
        id: playlistListView
        model: playlistManagerModel
        Layout.fillWidth: true
        Layout.fillHeight: true
        width: parent.width
        height: parent.height
        focus: true
        highlightFollowsCurrentItem: true
        //delegate: itemPlaylistDelegate
        onCurrentIndexChanged: {
            console.log("currentIndexChanged")
        }
        onCurrentSectionChanged: {
            console.log("currentSectionChanged")
        }
    }
}

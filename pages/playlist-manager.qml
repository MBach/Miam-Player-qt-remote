import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import org.miamplayer.remote 1.0

Pane {
    id: playlistManagerPane
    //width: parent.width
    //height: parent.height

    PlaylistManagerModel {
        id: playlistManagerModel
        Component.onCompleted: requestAllPlaylists(remoteClient)
    }

    Component {
        id: itemPlaylistDelegate
        Item {
            width: parent.width
            height: Math.max(50, window.height / 10)
            RowLayout {
                width: parent.width
                Label {
                    text: display
                    width: parent.width - 100
                    anchors.left: parent.left
                    elide: Qt.ElideRight
                }
                Image {
                    id: arrow
                    source: "qrc:/images/navigate_next.png"
                    width: 100
                    anchors.right: parent.right
                }
            }
        }
    }

    ListView {
        id: playlistManagerListView
        model: playlistManagerModel
        Layout.fillWidth: true
        Layout.fillHeight: true
        width: parent.width
        height: parent.height
        focus: true
        highlightFollowsCurrentItem: true
        delegate: itemPlaylistDelegate
        onCurrentIndexChanged: {
            console.log("currentIndexChanged")
        }
        onCurrentSectionChanged: {
            console.log("currentSectionChanged")
        }
    }

    Connections {
        target: remoteClient
        onAboutToSendPlaylists: playlistManagerModel.updateModel(playlists)
    }
}

import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import org.miamplayer.remote 1.0

Pane {
    id: playlistsPane

    PlaylistManagerModel {
        id: playlistManagerModel
        Component.onCompleted: requestActivePlaylists(remoteClient)
    }

    PlaylistModel {
        id: playlistModel
    }

    Component {
        id: itemPlaylistDelegate
        Item {
            width: parent.width
            height: Math.max(50, window.height / 10)
            RowLayout {
                width: parent.width
                Label {
                    text: "Title: '" + title + "'"
                    width: parent.width
                    anchors.left: parent.left
                    elide: Qt.ElideRight
                }
            }
        }
    }

    Component {
          id: highlightComponent
          Rectangle {
              width: 180
              height: 40
              color: "#424242"
              radius: 5
              //y: playlistListView.currentItem.y
              /*Behavior on y {
                  SpringAnimation {
                      spring: 3
                      damping: 0.2
                  }
              }*/
          }
      }

    ColumnLayout {
        id: playlistsColumnLayout
        anchors.fill: parent

        ComboBox {
            id: playlistsComboBox
            model: playlistManagerModel
            z: 2

            anchors.left: playlistsColumnLayout.left
            anchors.right: playlistsColumnLayout.right
        }

        ListView {
            id: playlistListView
            model: playlistModel
            delegate: itemPlaylistDelegate

            /*delegate: Text {
                id: name
                text: title
            }
            highlight: Rectangle {
                color: "#424242"
                border.color: Material.primary
                border.width: 1
            }*/
            highlight: highlightComponent

            anchors.left: playlistsColumnLayout.left
            anchors.right: playlistsColumnLayout.right

            Layout.fillWidth: true
            Layout.fillHeight: true
            width: parent.width
            height: parent.height
            focus: true
            highlightFollowsCurrentItem: true

            ScrollBar.vertical: ScrollBar { }

            MouseArea {
                id: maPlaylist
                anchors.fill: parent
                onClicked: playlistListView.currentIndex = playlistListView.indexAt(mouse.x, mouse.y)
            }
        }
    }

    Connections {
        target: remoteClient
        onActivePlaylistsReceived: {
            playlistManagerModel.updateModel(playlists)
            playlistsComboBox.currentIndex = 0
        }
        onActivePlaylistReceived: {
            playlistModel.updateModel(tracks)
        }
    }
    Connections {
        target: playlistsComboBox
        onCurrentIndexChanged: {
            console.log("Replace view with contents from playlist: " + playlistsComboBox.currentIndex)
            remoteClient.loadActivePlaylist(playlistsComboBox.currentIndex)
        }
    }
}

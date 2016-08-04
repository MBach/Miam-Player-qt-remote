import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import QtQuick.Controls.Material 2.0

Pane {
    id: remoteLandscape
    padding: 0

    property int starCount: 5

    // 4 layouts for 2 display modes

    // Mode: Portrait
    ColumnLayout {
        id: portraitColumnLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: undefined

        Label {
            id: volumeLabel
            text: qsTr("Volume")
            padding: 8

            horizontalAlignment: Text.AlignHCenter

            anchors.top: portraitColumnLayout.top
            anchors.left: portraitColumnLayout.left
            anchors.right: portraitColumnLayout.right
            anchors.bottom: undefined

            Layout.fillWidth: true
            Layout.fillHeight: false
        }

        Slider {
            id: volumeSlider
            orientation: Qt.Horizontal
            padding: 8

            anchors.top: volumeLabel.bottom
            anchors.left: portraitColumnLayout.left
            anchors.right: portraitColumnLayout.right
            anchors.bottom: undefined

            Layout.topMargin: 0
            Layout.leftMargin: 0
            Layout.fillWidth: true
            Layout.fillHeight: false

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        Label {
            id: titleTrackLabel
            elide: Text.ElideRight
            font.bold: true
            text: "Title Track"
            padding: 8

            anchors.top: volumeSlider.bottom
            anchors.left: portraitColumnLayout.left
            anchors.right: portraitColumnLayout.right
            anchors.bottom: undefined

            Layout.fillWidth: true
            Layout.fillHeight: false
        }

        Label {
            id: albumArtistLabel
            elide: Text.ElideRight
            text: "Album - Artist"
            padding: 8

            anchors.top: titleTrackLabel.bottom
            anchors.left: portraitColumnLayout.left
            anchors.right: portraitColumnLayout.right
            anchors.bottom: undefined

            Layout.fillWidth: true
            Layout.fillHeight: false
        }

        Rectangle {
            id: itemCover
            Layout.preferredHeight: 200
            Layout.preferredWidth: 200

            anchors.top: albumArtistLabel.bottom
            anchors.left: portraitColumnLayout.left
            anchors.right: portraitColumnLayout.right
            anchors.bottom: undefined

            Layout.fillWidth: true
            Layout.fillHeight: false

            color: "#424242"

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Image {
                id: cover
                fillMode: Image.PreserveAspectFit
                anchors.fill: itemCover
                source: "image://coverprovider/default"

                // DEBUG
                MouseArea {
                    id: maCover
                    anchors.fill: parent
                    onClicked: {
                        isPortrait = !isPortrait
                        var w = window.width
                        var h = window.height
                        window.height = w
                        window.width = h
                    }
                }
            }
        }

        Rectangle {
            id: rectStarOpacity

            anchors.top: undefined
            anchors.bottom: itemCover.bottom
            anchors.left: portraitColumnLayout.left
            anchors.right: portraitColumnLayout.right

            Layout.fillWidth: true
            Layout.fillHeight: false

            height: itemCover.height / 10
            color: Material.background
            z: 2
            opacity: 0.5

            // TODO
            RowLayout {
                id: starColumnLayout

                //anchors.top: rectStarOpacity.top
                //anchors.bottom: rectStarOpacity.bottom
                //anchors.left: cover.left
                //anchors.right: cover.right
                anchors.centerIn: parent
                width: cover.width / 2
                Repeater {
                    model: starCount
                    Image {
                        id: starImage
                        source: "qrc:/images/star.png"
                        //anchors.centerIn: parent
                        height: starColumnLayout.height
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }


        }

        Label {
            id: progressLabel
            text: qsTr("Progress")
            padding: 8
            horizontalAlignment: Text.AlignHCenter

            anchors.top: itemCover.bottom
            anchors.left: portraitColumnLayout.left
            anchors.right: portraitColumnLayout.right
            anchors.bottom: undefined

            Layout.fillWidth: true
            Layout.fillHeight: false
        }

        Slider {
            id: progressSlider
            Layout.fillWidth: true
            Layout.fillHeight: false

            anchors.top: progressLabel.bottom
            anchors.left: portraitColumnLayout.left
            anchors.right: portraitColumnLayout.right
            anchors.bottom: undefined

            orientation: Qt.Horizontal
        }
    }

    RowLayout {
        id: portraitRowLayout
        anchors.top: undefined
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Image {
            id: previous
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/previous.png"

            Layout.fillWidth: true
            Layout.fillHeight: false

            anchors.top: undefined
            anchors.left: portraitRowLayout.left
            anchors.right: undefined
            anchors.bottom: portraitRowLayout.bottom

            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

            MouseArea {
                id: maPrevious
                anchors.fill: parent
                onClicked: {
                    mediaPlayerControl.previous()
                }
            }

            ColorOverlay {
                id: colorOverlayPrevious
                anchors.fill: previous
                source: previous
                color: "transparent"
            }

            states: [
                State {
                    when: maPrevious.pressed
                    PropertyChanges {
                        target: colorOverlayPrevious
                        color: Material.color(Material.Purple)
                    }
                }
            ]

            transitions: Transition {
                ColorAnimation {
                    from: Material.color(Material.Purple)
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }
        }

        Image {
            id: playPause
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/play.png"

            Layout.fillWidth: true
            Layout.fillHeight: false

            anchors.top: undefined
            anchors.left: undefined
            anchors.right: undefined
            anchors.bottom: portraitRowLayout.bottom

            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            MouseArea {
                id: maPlayPause
                anchors.fill: parent
                onClicked: {
                    mediaPlayerControl.playPause()
                }
            }

            /*ColorOverlay {
                id: colorOverlayPlayPause
                anchors.fill: playPause
                source: playPause
                color: "transparent"
            }

            states: [
                State {
                    when: maPlayPause.pressed
                    PropertyChanges {
                        target: colorOverlayPlayPause
                        color: Material.color(Material.Purple)
                    }
                }
            ]

            transitions: Transition {
                ColorAnimation {
                    from: Material.color(Material.Purple)
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }*/
        }

        Image {
            id: next
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/next.png"

            Layout.fillWidth: true
            Layout.fillHeight: false

            anchors.top: undefined
            anchors.left: undefined
            anchors.right: portraitRowLayout.right
            anchors.bottom: portraitRowLayout.bottom

            Layout.alignment: Qt.AlignRight | Qt.AlignBottom

            MouseArea {
                id: maNext
                anchors.fill: parent
                onClicked: mediaPlayerControl.next()
            }

            ColorOverlay {
                id: colorOverlayNext
                anchors.fill: next
                source: next
                color: "transparent"
            }

            states: [
                State {
                    when: maNext.pressed
                    PropertyChanges {
                        target: colorOverlayNext
                        color: Material.color(Material.Purple)
                    }
                }
            ]

            transitions: Transition {
                ColorAnimation {
                    from: Material.color(Material.Purple)
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }
        }


    }

    // Mode: Landscape
    RowLayout {
        id: landscapeRowLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: undefined
        anchors.bottom: parent.bottom
    }

    ColumnLayout {
        id: landscapeColumnLayout
        anchors.top: parent.top
        anchors.left: landscapeRowLayout.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    // Connections
    Connections {
        target: volumeSlider
        onValueChanged: {
            remoteClient.setVolume(volumeSlider.value)
        }
    }

    Connections {
        target: progressSlider
        onValueChanged: {
            remoteClient.setPosition(progressSlider.value)
        }
    }

    Connections {
        target: remoteClient
        onAboutToUpdateTrack: {
            titleTrackLabel.text = title
            albumArtistLabel.text = album + " – " + artist
            if (stars > 0) {
                rectStarOpacity.opacity = 0.5
                //starsLabel.text = "Soon, " + stars + " stars will be displayed"
            } else {
                rectStarOpacity.opacity = 0
            }
            starCount = stars
        }

        onAboutToUpdateVolume: {
            volumeLabel.text = String(Number(Math.round(volume * 100).toFixed(2))) + " %"
            volumeSlider.value = volume
        }
        onPlaying: playPause.source = "qrc:/images/play.png"
        onPaused: playPause.source = "qrc:/images/pause.png"
        onStopped: cover.source = "image://coverprovider/default"
        onProgressChanged: {
            progressLabel.text = formattedTime
            progressSlider.value = progress
        }
        onNewCoverReceived: {
            cover.source = "image://coverprovider/" + random
        }
    }

    states: [

        // Landscape
        State {
            name: "landscape"
            when: !window.isPortrait

            PropertyChanges {
                target: portraitColumnLayout
                visible: false
            }
            PropertyChanges {
                target: portraitRowLayout
                visible: false
            }

            PropertyChanges {
                target: landscapeColumnLayout
                visible: true
            }
            PropertyChanges {
                target: landscapeRowLayout
                visible: true
            }

            PropertyChanges {
                target: volumeLabel
                parent: landscapeRowLayout
                visible: false

                anchors.top: undefined
                anchors.left: undefined
                anchors.right: undefined
                anchors.bottom: undefined
            }

            PropertyChanges {
                target: volumeSlider
                parent: landscapeRowLayout

                Layout.topMargin: 0
                Layout.leftMargin: 8
                Layout.fillHeight: true
                Layout.fillWidth: false

                anchors.top: landscapeRowLayout.top
                anchors.left: landscapeRowLayout.left
                anchors.right: undefined
                anchors.bottom: landscapeRowLayout.bottom

                orientation: Qt.Vertical
            }

            PropertyChanges {
                target: itemCover
                parent: landscapeRowLayout

                Layout.fillWidth: true
                Layout.fillHeight: true

                anchors.top: landscapeRowLayout.top
                anchors.left: volumeSlider.right
                anchors.right: undefined
                anchors.bottom: landscapeRowLayout.bottom

                Layout.preferredHeight: 200
                Layout.preferredWidth: 200
            }

            PropertyChanges {
                target: progressLabel
                parent: landscapeRowLayout
                visible: false

                anchors.top: undefined
                anchors.left: undefined
                anchors.right: undefined
                anchors.bottom: undefined
            }

            PropertyChanges {
                target: progressSlider
                parent: landscapeRowLayout

                Layout.fillWidth: false
                Layout.fillHeight: true

                anchors.top: landscapeRowLayout.top
                anchors.left: itemCover.right
                anchors.right: undefined
                anchors.bottom: landscapeRowLayout.bottom

                orientation: Qt.Vertical
            }

            PropertyChanges {
                target: next
                parent: landscapeColumnLayout

                Layout.fillWidth: false
                Layout.fillHeight: true

                anchors.top: landscapeColumnLayout.top
                anchors.left: undefined
                anchors.right: landscapeColumnLayout.right
                anchors.bottom: undefined

                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
            }

            PropertyChanges {
                target: playPause
                parent: landscapeColumnLayout

                Layout.fillWidth: false
                Layout.fillHeight: true

                anchors.top: undefined
                anchors.left: undefined
                anchors.right: landscapeColumnLayout.right
                anchors.bottom: undefined

                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
            }

            PropertyChanges {
                target: previous
                parent: landscapeColumnLayout

                Layout.fillWidth: false
                Layout.fillHeight: true

                anchors.top: undefined
                anchors.left: undefined
                anchors.right: landscapeColumnLayout.right
                anchors.bottom: landscapeColumnLayout.bottom

                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
            }
        }
    ]
}

import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import QtQuick.Controls.Material 2.0

Pane {
    id: remoteLandscape

    //width: 588
    //height: 278
    //bottomPadding: 0
    //rightPadding: 0
    //leftPadding: 0
    //topPadding: 0

    GridLayout {
        id: gridLayout1
        columns: 4
        rows: 3
        anchors.fill: parent

        Slider {
            id: volumeSlider
            Layout.rowSpan: 3
            Layout.columnSpan: 1
            Layout.fillHeight: true
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            orientation: Qt.Vertical
            value: 0.5
        }

        Item {
            id: itemCover
            Layout.rowSpan: 3
            Layout.columnSpan: 1
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            Layout.preferredHeight: 200
            Layout.preferredWidth: 200
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                id: cover
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                source: "image://coverprovider/default"
            }
        }

        Slider {
            id: progressSlider
            Layout.rowSpan: 3
            Layout.columnSpan: 1
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            Layout.fillHeight: true
            orientation: Qt.Vertical
            value: 0.5
        }

        Image {
            id: next
            Layout.columnSpan: 1
            Layout.rowSpan: 1
            anchors.top: parent.top
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 100
            Layout.preferredWidth: 100
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/next.png"

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

        Image {
            id: playPause
            Layout.columnSpan: 1
            Layout.rowSpan: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 100
            Layout.preferredWidth: 100
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/play.png"

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
            id: previous
            Layout.columnSpan: 1
            Layout.rowSpan: 1
            anchors.bottom: parent.bottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 100
            Layout.preferredWidth: 100
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/previous.png"

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
    }

    Connections {
        target: volumeSlider
        onValueChanged: {
            remoteClient.setVolume(volumeSlider.value)
        }
    }
    Connections {
        target: remoteClient
        onAboutToUpdateVolume: {
            volumeSlider.value = volume
        }
        onPlaying: playPause.source = "qrc:/images/play.png"
        onPaused: playPause.source = "qrc:/images/pause.png"
        onStopped: cover.source = "image://coverprovider/default"
        onNewCoverReceived: {
            cover.source = "image://coverprovider/" + random
        }
    }
}

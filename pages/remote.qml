import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import QtQuick.Controls.Material 2.0

Pane {
    id: remoteLandscape

    GridLayout {
        id: gridLayout
        anchors.fill: parent

        Label {
            id: volumeLabel
            text: qsTr("Volume")
            visible: false
        }

        Slider {
            id: volumeSlider
        }

        Item {
            id: itemCover
            Layout.preferredHeight: 200
            Layout.preferredWidth: 200
            Image {
                id: cover
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
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

        Label {
            id: progressLabel
            text: qsTr("Progress")
            visible: false
            horizontalAlignment: Text.AlignHCenter
        }

        Slider {
            id: progressSlider
        }

        Image {
            id: next
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/next.png"

            MouseArea {
                id: maNext
                anchors.fill: parent
                onClicked: mediaPlayerControl.next()
            }

            /*ColorOverlay {
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
            }*/
        }

        Image {
            id: playPause
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
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/previous.png"

            MouseArea {
                id: maPrevious
                anchors.fill: parent
                onClicked: {
                    mediaPlayerControl.previous()
                }
            }

            /*ColorOverlay {
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
            }*/
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
        onProgressChanged: progressSlider.value = progress
        onNewCoverReceived: {
            cover.source = "image://coverprovider/" + random
        }
    }
    states: [
        // Portrait
        State {
            name: "portrait"
            when: window.isPortrait

            PropertyChanges {
                target: volumeLabel
                visible: true

                anchors.top: gridLayout.top
                anchors.left: gridLayout.left
                anchors.right: gridLayout.right
                anchors.bottom: undefined

                Layout.fillWidth: true
                Layout.fillHeight: false

                horizontalAlignment: Text.AlignHCenter
            }

            PropertyChanges {
                target: volumeSlider
                orientation: Qt.Horizontal

                anchors.top: volumeLabel.bottom
                anchors.left: gridLayout.left
                anchors.right: gridLayout.right
                anchors.bottom: undefined

                Layout.fillWidth: true
                Layout.fillHeight: false

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            PropertyChanges {
                target: itemCover

                anchors.top: volumeSlider.bottom
                anchors.left: gridLayout.left
                anchors.right: gridLayout.right
                anchors.bottom: undefined

                Layout.fillWidth: true
                Layout.fillHeight: false

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            PropertyChanges {
                target: progressLabel
                visible: true

                anchors.top: itemCover.bottom
                anchors.left: gridLayout.left
                anchors.right: gridLayout.right
                anchors.bottom: undefined

                Layout.fillWidth: true
                Layout.fillHeight: false
            }

            PropertyChanges {
                target: progressSlider

                Layout.fillWidth: true
                Layout.fillHeight: false

                anchors.top: progressLabel.bottom
                anchors.left: gridLayout.left
                anchors.right: gridLayout.right
                anchors.bottom: undefined

                orientation: Qt.Horizontal
            }

            PropertyChanges {
                target: previous

                Layout.fillWidth: false
                Layout.fillHeight: false

                anchors.top: undefined
                anchors.left: gridLayout.left
                anchors.right: undefined
                anchors.bottom: gridLayout.bottom

                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            }

            PropertyChanges {
                target: playPause

                Layout.fillWidth: false
                Layout.fillHeight: false

                anchors.top: undefined
                anchors.left: undefined
                anchors.right: undefined
                anchors.bottom: gridLayout.bottom

                anchors.horizontalCenter: gridLayout.horizontalCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            }

            PropertyChanges {
                target: next

                Layout.fillWidth: false
                Layout.fillHeight: false

                anchors.top: undefined
                anchors.left: undefined
                anchors.right: gridLayout.right
                anchors.bottom: gridLayout.bottom

                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
            }
        },
        // Landscape
        State {
            name: ""
            when: !window.isPortrait

            PropertyChanges {
                target: volumeLabel
                visible: false
                anchors.fill: undefined
            }

            PropertyChanges {
                target: volumeSlider

                Layout.fillHeight: true
                Layout.fillWidth: false

                anchors.top: gridLayout.top
                anchors.left: gridLayout.left
                anchors.right: undefined
                anchors.bottom: gridLayout.bottom

                orientation: Qt.Vertical
            }

            PropertyChanges {
                target: itemCover

                Layout.fillWidth: true
                Layout.fillHeight: true

                anchors.top: gridLayout.top
                anchors.left: volumeSlider.right
                anchors.right: undefined
                anchors.bottom: gridLayout.bottom

                Layout.preferredHeight: 200
                Layout.preferredWidth: 200
            }

            PropertyChanges {
                target: progressLabel
                visible: false

                anchors.fill: undefined
            }

            PropertyChanges {
                target: progressSlider

                Layout.fillWidth: false
                Layout.fillHeight: true

                anchors.top: gridLayout.top
                anchors.left: itemCover.right
                anchors.right: undefined
                anchors.bottom: gridLayout.bottom

                orientation: Qt.Vertical
            }

            PropertyChanges {
                target: next

                Layout.fillWidth: false
                Layout.fillHeight: false

                anchors.top: gridLayout.top
                anchors.left: undefined
                anchors.right: gridLayout.right
                anchors.bottom: undefined

                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
            }

            PropertyChanges {
                target: playPause

                Layout.fillWidth: false
                Layout.fillHeight: false

                anchors.horizontalCenter: next.horizontalCenter

                anchors.top: undefined
                anchors.left: undefined
                anchors.right: gridLayout.right
                anchors.bottom: undefined

                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
            }

            PropertyChanges {
                target: previous

                Layout.fillWidth: false
                Layout.fillHeight: false

                anchors.top: undefined
                anchors.left: undefined
                anchors.right: gridLayout.right
                anchors.bottom: gridLayout.bottom

                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
            }
        }
    ]
}

import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

import QtQuick.Controls.Material 2.0

Pane {
    id: remotePane

    ColumnLayout {
        id: columnLayout
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.left: parent.left
        spacing: 20
        implicitHeight: volumeLabel.height + volumeSlider.height + layoutRect.height + progressLabel.height

        Label {
            id: volumeLabel
            text: "Volume"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
        }

        Slider {
            id: volumeSlider
            anchors.top: volumeLabel.bottom
            value: 0.5
            Layout.fillWidth: true
            anchors.horizontalCenter: parent.horizontalCenter

            /*function sendToServer(value) {
                remoteClient.setVolume(value)
            }
            onValueChanged: sendToServer(value)

            Connections {
                target: remoteClient
                onAboutToUpdateVolume: {
                    volumeSlider.valueChanged.disconnect(volumeSlider.sendToServer)
                    volumeSlider.value = volume
                    volumeSlider.valueChanged.connect(volumeSlider.sendToServer)
                }
            }*/

            /*onValueChanged: remoteClient.setVolume(value)

            Connections {
                target: remoteClient
                onAboutToUpdateVolume: {
                    volumeSlider.valueChanged.disconnect(remoteClient.setVolume)
                    volumeSlider.value = volume
                    volumeSlider.valueChanged.connect(remoteClient.setVolume)
                }
            }*/

            Connections {
                target: remoteClient
                onAboutToUpdateVolume: {
                    volumeSlider.value = volume
                }
            }
            Connections {
                target: volumeSlider
                onValueChanged: {
                    remoteClient.setVolume(volumeSlider.value)
                }
            }
        }

        RowLayout {
            id: layoutRect
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: volumeSlider.bottom
            implicitHeight: logo.height

            Image {
                id: logo
                Layout.fillHeight: false
                anchors.horizontalCenter: layoutRect.horizontalCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                horizontalAlignment: Image.AlignHCenter
                fillMode: Image.PreserveAspectFit
                source: "image://coverprovider/default"
            }
        }

        Label {
            id: progressLabel
            anchors.top: layoutRect.bottom
            text: "Progress"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter

        }

        Slider {
            id: progressSlider
            Layout.fillHeight: true
            anchors.top: progressLabel.bottom
            value: 0.5
            Layout.fillWidth: true
        }
    }

    RowLayout {
        id: row
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 0
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

        Image {
            id: previous
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignBottom
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/previous.png"

            MouseArea {
                id: maPrevious
                anchors.fill: parent
                onClicked: {
                    mediaPlayerControl.previous()
                }
            }
        }
        Image {
            id: playPause
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignBottom
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/play.png"

            MouseArea {
                id: maPlayPause
                anchors.fill: parent
                onClicked: {
                    mediaPlayerControl.playPause()
                }
            }
        }
        Image {
            id: next
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignBottom
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/next.png"

            MouseArea {
                id: maNext
                anchors.fill: parent
                onClicked: {
                    mediaPlayerControl.next()
                }
            }
        }

        Connections {
            target: remoteClient
            onPlaying: playPause.source = "qrc:/images/play.png"
            onPaused: playPause.source = "qrc:/images/pause.png"
        }
    }
}

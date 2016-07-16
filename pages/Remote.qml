import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

import QtQuick.Controls.Material 2.0

Pane {
    id: remote
    width: parent.width

    ColumnLayout {
        id: columnLayout
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.left: parent.left
        spacing: 20
        //implicitHeight: volumeLabel.height + volumeSlider.height + layoutRect.height + progressLabel.height

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
        }

        RowLayout {
            id: layoutRect
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: volumeSlider.bottom
            //implicitHeight: logo.height

            Image {
                id: logo
                Layout.fillHeight: false
                anchors.horizontalCenter: layoutRect.horizontalCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                horizontalAlignment: Image.AlignHCenter
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/disc.png"
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
            anchors.top: progressLabel.bottom
            value: 0.5
            Layout.fillWidth: true
        }

        RowLayout {
            id: row
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            anchors.top: progressSlider.bottom
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            Layout.preferredHeight: 128

            Image {
                id: previous
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignBottom
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/previous.png"

            }
            Image {
                id: playPause
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignBottom
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/play.png"
            }

            Image {
                id: next
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignBottom
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/next.png"

                /*ColorOverlay {
                    id: co
                    anchors.fill: next
                    source: next
                    color: Material.accent
                }*/

                MouseArea {
                    id: maNext
                    anchors.fill: next
                    onClicked: {
                        console.log("hello")
                    }
                }
            }

        }


    }

}

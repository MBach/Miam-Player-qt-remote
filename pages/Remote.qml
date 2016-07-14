import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0

import QtQuick.Controls.Material 2.0

Pane {
    id: remote

    ColumnLayout {
        id: columnLayout
        transformOrigin: Item.Center
        spacing: 20
        anchors.fill: parent
        anchors.topMargin: 0

        Slider {
            id: volumeSlider
            value: 0.5
            Layout.fillWidth: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Pane {
            id: imagePane
            anchors.top: volumeSlider.bottom
            background: Rectangle {
                color: Material.accent
            }

            Image {
                id: logo
                anchors.fill: parent
                Layout.fillWidth: true
                horizontalAlignment: Image.AlignHCenter
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/disc.png"
            }
        }
    }

    Slider {
        id: progressSlider
        value: 0.5
        Layout.fillWidth: true
        anchors.horizontalCenter: parent.horizontalCenter
    }

    RowLayout {
        id: rowLayout
        anchors.horizontalCenter: progressSlider.horizontalCenter
        Image {
            id: previous
            anchors.fill: rowLayout
            Layout.fillWidth: true
            horizontalAlignment: Image.AlignHCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/previous.png"
        }
        Image {
            id: playPause
            anchors.fill: rowLayout
            Layout.fillWidth: true
            horizontalAlignment: Image.AlignHCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/play.png"
        }
        Image {
            id: next
            anchors.fill: rowLayout
            Layout.fillWidth: true
            horizontalAlignment: Image.AlignHCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/next.png"
        }
    }
}

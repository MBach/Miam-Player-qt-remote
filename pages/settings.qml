import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Pane {
    id: settingsPane
    //width: 254
    //height: 384

    Column {
        id: column
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Label {
            id: connectLabel
            text: qsTr("Connections")
            font.pixelSize: 12
        }
        RowLayout {
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.leftMargin: 0
            Layout.rowSpan: 1
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            spacing: 10

            Label {
                text: "Port:"
                Layout.rowSpan: 5
                Layout.columnSpan: 5
                Layout.fillHeight: false
                Layout.fillWidth: true
            }

            TextField {
                id: styleBox
                text: "5600"
                horizontalAlignment: Text.AlignRight
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                inputMethodHints: Qt.ImhDigitsOnly
                property int port: 5600
                Layout.fillWidth: true
            }
        }

        SwitchDelegate {
            id: switchDelegate
            y: 0
            text: qsTr("On startup, auto-connect to last server")
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.leftMargin: 0
            clip: false
            checked: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
        }
    }


}

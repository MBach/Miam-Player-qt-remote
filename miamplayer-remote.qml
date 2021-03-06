import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Window 2.2
import Qt.labs.settings 1.0

ApplicationWindow {
    id: window
    visible: true
    //width: 378
    //height: 588
    width: 588
    height: 378
    title: qsTr("Miam-Player Remote")

    Settings {
        id: settings
        property int port: 5600
    }

    property bool isPortrait: Screen.primaryOrientation === Qt.PortraitOrientation || Screen.primaryOrientation === Qt.InvertedPortraitOrientation

    header: ToolBar {
        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/drawer.png"
                }
                onClicked: drawer.open()
            }

            Label {
                id: titleLabel
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/menu.png"
                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: qsTr("About")
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
    }

    Drawer {
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height
        margins: 0

        function loadPage(title, pageName) {
            titleLabel.text = title
            stackView.replace(pageName)
            drawer.close()
        }

        ColumnLayout {

            id: columnLayout
            Layout.fillWidth: true
            anchors.left: parent.left
            anchors.right: parent.right
            Label {
                text: qsTr("Connect")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 15
                Layout.topMargin: 15
                height: 30
                MouseArea {
                    anchors.fill: parent
                    onClicked: drawer.loadPage(parent.text, "qrc:/pages/connect")
                }
            }
            Label {
                text: qsTr("Remote")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 15
                Layout.topMargin: 15
                height: 30
                MouseArea {
                    anchors.fill: parent
                    onClicked: drawer.loadPage(parent.text, "qrc:/pages/remote")
                }
            }

            function closeMenu() {
                var opened = (uniqueModeItem.visible === false)
                playlistModeItem.visible = opened
                uniqueModeItem.visible = opened
                if (opened) {
                    arrow.source = "qrc:/images/up.png"
                } else {
                    arrow.source = "qrc:/images/down.png"
                }
            }

            // Align image and text
            RowLayout {
                id: viewItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 15
                Layout.topMargin: 15
                height: 30
                Label {
                    text: qsTr("View")
                }
                Image {
                    id: arrow
                    source: "qrc:/images/down.png"
                    anchors.right: viewItem.right
                }
                MouseArea {
                    id: maViewItem
                    anchors.fill: parent
                    onClicked: columnLayout.closeMenu()
                }
            }

            ButtonGroup {
                id: radioGroup
            }

            // 2 foldable items
            Item {
                id: playlistModeItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 15
                height: 30
                visible: false
                RadioButton {
                    checked: true
                    text: qsTr("Playlist Mode")
                    ButtonGroup.group: radioGroup
                    onClicked: {
                        drawer.loadPage(text, "qrc:/pages/playlists")
                        columnLayout.closeMenu()
                    }
                }
            }
            Item {
                id: uniqueModeItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 15
                Layout.topMargin: 15
                height: 30
                visible: false
                RadioButton {
                    checked: false
                    text: qsTr("Unique Mode")
                    ButtonGroup.group: radioGroup
                    onClicked: {
                        drawer.loadPage(parent.text, "qrc:/pages/remote")
                        columnLayout.closeMenu()
                    }
                }
            }

            // End of drawer
            Label {
                text: qsTr("Settings")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 15
                Layout.topMargin: 15
                height: 30
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        titleLabel.text = parent.text
                        stackView.replace("qrc:/pages/settings")
                        drawer.close()
                    }
                }
            }
        }
    }

    Popup {
        id: aboutDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                text: qsTr("About")
                font.bold: true
            }

            Label {
                width: aboutDialog.availableWidth
                text: qsTr("'Miam-Player Remote' is a small App on your smartphone for remote control the Audio Software 'Miam-Player'")
                wrapMode: Label.Wrap
            }
        }
    }

    Component.onCompleted: {
        drawer.loadPage(qsTr("Connect"), "qrc:/pages/connect")
    }
}

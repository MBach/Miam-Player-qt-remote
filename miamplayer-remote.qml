import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 254
    height: 384
    title: "Miam-Player Remote"

    Settings {
        id: settings
        property int port: 5600
    }

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
                text: "Home"
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
                        text: "Settings"
                        onTriggered: settingsPopup.open()
                    }
                    MenuItem {
                        text: "About"
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        /*initialItem: {
            source: "qrc:/pages/connect.qml"
        }*/
    }

    Drawer {
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height

        ListView {
            id: listView
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {
                    if (listView.currentIndex != index) {
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                    }
                    drawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "Connect"; source: "qrc:/pages/connect.qml" }
                ListElement { title: "Remote"; source: "qrc:/pages/remote.qml" }
                ListElement { title: "Settings"; source: "qrc:/pages/settings.qml" }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }

    }

    //Component.onCompleted: stackView.push(listView.itemAt(2))

    Popup {
        id: settingsPopup
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        height: settingsColumn.implicitHeight + topPadding + bottomPadding
        modal: true
        focus: true

        contentItem: ColumnLayout {
            id: settingsColumn
            spacing: 20

            Label {
                text: "Settings"
                font.bold: true
            }

            RowLayout {
                spacing: 10

                Label {
                    text: "Port:"
                }

                TextField {
                    id: styleBox
                    text: "5600"
                    inputMethodHints: Qt.ImhDigitsOnly
                    property int port: 5600
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                spacing: 10

                Button {
                    id: okButton
                    text: "Ok"
                    onClicked: {
                        settings.style = styleBox.displayText
                        settingsPopup.close()
                    }

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }

                Button {
                    id: cancelButton
                    text: "Cancel"
                    onClicked: {
                        settingsPopup.close()
                    }

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
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
                text: "About"
                font.bold: true
            }

            Label {
                width: aboutDialog.availableWidth
                text: "'Miam-Player Remote' is a small App on your smartphone for remote control the Audio Software 'Miam-Player'"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
        }
    }
}

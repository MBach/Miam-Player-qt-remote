TEMPLATE = app

TARGET = MiamPlayer-Remote

QT += quick quickcontrols2 multimedia

CONFIG += console

SOURCES += main.cpp \
    coverprovider.cpp \
    mediaplayercontrol.cpp \
    lastconnectionsmodel.cpp \
    remoteclient.cpp

OTHER_FILES += pages/*.qml

RESOURCES += miamplayer-remote.qrc

DISTFILES += miamplayer-remote.qml

HEADERS += coverprovider.h \
    lastconnectionsmodel.h \
    mediaplayercontrol.h \
    remoteclient.h

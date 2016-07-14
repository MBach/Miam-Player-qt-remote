TEMPLATE = app
TARGET = MiamPlayer-Remote

QT += quick quickcontrols2
CONFIG += console

SOURCES += main.cpp \
    lastconnectionsmodel.cpp \
    remoteclient.cpp

OTHER_FILES += pages/*.qml

RESOURCES += miamplayer-remote.qrc

DISTFILES += miamplayer-remote.qml

HEADERS += lastconnectionsmodel.h \
    remoteclient.h

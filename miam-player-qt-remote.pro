TEMPLATE = app

TARGET = MiamPlayer-Remote

QT += quick quickcontrols2 multimedia network

CONFIG += console

SOURCES += main.cpp \
    coverprovider.cpp \
    mediaplayercontrol.cpp \
    lastconnectionsmodel.cpp \
    remoteclient.cpp \
    genericdao.cpp \
    trackdao.cpp \
    wifichecker.cpp

OTHER_FILES += pages/*.qml

RESOURCES += miamplayer-remote.qrc

DISTFILES += miamplayer-remote.qml \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

HEADERS += coverprovider.h \
    lastconnectionsmodel.h \
    mediaplayercontrol.h \
    remoteclient.h \
    genericdao.h \
    trackdao.h \
    wifichecker.h

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

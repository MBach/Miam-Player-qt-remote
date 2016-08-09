TEMPLATE = app

TARGET = MiamPlayer-Remote

QT += quick quickcontrols2 multimedia websockets
android: QT += androidextras

CONFIG += console qtquickcompiler

SOURCES += main.cpp \
    models/lastconnectionsmodel.cpp \
    models/networkscannermodel.cpp \
    models/playlistmanagermodel.cpp \
    models/playlistmodel.cpp \
    coverprovider.cpp \
    mediaplayercontrol.cpp \
    remoteclient.cpp \
    wifichecker.cpp

lupdate_only{
SOURCES = *.qml \
    pages/*.qml
}

OTHER_FILES += pages/*.qml
android: {
OTHER_FILES += android/src/org/miamplayer/remote/utils/WifiActivator.java
}

RESOURCES += miamplayer-remote.qrc

DISTFILES += miamplayer-remote.qml \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/WifiActivator.java

HEADERS += coverprovider.h \
    models/lastconnectionsmodel.h \
    models/networkscannermodel.h \
    models/playlistmanagermodel.h \
    models/playlistmodel.h \
    mediaplayercontrol.h \
    remoteclient.h \
    wifichecker.h

TRANSLATIONS = translations/*.ts

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

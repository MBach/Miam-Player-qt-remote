TEMPLATE = app

TARGET = MiamPlayer-Remote

QT += quick quickcontrols2 multimedia network
android: QT += androidextras

CONFIG += console qtquickcompiler

SOURCES += main.cpp \
    coverprovider.cpp \
    genericdao.cpp \
    lastconnectionsmodel.cpp \
    mediaplayercontrol.cpp \
    playlistmanagermodel.cpp \
    remoteclient.cpp \
    trackdao.cpp \
    wifichecker.cpp \
    networkscannermodel.cpp

lupdate_only{
SOURCES = *.qml \
    pages/*.qml
}

OTHER_FILES += pages/*.qml \
    android/src/org/miamplayer/remote/utils/WifiActivator.java

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
    genericdao.h \
    lastconnectionsmodel.h \
    mediaplayercontrol.h \
    playlistmanagermodel.h \
    remoteclient.h \
    trackdao.h \
    wifichecker.h \
    networkscannermodel.h

TRANSLATIONS = translations/miam-player-remote_en.ts \
    translations/miam-player-remote_fr.ts

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

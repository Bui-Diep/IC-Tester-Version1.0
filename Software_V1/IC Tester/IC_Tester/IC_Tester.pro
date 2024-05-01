QT       += core gui
QT += serialport
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0
VPATH += src/
INCLUDEPATH += include/
SOURCES += \
    src/truyennhandulieu.cpp \
    src/huongdan.cpp \
    src/kiemtra.cpp \
    main.cpp \
    src/mainwindow.cpp \
    src/taothuvien.cpp \
    src/xemlichsu.cpp \
    src/xemthuvien.cpp

HEADERS += \
    include/huongdan.h\
    include/kiemtra.h \
    include/mainwindow.h \
    include/taothuvien.h \
    include/truyennhandulieu.h \
    include/xemlichsu.h \
    include/xemthuvien.h

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    resource.qrc

FORMS +=

RC_ICONS = resources/SoftwareIcon.ico

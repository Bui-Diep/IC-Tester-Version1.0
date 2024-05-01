#include "mainwindow.h"

#include <QApplication>
#include <QScreen>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;

    // Lấy thông tin màn hình chính
    QScreen *screen = QGuiApplication::primaryScreen();
    QRect screenGeometry = screen->geometry();

    // Thiết lập kích thước và vị trí cửa sổ ứng dụng
    int windowWidth = 1200; // Kích thước cửa sổ theo chiều ngang
    int windowHeight = 750; // Kích thước cửa sổ theo chiều dọc
    int x = (screenGeometry.width() - windowWidth) / 2;
    int y = (screenGeometry.height() - (screenGeometry.height() * 1 / 36) - windowHeight) / 2;
    w.setGeometry(x, y, windowWidth, windowHeight);

    w.show();

    return a.exec();
}

#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    //    tuy chinh giao diện Home =========================================================
    setWindowTitle("IC Tester Development Version");

    QGridLayout *lopHome = new QGridLayout;
    QHBoxLayout *lopWellcome = new QHBoxLayout;
    QVBoxLayout *lopNutNhan = new QVBoxLayout;

    QLabel *space = new QLabel(" ");
    QLabel *wellcomeText = new QLabel("Welcome to IC Tester Development Version");
    wellcomeText->setAlignment(Qt::AlignLeft);
    wellcomeText->setStyleSheet("color: #0000FF; font-size: 36px;font-weight: bold;");
    QLabel *wellcomeIcon = new QLabel;
    QLabel *homeIcon = new QLabel;
    QPixmap pixmap(":/images/resources/SoftwareIcon.png"); // Đường dẫn đến tệp hình ảnh
    QPixmap scaledPixmapBigIcon = pixmap.scaled(QSize(400, 400));
    QGraphicsBlurEffect *blurEffect = new QGraphicsBlurEffect();
    blurEffect->setBlurRadius(0); // Điều chỉnh độ mờ ở đây;
                                  //    wellcomeIcon->setPixmap(scaledPixmap);
    wellcomeIcon->setAlignment(Qt::AlignLeft);
    homeIcon->setGraphicsEffect(blurEffect);
    homeIcon->setPixmap(scaledPixmapBigIcon);
    homeIcon->setAlignment(Qt::AlignCenter);
    lopWellcome->addWidget(wellcomeIcon);
    lopWellcome->addWidget(wellcomeText);
    //    lopHome->addWidget(space, 0, 0);

    lopHome->addWidget(space, 0, 2);
    lopHome->addWidget(space, 0, 4);
    lopHome->addLayout(lopWellcome, 0, 3);
    lopHome->addWidget(homeIcon, 3, 3, 11, 1);
    lopHome->addWidget(space, 1, 1);
    QLabel *auThor = new QLabel("The software is designed and created by BuiDiep");
    lopHome->addWidget(auThor, 14, 3);
    auThor->setAlignment(Qt::AlignCenter);
    auThor->setStyleSheet("color: #0000FF; font-size: 22px;font-weight: bold; font-style: italic;");

    //    tuy chinh nut chuc nang================================================================
    QSize iconSize(30, 30);
    QPushButton *nutKiemTra = new QPushButton("  Kiểm Tra IC");
    nutKiemTra->setFixedSize(300, 55);
    nutKiemTra->setCursor(QCursor(Qt::PointingHandCursor));
    nutKiemTra->setStyleSheet("QPushButton {"
                              "background-color: #A9C4EB;"
                              "font-weight: 600;"
                              "font-size: 20px;"
                              "}"
                              "QPushButton:hover {"
                              "background-color: yellow;"
                              "}");

    nutKiemTra->setIcon(QIcon(":/images/resources/KiemTra.png"));
    nutKiemTra->setIconSize(iconSize);
    QPushButton *nutTaoThuVien = new QPushButton("  Tạo Thư Viện");
    nutTaoThuVien->setFixedSize(300, 55);
    nutTaoThuVien->setCursor(QCursor(Qt::PointingHandCursor));
    nutTaoThuVien->setStyleSheet("QPushButton {"
                                 "background-color: #A9C4EB;"
                                 "font-weight: 600;"
                                 "font-size: 20px;"
                                 "}"
                                 "QPushButton:hover {"
                                 "background-color: yellow;"
                                 "}");
    nutTaoThuVien->setIcon(QIcon(":/images/resources/TaoThuVien.png"));
    nutTaoThuVien->setIconSize(iconSize);
    QPushButton *nutXemThuVien = new QPushButton("  Xem Thư Viện");
    nutXemThuVien->setFixedSize(300, 55);
    nutXemThuVien->setCursor(QCursor(Qt::PointingHandCursor));
    nutXemThuVien->setStyleSheet("QPushButton {"
                                 "background-color: #A9C4EB;"
                                 "font-weight: 600;"
                                 "font-size: 20px;"
                                 "}"
                                 "QPushButton:hover {"
                                 "background-color: yellow;"
                                 "}");
    nutXemThuVien->setIcon(QIcon(":/images/resources/XemThuVien.png"));
    nutXemThuVien->setIconSize(iconSize);
    QPushButton *nutXemLichSu = new QPushButton("  Xem Lịch Sử");
    nutXemLichSu->setFixedSize(300, 55);
    nutXemLichSu->setCursor(QCursor(Qt::PointingHandCursor));
    nutXemLichSu->setStyleSheet("QPushButton {"
                                "background-color: #A9C4EB;"
                                "font-weight: 600;"
                                "font-size: 20px;"
                                "}"
                                "QPushButton:hover {"
                                "background-color: yellow;"
                                "}");
    nutXemLichSu->setIcon(QIcon(":/images/resources/XemLichSu.png"));
    nutXemLichSu->setIconSize(iconSize);

    QLabel *nhanThongTin = new QLabel("                   Thông Tin?");
    nhanThongTin->setStyleSheet("font-size: 20px;font-weight: bold;");
    QLabel *nhanCongCu = new QLabel("                   Công Cụ");
    nhanCongCu->setStyleSheet("font-size: 20px;font-weight: bold;");
    nhanCongCu->setFixedHeight(27);
    QPushButton *nutHuongDan = new QPushButton("  Hướng Dẫn");
    nutHuongDan->setFixedSize(300, 55);
    nutHuongDan->setCursor(QCursor(Qt::WhatsThisCursor));
    nutHuongDan->setStyleSheet("QPushButton {"
                               "background-color: #009900;"
                               "color: white;"
                               "font-weight: 600;"
                               "font-size: 20px;"
                               "}"
                               "QPushButton:hover {"
                               "background-color: #007500;"
                               "}");
    nutHuongDan->setIcon(QIcon(":/images/resources/HuongDan.png"));
    nutHuongDan->setIconSize(iconSize);
    QPushButton *nutLienHe = new QPushButton("  Liên Hệ");
    nutLienHe->setFixedSize(300, 55);
    nutLienHe->setCursor(QCursor(Qt::PointingHandCursor));
    nutLienHe->setStyleSheet("QPushButton {"
                             "background-color: #009900;"
                             "color: white;"
                             "font-weight: 600;"
                             "font-size: 20px;"
                             "}"
                             "QPushButton:hover {"
                             "background-color: #007500;"
                             "}");
    nutLienHe->setIcon(QIcon(":/images/resources/LienHe.png"));
    nutLienHe->setIconSize(iconSize);
    QMenu *menuLienHe = new QMenu;
    QAction *fB = new QAction("FaceBook");
    fB->setIcon(QIcon(":/images/resources/Face.png"));
    menuLienHe->addAction(fB);
    QAction *tG = new QAction("Telegram");
    tG->setIcon(QIcon(":/images/resources/Tele.png"));
    menuLienHe->addAction(tG);
    QAction *gH = new QAction("GitHub");
    gH->setIcon(QIcon(":/images/resources/Git.png"));
    menuLienHe->addAction(gH);
    nutLienHe->setMenu(menuLienHe);
    QObject::connect(fB, &QAction::triggered, [&]() {
        QDesktopServices::openUrl(QUrl("https://www.facebook.com/buidiep01/"));
    });
    QObject::connect(gH, &QAction::triggered, [&]() {
        QDesktopServices::openUrl(
            QUrl("https://github.com/Bui-Diep/IC-Tester-Software/tree/B%C3%B9i_%C4%90i%E1%BB%87p"));
    });
    lopNutNhan->addWidget(nhanCongCu);
    nhanCongCu->setAlignment(Qt::AlignTop);
    lopNutNhan->addWidget(nutKiemTra);
    //    lopNutNhan->addWidget(space);
    lopNutNhan->addWidget(nutTaoThuVien);
    //    lopNutNhan->addWidget(space);
    lopNutNhan->addWidget(nutXemThuVien);
    //    lopNutNhan->addWidget(space);
    lopNutNhan->addWidget(nutXemLichSu);
    lopNutNhan->addWidget(space);
    lopNutNhan->addWidget(space);
    lopNutNhan->addWidget(nhanThongTin);
    nhanThongTin->setAlignment(Qt::AlignBottom);
    lopNutNhan->addWidget(nutHuongDan);
    //    lopNutNhan->addWidget(space);
    lopNutNhan->addWidget(nutLienHe);
    //    lopNutNhan->addWidget(space);
    //    lopNutNhan->addWidget(space);
    QGroupBox *boxNutNhan = new QGroupBox;
    boxNutNhan->setLayout(lopNutNhan);
    lopHome->addWidget(boxNutNhan, 2, 1, 14, 1);

    connect(nutKiemTra, SIGNAL(clicked(bool)), this, SLOT(opKiemTra()));
    connect(nutTaoThuVien, SIGNAL(clicked(bool)), this, SLOT(opTaoThuVien()));
    connect(nutXemThuVien, SIGNAL(clicked(bool)), this, SLOT(opXemThuVien()));
    connect(nutXemLichSu, SIGNAL(clicked(bool)), this, SLOT(opXemLichSu()));
    connect(nutHuongDan, SIGNAL(clicked(bool)), this, SLOT(opHuongDan()));

    //    cau hinh thanh menu =================================================================
    QMenu *tep = menuBar()->addMenu("&Tệp");
    QMenu *timKiem = menuBar()->addMenu("Tìm &Kiếm");
    QMenu *chinhSua = menuBar()->addMenu("&Chỉnh sửa");
    QMenu *congcu = menuBar()->addMenu("&Công Cụ");
    QMenu *huongDan = menuBar()->addMenu("&Hướng dẫn");
    QMenu *thongTin = menuBar()->addMenu("&Thông tin");

    //    cau hinh thanh cong cu ================================================================
    QToolBar *thanhCongCu = new QToolBar("Thanh công cụ");
    QToolBar *thanhLienHe = new QToolBar("Thanh liên hệ");
    thanhCongCu->setMovable(0);
    thanhCongCu->setAllowedAreas(Qt::RightToolBarArea);
    addToolBar(thanhCongCu);
    QPushButton *nutBackHome = new QPushButton(" Home");
    nutBackHome->setCursor(QCursor(Qt::PointingHandCursor));
    nutBackHome->setStyleSheet("QPushButton {"
                               "background-color: #A8D9D0;"
                               "font-weight: bold;"
                               "}"
                               "QPushButton:hover {"
                               "background-color: yellow;"
                               "}");
    nutBackHome->setIcon(QIcon(":/images/resources/home.png"));
    nutBackHome->setIconSize(QSize(20, 20));
    nutBackHome->setToolTip("Trở về trang chủ");
    thanhCongCu->addWidget(nutBackHome);

    QAction *acKiemTra = new QAction("Chuyển tới trang kiểm tra IC");
    acKiemTra->setIcon(QIcon(":/images/resources/KiemTra.png"));
    thanhCongCu->addSeparator();
    thanhCongCu->addAction(acKiemTra);
    QAction *acXemThuVien = new QAction("Chuyển tới trang xem thư viện");
    acXemThuVien->setIcon(QIcon(":/images/resources/XemThuVien.png"));
    thanhCongCu->addSeparator();
    thanhCongCu->addAction(acXemThuVien);
    thanhCongCu->addSeparator();
    QAction *setting = new QAction("Cài đặt");
    setting->setIcon(QIcon(":/images/resources/setting.png"));
    thanhCongCu->addAction(setting);
    QAction *thoat = new QAction("Thoát Phần Mềm");
    thoat->setIcon(QIcon(":/images/resources/power.png"));
    thanhCongCu->addSeparator();
    thanhCongCu->addAction(thoat);
    thanhLienHe->setMovable(true);
    thanhLienHe->addSeparator();
    thanhLienHe->addAction(fB);
    thanhLienHe->addSeparator();
    thanhLienHe->addAction(tG);
    thanhLienHe->addSeparator();
    thanhLienHe->addAction(gH);
    connect(nutBackHome, SIGNAL(clicked(bool)), this, SLOT(opHome()));
    connect(thoat, SIGNAL(triggered(bool)), qApp, SLOT(quit()));
    connect(acKiemTra, SIGNAL(triggered(bool)), this, SLOT(opKiemTra()));
    thanhCongCu->setIconSize(QSize(20, 20));

    addToolBar(Qt::TopToolBarArea, thanhLienHe);

    //    cau hinh vung trung tam
    khongGianLamViec = new QStackedWidget;
    trangHome = new QWidget;
    trangHome->setStyleSheet("background-color: #9AC7BF;");
    trangKiemTra = new KiemTra;
    trangKiemTra->setStyleSheet("background-color: #E3E3E3;");
    trangTaoThuVien = new TaoThuVien;
    trangTaoThuVien->setStyleSheet("background-color: #E3E3E3;");
    trangXemThuVien = new XemThuVien;
    trangXemThuVien->setStyleSheet("background-color: #E3E3E3;");
    trangXemLichSu = new XemLichSu;
    trangXemLichSu->setStyleSheet("background-color: #E3E3E3;");
    trangHuongDan = new HuongDan;
    trangHuongDan->setStyleSheet("background-color: #E3E3E3;");

    khongGianLamViec->addWidget(trangHome);
    khongGianLamViec->addWidget(trangKiemTra);
    khongGianLamViec->addWidget(trangTaoThuVien);
    khongGianLamViec->addWidget(trangXemThuVien);
    khongGianLamViec->addWidget(trangXemLichSu);

    trangHome->setLayout(lopHome);
    khongGianLamViec->setCurrentWidget(trangHome);
    setCentralWidget(khongGianLamViec);
}
void MainWindow::opHome()
{
    khongGianLamViec->setCurrentWidget(trangHome);
    setWindowTitle("IC Tester Development Version");
}
void MainWindow::opKiemTra()
{
    khongGianLamViec->setCurrentWidget(trangKiemTra);
    setWindowTitle("Kiểm Tra - IC Tester Development Version");
}
void MainWindow::opTaoThuVien()
{
    khongGianLamViec->setCurrentWidget(trangTaoThuVien);
    setWindowTitle("Tạo Thư Viện - IC Tester Development Version");
}
void MainWindow::opXemThuVien()
{
    khongGianLamViec->setCurrentWidget(trangXemThuVien);
    setWindowTitle("Xem Thư Viện - IC Tester Development Version");
}
void MainWindow::opXemLichSu()
{
    khongGianLamViec->setCurrentWidget(trangXemLichSu);
    setWindowTitle("Xem Lịch Sử - IC Tester Development Version");
}
void MainWindow::opHuongDan()
{
    trangHuongDan->exec();
}
MainWindow::~MainWindow() {}

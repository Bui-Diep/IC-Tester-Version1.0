#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtWidgets>
#include "huongdan.h"
#include "kiemtra.h"
#include "taothuvien.h"
#include "xemlichsu.h"
#include "xemthuvien.h"

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void opHome();
    void opKiemTra();
    void opTaoThuVien();
    void opXemThuVien();
    void opXemLichSu();
    void opHuongDan();

private:
    QStackedWidget *khongGianLamViec;
    QWidget *trangHome;
    KiemTra *trangKiemTra;
    TaoThuVien *trangTaoThuVien;
    XemThuVien *trangXemThuVien;
    XemLichSu *trangXemLichSu;
    HuongDan *trangHuongDan;
};
#endif // MAINWINDOW_H

#ifndef TAOTHUVIEN_H
#define TAOTHUVIEN_H
#include <QtWidgets>

class MyButton : public QPushButton
{
    Q_OBJECT

public:
    MyButton(const QString &text, QWidget *parent = nullptr);

protected:
    void enterEvent(QEnterEvent *event) override;
    void leaveEvent(QEvent *event) override;
signals:
    void entered();
    void left();
};

class TaoThuVien : public QWidget
{
    Q_OBJECT
public:
    TaoThuVien();
    ~TaoThuVien();

public slots:
    void opTrangCauHinhDuLieu();
    void opTrangCauHinhChan();
    void opComplete(const QString &dienAp, const int &soChan);
    void taoFileDuLieu(const QString &soChan);

private:
    QStackedWidget *khongGianTaoThuVien;
    QVBoxLayout *lopCauHinhChan;
    QGroupBox *boxCauHinhChan;
    QStackedWidget *khongGianHienSymIC;
    QWidget *trangHienSymDefault;
    QWidget *trangHienSymIC14;
    QWidget *trangHienSymIC16;
    QWidget *trangHienSymIC20;
    QGridLayout *lopGanChan14;
    QGridLayout *lopGanChan16;
    QGridLayout *lopGanChan20;
    QWidget *layoutWidget;
    QWidget *trangCauHinhChan;
    QWidget *trangCauHinhDuLieu;
    QComboBox *soChanIC;
    QLineEdit *tenIC;
    QTextEdit *moTaIC;
    QComboBox *congNgheBanDan;
    QGridLayout *lopHienThiThuocTinhIC;
    QLabel *bangHienThiThuocTinhIC;
    QLabel *chanSocketIC[10][3];
    QPushButton *chanDuLieuIC20[10][3];
    QPushButton *chanDuLieuIC16[10][3];
    QPushButton *chanDuLieuIC14[10][3];
    QStackedWidget *khongGianCauHinhDuLieu;
    QStandardItemModel *moHinhCacBaiTest;
    QListView *hienThiCacBaiTest;
    QString danhSachCacBaiTest;
    QByteArray *duLieuBaiKiemTra;
};

#endif // TAOTHUVIEN_H

#include "huongdan.h"

HuongDan::HuongDan()
{
    setWindowTitle("Hướng Dẫn - IC Tester Development Version");
    setWindowIcon(QIcon(":/images/resources/HuongDan.png"));
    setFixedWidth(450);

    QGridLayout *lopHuongDan = new QGridLayout;

    QFile file(":/document/Readme/HuongDan.txt");
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QTextStream in(&file);
    QString fileContent = in.readAll();

    QLabel *nhanHuongDan = new QLabel(fileContent);
    //    nhanHuongDan->setText(fileContent);
    nhanHuongDan->setStyleSheet("font-family: Times New Roman; color: #0000FF; font-size: 16px;");
    nhanHuongDan->setAlignment(Qt::AlignCenter);
    file.close();
    QLabel *nhanIcon = new QLabel;
    QPixmap picIcon(":/images/resources/SoftwareIcon.png");
    QPixmap scaleIcon = picIcon.scaled(60, 60);
    nhanIcon->setPixmap(scaleIcon);
    QLabel *nhanTitle = new QLabel("  IC Tester Development Version");
    nhanTitle->setStyleSheet("font-weight: bold; color: #0000FF; font-size: 20px;");
    lopHuongDan->addWidget(nhanIcon, 0, 0);
    lopHuongDan->addWidget(nhanTitle, 0, 1);
    lopHuongDan->addWidget(new QLabel(""), 0, 2);
    lopHuongDan->addWidget(nhanHuongDan, 1, 1, 8, 1);
    setLayout(lopHuongDan);
}

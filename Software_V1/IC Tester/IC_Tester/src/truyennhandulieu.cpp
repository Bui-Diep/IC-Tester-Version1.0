#include "truyennhandulieu.h"
#include "qdebug.h"

//void TruyenDuLieu::sendData(QString filePath, QSerialPort *serialPort, int *chiSoBaiKiemTra)
//{
//    serialPort->open(QIODevice::ReadWrite);
//    QFile binFile(filePath); // filePath duong dan toi file duoc chon
//    binFile.open(QIODevice::ReadOnly);
//    // Di chuyển con trỏ đọc tệp đến byte thứ hai
//    binFile.seek(1 + *chiSoBaiKiemTra * 10);
//    char *dataSend = new char[10];
//    //    dataDis = new char[10];
//    binFile.read(dataSend, 10);
//    //    binFile.read(dataDis, 10);
//    //    binFile.close(); // Đóng file .bin sau khi đọc xong
//    //    Gửi dữ liệu từ sendData qua UART
//    serialPort->write(dataSend, 10);
//    qDebug() << "Da gui du lieu";
//    serialPort->flush();

//    binFile.close(); // Đóng file .bin sau khi đọc xong
//}

//char *TruyenDuLieu::getDataSend()
//{
//    //    return dataDis;
//}

//TruyenDuLieu::~TruyenDuLieu(){
//    //    delete[] dataDis;
//};
//char NhanDuLieu::receiveData(QSerialPort *serialPort)
//{
//    serialPort->read(&dataReceiv, 1);

//    return dataReceiv;
//}
//NhanDuLieu::~NhanDuLieu(){
//    //    delete dataReceiv;
//};

#ifndef TRUYENNHANDULIEU_H
#define TRUYENNHANDULIEU_H

#include <QSerialPort>
#include <QThread>
#include <QtWidgets>

//class TruyenDuLieu : public QThread
//{
//public:
//    TruyenDuLieu(QObject *parent = nullptr);
//    ~TruyenDuLieu();

//    void sendData(QString filePath, QSerialPort *serialPort, int *chiSoBaiKiemTra);

//    char *getDataSend();

//private:
//    //    char *dataDis; // Mảng char để lưu dữ liệu hiển thị
//    //protected:
//    //        void run() override;
//};
//class NhanDuLieu : public QThread
//{
//public:
//    NhanDuLieu(QObject *parent = nullptr);
//    ~NhanDuLieu();

//    char receiveData(QSerialPort *serialPort);

//private:
//    char dataReceiv;
//};

#endif // TRUYENNHANDULIEU_H

#include "kiemtra.h"
#include <QSerialPortInfo>

KiemTra::KiemTra()
{
    QGridLayout *lopKiemTraTong = new QGridLayout(this);
    QGroupBox *boxCauHinhKetNoi = new QGroupBox("Thiết lập kết nối tới phần cứng");
    boxCauHinhKetNoi->setStyleSheet("font-weight: bold;font-size: 16px; color: #0000FF");
    boxCauHinhKetNoi->setFixedSize(410, 120);
    QGroupBox *boxKiemTraIC = new QGroupBox("Kiểm tra IC");
    boxKiemTraIC->setStyleSheet("font-weight: bold;font-size: 20px; color: #0000FF");
    boxKiemTraIC->setDisabled(true);
    QGroupBox *boxChonIC = new QGroupBox("Chọn IC kiểm tra");
    boxChonIC->setStyleSheet("font-weight: bold;font-size: 16px; color: #0000FF");
    boxChonIC->setFixedWidth(410);

    //    thiết lập cấu hình truyền thông

    lopKiemTraTong->addWidget(boxCauHinhKetNoi, 0, 0);
    lopKiemTraTong->addWidget(boxChonIC, 1, 0);
    lopKiemTraTong->addWidget(boxKiemTraIC, 0, 1, 2, 1);

    QComboBox *danhSachCongCOM = new QComboBox;
    danhSachCongCOM->setStyleSheet("font-size: 14px; color : #CC0000");
    danhSachCongCOM->setFixedWidth(200);
    danhSachCongCOM->setPlaceholderText("Không tìm thấy thiết bị");
    QComboBox *danhSachBaud = new QComboBox;
    danhSachBaud->setFixedWidth(100);
    danhSachBaud->setStyleSheet("font-weight: 500;font-size: 14px; color: black");
    QPushButton *nutNhanKetNoi = new QPushButton;
    nutNhanKetNoi->setFixedWidth(80);
    nutNhanKetNoi->setText("Ngắt\nkết nối");
    nutNhanKetNoi->setStyleSheet("QPushButton {"
                                 "background-color: #CC0000;"
                                 "color: white;"
                                 "font-weight: bold;"
                                 "font-size: 16px;"
                                 "}"
                                 "QPushButton:hover {"
                                 "background-color: #007500;"
                                 "}");

    QGridLayout *lopCauHinhKetNoi = new QGridLayout(boxCauHinhKetNoi);

    lopCauHinhKetNoi
        ->addWidget(new QLabel(
                        "<html><body><p style=\"font-size:15px; "
                        "font-weight:550; color: normal;\">Tìm thiết bị: </p></body></html>"),
                    0,
                    0);
    lopCauHinhKetNoi->addWidget(danhSachCongCOM, 0, 1);
    lopCauHinhKetNoi->addWidget(nutNhanKetNoi, 0, 2);
    lopCauHinhKetNoi
        ->addWidget(new QLabel("<html><body><p style=\"font-size:15px; "
                               "font-weight:550; color: normal;\">Tốc độ Baud: </p></body></html>"),
                    1,
                    0);
    lopCauHinhKetNoi->addWidget(danhSachBaud, 1, 1);
    danhSachBaud->addItem("9600bps");
    danhSachBaud->addItem("19200bps");
    serialPort = new QSerialPort(this);
    QSerialPortInfo *portInfo = new QSerialPortInfo;
    // Tạo một QTimer để thực hiện kiểm tra định kỳ
    QTimer *timer = new QTimer;
    timer->setInterval(1000);
    //    int *soLuongCOM = new int(0);
    connect(timer, &QTimer::timeout, this, [=]() {
        //     Liệt kê các cổng COM và thêm vào QComboBox
        QList<QSerialPortInfo> availablePorts = QSerialPortInfo::availablePorts();

        if (availablePorts.size() != danhSachCongCOM->count()) {
            if (availablePorts.isEmpty()) {
                danhSachCongCOM->clear();
                danhSachCongCOM->setPlaceholderText("Không tìm thấy thiết bị");
                danhSachCongCOM->setStyleSheet("font-size: 14px; color : #CC0000");
                boxKiemTraIC->setDisabled(true);
                danhSachCongCOM->setDisabled(true); // Vô hiệu hóa QComboBox
                nutNhanKetNoi->setText("Ngắt\nkết nối");
                nutNhanKetNoi->setStyleSheet("QPushButton {"
                                             "background-color: #CC0000;"
                                             "color: white;"
                                             "font-weight: bold;"
                                             "font-size: 16px;"
                                             "}"
                                             "QPushButton:hover {"
                                             "background-color: #007500;"
                                             "}");
                QMessageBox::warning(this,
                                     "Thông tin kết nối",
                                     "Ngắt kết nối với thiết bị phần cứng");
            } else {
                danhSachCongCOM->setDisabled(false);

                danhSachCongCOM->clear();
                danhSachCongCOM->setPlaceholderText(
                    "Tìm thấy " + QString::number(availablePorts.size()) + " thiết bị");
                danhSachCongCOM->setStyleSheet("font-size: 14px; color : green");
                nutNhanKetNoi->setText("Kết nối");
                nutNhanKetNoi->setStyleSheet("QPushButton {"
                                             "background-color: #009900;"
                                             "color: white;"
                                             "font-weight: bold;"
                                             "font-size: 16px;"
                                             "}"
                                             "QPushButton:hover {"
                                             "background-color: #007500;"
                                             "}");
                foreach (*portInfo, availablePorts) {
                    danhSachCongCOM->addItem(portInfo->portName());
                }
            }
        }
    });

    // Khởi động QTimer để bắt đầu kiểm tra
    timer->start();

    connect(nutNhanKetNoi, &QPushButton::clicked, this, [=]() {

        // Cài đặt thông số kết nối UART (ví dụ: tốc độ baud 9600)
        if (danhSachBaud->currentText() == "9600bps") {
            serialPort->setPortName(danhSachCongCOM->currentText());
            serialPort->setBaudRate(QSerialPort::Baud9600);
            serialPort->setDataBits(QSerialPort::Data8);
            serialPort->setParity(QSerialPort::NoParity);
            serialPort->setStopBits(QSerialPort::OneStop);
            serialPort->setFlowControl(QSerialPort::NoFlowControl);

        } else if (danhSachBaud->currentText() == "19200bps") {
            serialPort->setPortName(danhSachCongCOM->currentText());
            serialPort->setBaudRate(QSerialPort::Baud19200);
            serialPort->setDataBits(QSerialPort::Data8);
            serialPort->setParity(QSerialPort::NoParity);
            serialPort->setStopBits(QSerialPort::OneStop);
            serialPort->setFlowControl(QSerialPort::NoFlowControl);
        }

        // Mở cổng UART để kiểm tra kết nối
        if (serialPort->open(QIODevice::ReadWrite)) {
            nutNhanKetNoi->setText("Đã\nkết nối");
            QMessageBox::information(this,
                                     "Thông tin kết nối",
                                     "Đã kết nối tới " + portInfo->portName() + "\nTốc độ Baud "
                                         + danhSachBaud->currentText());
            qDebug() << "Connected to serial port:" << portInfo->portName();
            boxKiemTraIC->setDisabled(false);
            // Ở đây, bạn có thể thực hiện các thao tác truyền dữ liệu hoặc xử lý dữ liệu từ cổng UART
            qDebug() << "ket noi thanh cong";
            // Đóng cổng UART khi kết thúc

            serialPort->close();
        } else {
            if (danhSachCongCOM->currentText() == "" && danhSachCongCOM->count() != 0) {
                QMessageBox::warning(this, "Thông tin kết nối", "Hãy chọn 1 thiết bị");
            } else {
                QMessageBox::warning(this, "Thông tin kết nối", "Hãy kết nối cable với máy tính!");
            }
        }
    });

    QVBoxLayout *lopChonIC = new QVBoxLayout(boxChonIC);
    QListView *khungNhinThuVien = new QListView;
    khungNhinThuVien->setStyleSheet("font-weight: 400;font-size: 15px; color: black");
    QFileSystemModel *moHinhThuVien = new QFileSystemModel;
    QLineEdit *timKiemIC = new QLineEdit;
    timKiemIC->setPlaceholderText("Nhập từ khóa tìm kiếm...");
    timKiemIC->setStyleSheet("font-weight: 400;font-size: 14px; color: normal");
    QLabel *bangHienThiThuocTinhIC = new QLabel("Khu vực hiển thị thông tin IC....");
    bangHienThiThuocTinhIC->setAlignment(Qt::AlignTop);
    bangHienThiThuocTinhIC->setStyleSheet("font-weight: 400;font-size: 15px; color: black");
    bangHienThiThuocTinhIC->setWordWrap(true); // Thiết lập tự động xuống dòng

    lopChonIC->addWidget(timKiemIC);
    lopChonIC->addWidget(khungNhinThuVien);
    lopChonIC->addWidget(bangHienThiThuocTinhIC);

    moHinhThuVien->setRootPath(QDir::currentPath());

    khungNhinThuVien->setModel(moHinhThuVien);

    khungNhinThuVien->setRootIndex(moHinhThuVien->index(QDir::currentPath() + "/library"));

    // Khi một mục được chọn HIỂN THỊ THÔNG TIN LÊN QLABLE
    connect(khungNhinThuVien, &QListView::clicked, this, [=](const QModelIndex &index) {
        if (index.isValid()) {
            // Lấy dữ liệu của chỉ mục hiện tại
            QVariant itemData = khungNhinThuVien->model()->data(index, Qt::DisplayRole);
            // Chuyển đổi dữ liệu thành chuỗi và lấy tên của mục
            itemName = itemData.toString();

            // Loại bỏ 4 ký tự cuối của tên
            itemName = itemName.left(itemName.length() - 4);

            boxKiemTraIC->setTitle("Kiểm tra IC " + itemName);
            // Lấy đường dẫn đầy đủ của tệp được chọn
            filePath = moHinhThuVien->filePath(index);
            nutAutoRun->setText("Chạy tự động");
            nutStop->setText("Dừng");
            // Đọc nội dung của tệp
            QFile file(filePath);
            if (file.open(QIODevice::ReadOnly)) {
                char firstByte;
                QDataStream stream(&file);
                stream >> firstByte;
                soChan = firstByte & (0b01100000);
                firstByte &= (0b00011111);
                viTriByteThuocTinh = static_cast<int>(firstByte);
                // Di chuyển đến byte chứa thông tin IC
                // vị trí 0 là có 1 bài kiểm tra
                file.seek((viTriByteThuocTinh * 10 + 10) + 1);
                qDebug() << QString::number(viTriByteThuocTinh);
                QByteArray fileContent = file.readAll();
                file.close();

                // Hiển thị nội dung trên QTextEdit
                bangHienThiThuocTinhIC->setText(QString(fileContent));
            }
        }
    });

    QVBoxLayout *lopKiemTraIC = new QVBoxLayout(boxKiemTraIC);
    QSplitter *splitKiemTra = new QSplitter;
    splitKiemTra->setStyleSheet("QSplitter::handle { background-color: #F5F5F5; }");
    QProgressBar *thanhTienTrinh = new QProgressBar;
    lopKiemTraIC->addWidget(splitKiemTra);
    lopKiemTraIC->addWidget(thanhTienTrinh, Qt::AlignBottom);
    QWidget *widHienThiKetqua = new QWidget(splitKiemTra);
    QGridLayout *lopSymHienThiKetQua = new QGridLayout(widHienThiKetqua);
    lopSymHienThiKetQua->addWidget(
        new QLabel("<html><body><p style=\"font-size:15px; "
                   "font-weight:550; color: normal;\">Chọn tốc độ kiểm tra: </p></body></html>"),
        0,
        0);
    QComboBox *tocDoKiemTra = new QComboBox;
    tocDoKiemTra->setStyleSheet("font-weight: 500;font-size: 15px; color: black");
    tocDoKiemTra->addItem("Chậm");
    tocDoKiemTra->addItem("Bình Thường");
    tocDoKiemTra->addItem("Nhanh");
    lopSymHienThiKetQua->addWidget(tocDoKiemTra, 0, 1);
    lopSymHienThiKetQua->addWidget(new QLabel(" "), 0, 2);
    lopSymHienThiKetQua->addWidget(new QLabel(" "), 0, 3);
    nutAutoRun = new QPushButton("Chạy tự động");
    nutAutoRun->setFixedWidth(120);
    nutAutoRun->setStyleSheet("QPushButton {"
                              "background-color: #009900;"
                              "color: white;"
                              "font-weight: bold;"
                              "font-size: 16px;"
                              "}"
                              "QPushButton:hover {"
                              "background-color: #007500;"
                              "}");
    lopSymHienThiKetQua->addWidget(nutAutoRun, 0, 4);
    nutStop = new QPushButton("Dừng");
    nutStop->setEnabled(0);
    nutStop->setStyleSheet("QPushButton {"
                           "background-color: yellow;"
                           "color: blue;"
                           "font-weight: bold;"
                           "font-size: 16px;"
                           "}"
                           "QPushButton:hover {"
                           "background-color: #FFE599;"
                           "}");
    lopSymHienThiKetQua->addWidget(nutStop, 1, 4);

    thongTinKiemTra = new QLabel;
    thongTinKiemTra->setAlignment(Qt::AlignTop);
    thongTinKiemTra->setStyleSheet("font-weight: 400;font-size: 15px; color: black");
    QScrollArea *scrollArea = new QScrollArea(this);
    scrollArea->setWidgetResizable(
        true); // Cho phép QScrollArea tự điều chỉnh kích thước cho QLabel bên trong
    scrollArea->setWidget(thongTinKiemTra); // Đặt QLabel vào QScrollArea
    QLabel *nhanThongTinKiemTra = new QLabel("Thông tin kiểm tra");
    nhanThongTinKiemTra->setStyleSheet("font-weight: 600;font-size: 16px; color: blue");
    lopSymHienThiKetQua->addWidget(nhanThongTinKiemTra, 2, 0, 1, 5);
    lopSymHienThiKetQua->addWidget(scrollArea, 3, 0, 1, 5);
    QWidget *widkhungSymIC = new QWidget(splitKiemTra);
    QVBoxLayout *lopkhungSymIC = new QVBoxLayout(widkhungSymIC);
    lopkhungSymIC->setAlignment(Qt::AlignCenter);
    QFrame *khungSymIC = new QFrame;
    lopkhungSymIC->addWidget(khungSymIC);
    //    lopkhungSymIC->addWidget(new QLabel(""));
    khungSymIC->setFixedSize(160, 440); // Đặt kích thước hình chữ nhật
    khungSymIC->setStyleSheet("QFrame {"
                              "   background-color: #A8D9D0;"
                              "   border: 2px solid black;"
                              "   border-radius: 10px;"
                              "}");
    //    biểu tượng các chân IC
    lopChanIC = new QGridLayout(khungSymIC);
    for (int i = 0; i < 10; ++i) {
        for (int j = 0; j < 3; j += 2) {
            pin[i][j] = new QPushButton;
            pin[i][j]->setFixedSize(40, 25);
            pin[i][j]->setEnabled(0);
            pin[i][j]->setStyleSheet("background-color: grey;"
                                     " border-radius: 8px;"
                                     " border: 1px solid blue;");
            lopChanIC->addWidget(pin[i][j], i, j);
        }
    }
    QLabel *gap = new QLabel("   ");
    gap->setStyleSheet("border: normal;");
    lopChanIC->addWidget(gap, 0, 1);

    splitKiemTra->setStretchFactor(0, 1);
    splitKiemTra->setStretchFactor(1, 1);
    //    thanhTienTrinh->setValue(35);
    thanhTienTrinh->setRange(0, 100);
    thanhTienTrinh->setToolTip("Thanh tiến trình kiểm tra");
    // Thiết lập stylesheet cho QProgressBar
    thanhTienTrinh->setStyleSheet("QProgressBar {"
                                  "background: #C0C0C0;"
                                  "font-weight: 620;"
                                  "font-size: 16px;"
                                  "border: 2px solid grey;"
                                  "border-radius: 5px;"
                                  "text-align: center;"
                                  "}"
                                  "QProgressBar::chunk {"
                                  "background-color: orange;"
                                  "width: 20px;" // Điều này sẽ làm cho chunk trông mượt mà hơn
                                  "}");

    //LẬP TRÌNH TRUYỀN NHẬN DỮ LIỆU TỚI PHẦN CỨNG TỪ FILE TRONG THƯ VIỆN

    // Tạo một QTimer để gửi dữ liệu sau mỗi 1 giây
    QTimer *thoiGian1Test = new QTimer;
    chiSoBaiKiemTra = new int(0);
    dataSend = new char[10];
    dataStd = new QVector<char>;
    QObject::connect(thoiGian1Test, &QTimer::timeout, this, [=]() {
        serialPort->open(QIODevice::ReadWrite);
        QFile binFile(filePath); // filePath duong dan toi file duoc chon
        binFile.open(QIODevice::ReadOnly);
        // Di chuyển con trỏ đọc tệp đến byte thứ hai
        binFile.seek(1 + *chiSoBaiKiemTra * 10);
        //    dataDis = new char[10];
        binFile.read(dataSend, 10);
        //    binFile.read(dataDis, 10);
        //    binFile.close(); // Đóng file .bin sau khi đọc xong
        //    Gửi dữ liệu từ sendData qua UART
        serialPort->write(dataSend, 10);
        qDebug() << "Da gui du lieu";
        serialPort->flush();
        binFile.close(); // Đóng file .bin sau khi đọc xong
        //        thongTinKiemTra->setStyleSheet("font-weight: 400;font-size: 16px; color: black");
        thongTinKiemTra->setText(thongTinKiemTra->text() + "\n___ " + itemName + "_test"
                                 + QString::number(*chiSoBaiKiemTra + 1) + " ___\n");

        for (int c = 0; c < 10; ++c) {
            for (int i = 0; i < 10; ++i) {
                dataStd->append(dataSend[i]);
            }
            if (c == 9) {
                emit nhanDu10Byte();
            }
        }

        thanhTienTrinh->setValue(
            static_cast<int>((100 / (viTriByteThuocTinh + 1)) * (*chiSoBaiKiemTra + 1)));

        qDebug() << QString::number(*chiSoBaiKiemTra);
        if (*chiSoBaiKiemTra == viTriByteThuocTinh) {
            thanhTienTrinh->setValue(100);
            thanhTienTrinh->setFormat("Kiểm tra xong: %p%");
            doneCheck = true;

            thoiGian1Test->stop();
            nutStop->setEnabled(0);
            boxChonIC->setEnabled(1);
            //            serialPort->close();
        }
        *chiSoBaiKiemTra = *chiSoBaiKiemTra + 1;
    });
    QObject::connect(nutAutoRun, &QPushButton::clicked, this, [=]() {
        if (tocDoKiemTra->currentText() == "Nhanh") {
            thoiGian1Test->start(100); // 100ms
        } else if (tocDoKiemTra->currentText() == "Bình Thường") {
            thoiGian1Test->start(200); // 200ms
        } else if (tocDoKiemTra->currentText() == "Chậm") {
            thoiGian1Test->start(500); // 500ms
        }
        thongTinKiemTra->clear();
        *chiSoBaiKiemTra = 0;
        thanhTienTrinh->setFormat("Đang kiểm tra: %p%");
        nutAutoRun->setText("Chạy lại");
        nutStop->setText("Dừng");
        nutStop->setEnabled(1);
        boxChonIC->setEnabled(0);
    });
    QObject::connect(nutStop, &QPushButton::clicked, this, [=]() {
        if (nutStop->text() == "Dừng") {
            thoiGian1Test->stop();
            nutStop->setText("Tiếp Tục");
            boxChonIC->setEnabled(1);

        } else if (nutStop->text() == "Tiếp Tục") {
            thoiGian1Test->start();

            nutStop->setText("Dừng");
        }
    });

    resultPin = new QByteArray();
    QObject::connect(serialPort, &QSerialPort::readyRead, this, [=]() {
        resultPin->append(serialPort->readAll()); // Đọc 1 byte từ cổng serial
        //        qDebug() << "Received 1 byte:" << data->size();
        //        if (data->size() == 1) {

        if (resultPin->size() == 3) {
            //            qDebug() << resultPin->toHex();
            hasZeroBit = false;
            donePin = false;
            // Lấy con trỏ đến dữ liệu trong QByteArray
            const char *data = resultPin->constData();
            //            const int dataSize = resultPin->size();

            // Kiểm tra xem có bit nào mang giá trị 0 không

            for (int i = 0; i < 3; ++i) {
                char byteValue = data[i];
                // Kiểm tra từng bit trong byte
                for (int j = 0; j < 8; ++j) {
                    if (!(byteValue & (1 << j))) {
                        icFail = true;
                        hasZeroBit = true;
                        //                        thongTinKiemTra->setStyleSheet(
                        //                            "font-weight: 400;font-size: 15px;  color: red");
                        //                        thongTinKiemTra->setText(
                        //                            thongTinKiemTra->text() + "Vị trí của bit 0 trong byte thứ "
                        //                            + QString::number(i) + " là: " + QString::number(j) + "\n");
                        switch (i) {
                        case 0:
                            switch (j) {
                            case 0:
                                thongTinKiemTra->setText(thongTinKiemTra->text() + "Chân 9 lỗi \n");
                                break;
                            case 1:
                                if (soChan == 0b00000000) { //thể hiện IC 14 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 8 lỗi \n");
                                } else if (soChan == 0b00100000) { // thể hiện IC 16 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 10 lỗi \n");
                                }
                                break;
                            case 2:
                                if (soChan == 0b00000000) { //thể hiện IC 14 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 9 lỗi \n");
                                } else if (soChan == 0b00100000) { // thể hiện IC 16 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 11 lỗi \n");
                                }
                                break;
                            case 3:
                                if (soChan == 0b00000000) { //thể hiện IC 14 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 10 lỗi \n");
                                } else if (soChan == 0b00100000) { // thể hiện IC 16 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 12 lỗi \n");
                                }
                                break;
                            case 4:
                                if (soChan == 0b00000000) { //thể hiện IC 14 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 11 lỗi \n");
                                } else if (soChan == 0b00100000) { // thể hiện IC 16 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 13 lỗi \n");
                                }
                                break;
                            case 5:
                                if (soChan == 0b00000000) { //thể hiện IC 14 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 12 lỗi \n");
                                } else if (soChan == 0b00100000) { // thể hiện IC 16 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 14  lỗi \n");
                                }
                                break;
                            case 6:
                                if (soChan == 0b00000000) { //thể hiện IC 14 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 13 lỗi \n");
                                } else if (soChan == 0b00100000) { // thể hiện IC 16 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 15  lỗi \n");
                                }
                                break;
                            case 7:
                                if (soChan == 0b00000000) { //thể hiện IC 14 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 14 lỗi \n");
                                } else if (soChan == 0b00100000) { // thể hiện IC 16 Chân
                                    thongTinKiemTra->setText(thongTinKiemTra->text()
                                                             + "Chân 16  lỗi \n");
                                }

                                break;
                            default:
                                qDebug() << "Unknown";
                                break;
                            }
                            break;
                        case 1:
                            switch (j) {
                            case 0:
                                thongTinKiemTra->setText(thongTinKiemTra->text() + "Chân 5 lỗi \n");
                                break;
                            case 1:
                                thongTinKiemTra->setText(thongTinKiemTra->text() + "Chân 6 lỗi \n");
                                break;
                            case 2:
                                thongTinKiemTra->setText(thongTinKiemTra->text() + "Chân 7 lỗi \n");
                                break;
                            case 3:
                                thongTinKiemTra->setText(thongTinKiemTra->text() + "Chân 8 lỗi \n");
                                break;
                                //                            case 4:
                                //                                thongTinKiemTra->setText("Chân 8 lỗi \n");
                                //                                break;
                                //                            case 5:
                                //                                thongTinKiemTra->setText("Chân 8 lỗi \n");
                                //                                break;
                                //                            case 6:
                                //                                thongTinKiemTra->setText("Chân 8 lỗi \n");
                                //                                break;
                                //                            case 7:
                                //                                thongTinKiemTra->setText("Chân 8 lỗi \n");
                                //                                break;
                                //                            default:
                                //                                qDebug() << "Unknown";
                                //                                break;
                            }
                            break;
                        case 2:
                            switch (j) {
                                //                            case 0:
                                //                                thongTinKiemTra->setText("Chân 8 lỗi \n");
                                //                                break;
                                //                            case 1:
                                //                                thongTinKiemTra->setText("Chân 8 lỗi \n");
                                //                                break;
                                //                            case 2:
                                //                                thongTinKiemTra->setText("Chân 8 lỗi \n");
                                //                                break;
                                //                            case 3:
                                //                                thongTinKiemTra->setText("Chân 8 lỗi \n");
                                //                                break;
                            case 4:
                                thongTinKiemTra->setText(thongTinKiemTra->text() + "Chân 1 lỗi \n");
                                break;
                            case 5:
                                thongTinKiemTra->setText(thongTinKiemTra->text() + "Chân 2 lỗi \n");
                                break;
                            case 6:
                                thongTinKiemTra->setText(thongTinKiemTra->text() + "Chân 3 lỗi \n");
                                break;
                            case 7:
                                thongTinKiemTra->setText(thongTinKiemTra->text() + "Chân 4 lỗi \n");
                                break;
                            default:
                                qDebug() << "Unknown";
                                break;
                            }
                            break;
                        default:
                            break;
                        }

                        //                        qDebug() << "Vị trí của bit 0 trong byte thứ " << i << " là: " << j;
                    }
                    if (i == 2 && j == 7) {
                        donePin = true;
                    }
                }
            }
            if (!hasZeroBit) {
                thongTinKiemTra->setText(thongTinKiemTra->text() + "Không phát hiện lỗi\n");
                //                qDebug() << "Không có bit mang giá trị 0.\n";
            }
            if (doneCheck && donePin) {
                serialPort->close();
                doneCheck = false;
                if (!icFail) {
                    QMessageBox msgBox;
                    msgBox.setWindowTitle("Thông báo");
                    msgBox.setText("Kiểm tra hoàn tất \nKhông phát hiện lỗi !!!");

                    msgBox.setIcon(QMessageBox::Information); // Thiết lập kiểu thông báo

                    // Áp dụng CSS chỉ cho phần nội dung văn bản
                    msgBox.setStyleSheet("QMessageBox QLabel {font-weight: 600; font-size: "
                                         "16px;  color: green;}");

                    msgBox.exec();
                } else {
                    icFail = false;
                    QMessageBox msgBox;
                    msgBox.setWindowTitle("Thông báo");
                    msgBox.setText("Kiểm tra hoàn tất \nĐã phát hiện lỗi !!!");

                    msgBox.setIcon(QMessageBox::Warning); // Thiết lập kiểu thông báo

                    // Áp dụng CSS chỉ cho phần nội dung văn bản
                    msgBox.setStyleSheet("QMessageBox QLabel { font-weight: 600; font-size: "
                                         "16px;  color: red; }");

                    msgBox.exec();
                }
            }

            resultPin->clear();
        }
    });

    QObject::connect(this, SIGNAL(nhanDu10Byte()), this, SLOT(indicateLed()));
}

void KiemTra::indicateLed()
{
    //    qDebug() << "Hien thi trang thai";
    //    char *receiveData = new char[10]{0};
    char duLieuGanChanIC[10][3];
    //        HIEN THI THONG TIN TU DU LIEU NHAN DUOC LEN khungSymIC
    for (int i = 0; i < 10; ++i) {
        // 4 bit trọng số cao mang thông tin hàng chân bên trái
        duLieuGanChanIC[i][0] = (*dataStd)[i] & (0b00110000);
    }
    for (int i = 0; i < 10; ++i) {
        // 4 bit trọng số thấp mang thông tin hàng chân bên phải
        duLieuGanChanIC[i][2] = (*dataStd)[i] & (0b00000011);
    }

    //    thêm cấu chân IC từ file dữ liệu nhận về
    for (int i = 0; i < 10; ++i) {
        for (int j = 0; j < 3; j += 2) {
            //Nếu chân dữ liệu không kết nối
            if (duLieuGanChanIC[i][j] == (0b00110000) // NC
                || duLieuGanChanIC[i][j] == (0b00000011)) {
                pin[i][j]->setStyleSheet("background-color: grey;"
                                         " border-radius: 8px;"
                                         " border: 1px solid blue;");
                lopChanIC->addWidget(pin[i][j], i, j);

                //nếu chân dữ liệu kết nối với nguồn VCC hoặc mang mức logic 1
            } else if (duLieuGanChanIC[i][j] == (0b00010000) // LOGIC 1
                       || duLieuGanChanIC[i][j] == (0b00000001)) {
                pin[i][j]->setStyleSheet("background-color: green;"
                                         " border-radius: 8px;"
                                         " border: 1px solid blue;");
                lopChanIC->addWidget(pin[i][j], i, j);
                //nếu chân dữ liệu kết nối với đất hoặc mang mức logic 0
            } else if (duLieuGanChanIC[i][j] == (0b00100000) //LOGIC 0
                       || duLieuGanChanIC[i][j] == (0b00000010)) {
                pin[i][j]->setStyleSheet("background-color: red;"
                                         " border-radius: 8px;"
                                         " border: 1px solid blue;");
                lopChanIC->addWidget(pin[i][j], i, j);
            } else /* if (duLieuGanChanIC[i][j] == (0b00000000) //Không xác định
                                       || duLieuGanChanIC[i][j] == (0b00000000))*/
            {
                pin[i][j]->setStyleSheet("background-color: white;"
                                         " border-radius: 8px;"
                                         " border: 1px solid blue;");
                lopChanIC->addWidget(pin[i][j], i, j);
            }
        }
    }
    //thực hiện giải phóng bộ nhớ
    dataStd->clear();
    std::memset(duLieuGanChanIC, 0, sizeof(duLieuGanChanIC));
}
//void KiemTra::sendData(QString &filePath, QSerialPort &serialPort)
//{
//    dataSerial->sendData(filePath, serialPort);
//}
KiemTra::~KiemTra()
{
    serialPort->close();
    delete chiSoBaiKiemTra;
    delete dataStd;
    delete resultPin;
    delete[] dataSend;
}

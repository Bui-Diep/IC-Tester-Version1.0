#include "xemthuvien.h"

XemThuVien::XemThuVien(QWidget *parent)
    : QWidget{parent}
{
    QHBoxLayout *lopHienThiThuVien = new QHBoxLayout(this);
    QVBoxLayout *lopTimKiem = new QVBoxLayout;
    QGroupBox *boxHienThiThongTin = new QGroupBox("Hiển thị thông tin");
    QVBoxLayout *lopHienThiThongTin = new QVBoxLayout;
    QListView *khungNhinThuVien = new QListView;
    khungNhinThuVien->setStyleSheet("font-size: 15px");
    QFileSystemModel *moHinhThuVien = new QFileSystemModel;
    QLineEdit *timKiemIC = new QLineEdit;
    timKiemIC->setStyleSheet("font-size: 15px");
    timKiemIC->setPlaceholderText("Nhập từ khóa tìm kiếm...");
    QLabel *bangHienThiThuocTinhIC = new QLabel("Khu vực hiển thị thông tin IC....");
    bangHienThiThuocTinhIC->setAlignment(Qt::AlignTop);
    bangHienThiThuocTinhIC->setStyleSheet("font-weight: 400;font-size: 15px; color: black");
    bangHienThiThuocTinhIC->setWordWrap(true); // Thiết lập tự động xuống dòng

    lopTimKiem->addWidget(timKiemIC);
    lopTimKiem->addWidget(khungNhinThuVien);
    lopHienThiThongTin->addWidget(bangHienThiThuocTinhIC);
    boxHienThiThongTin->setLayout(lopHienThiThongTin);
    boxHienThiThongTin->setStyleSheet("font-weight: bold;font-size: 16px; color: #0000FF");
    boxHienThiThongTin->setFixedWidth(400);

    lopHienThiThuVien->addLayout(lopTimKiem);
    lopHienThiThuVien->addWidget(boxHienThiThongTin);

    moHinhThuVien->setRootPath(QDir::currentPath());

    khungNhinThuVien->setModel(moHinhThuVien);

    khungNhinThuVien->setRootIndex(moHinhThuVien->index(QDir::currentPath() + "/library"));
    moHinhThuVien->setFilter(QDir::NoDotAndDotDot | QDir::AllEntries);

    // Khi một mục được chọn
    connect(khungNhinThuVien, &QListView::clicked, this, [=](const QModelIndex &index) {
        if (index.isValid()) {
            // Lấy đường dẫn đầy đủ của tệp được chọn
            QString filePath = moHinhThuVien->filePath(index);

            // Đọc nội dung của tệp
            QFile file(filePath);
            if (file.open(QIODevice::ReadOnly)) {
                char firstByte;
                QDataStream stream(&file);
                stream >> firstByte;
                firstByte &= (0b00011111);
                int viTriByteThuocTinh = static_cast<int>(firstByte);
                // Di chuyển đến byte chứa thông tin IC
                file.seek((viTriByteThuocTinh * 10 + 10) + 1);

                // Đọc nội dung từ byte thứ 5 đến hết
                QByteArray fileContent = file.readAll();
                file.close();

                // Hiển thị nội dung trên QTextEdit
                bangHienThiThuocTinhIC->setText(QString(fileContent));
            }
        }
    });

    khungNhinThuVien->setContextMenuPolicy(Qt::CustomContextMenu);

    connect(khungNhinThuVien, &QListView::customContextMenuRequested, this, [=](const QPoint &pos) {
        QModelIndex index = khungNhinThuVien->indexAt(pos);
        if (index.isValid()) {
            QString filePath = moHinhThuVien->filePath(index);
            QMenu contextMenu;
            QAction actionEdit("Chỉnh sửa", &contextMenu);
            QAction actionDelete("Xóa", &contextMenu);

            connect(&actionEdit, &QAction::triggered, this, [=]() {
                QMessageBox::information(this,
                                         "Chỉnh sửa",
                                         "Bạn đã chọn chỉnh sửa tệp " + filePath
                                             + "\nTính năng này sẽ sớm được cập nhật");
            });

            connect(&actionDelete, &QAction::triggered, this, [=]() {
                if (QFile::remove(filePath)) {
                    moHinhThuVien->remove(index);
                    bangHienThiThuocTinhIC->setText("Khu vực hiển thị thông tin IC....");
                } else {
                    QMessageBox::warning(this, "Lỗi", "Không thể xóa tệp " + filePath);
                }
            });

            contextMenu.addAction(&actionEdit);
            contextMenu.addAction(&actionDelete);

            contextMenu.exec(khungNhinThuVien->mapToGlobal(pos));
        }
    });
}

# Hệ thống quản trị SmartFarm

Họ và tên: Thi Thành Đạt  
MSSV: N26DTCN041  
Lớp: CNTT2  
Email: thithanhdat111@gmail.com

## 1. Cấu trúc và cách tạo thư mục

Toàn bộ bài làm nằm trong thư mục `smartfarm-system`. Bốn thư mục con là `docs`, `scripts`, `data` và `backup`.

Từ thư mục muốn đặt dự án, em dùng **một dòng lệnh PowerShell** sau để tạo đủ cây thư mục:

```powershell
New-Item -ItemType Directory -Path smartfarm-system,smartfarm-system/docs,smartfarm-system/scripts,smartfarm-system/data,smartfarm-system/backup -Force
```

Khi đang đứng trong `smartfarm-system/data`, em tạo `.env` ở thư mục gốc bằng `..` (nghĩa là đi lên một cấp) và đặt thuộc tính ẩn:

```powershell
Set-Content -Path ..\.env -Value 'DB_PASSWORD=demo_123456'
(Get-Item -Path ..\.env -Force).Attributes = 'Hidden'
```

Mật khẩu trên chỉ là dữ liệu giả định theo đề. Thuộc tính Hidden có tác dụng trên máy Windows; GitHub không giữ thuộc tính ẩn này.

## 2. Hướng dẫn chạy script

Mở PowerShell tại thư mục gốc của repository rồi chạy:

```powershell
cd .\smartfarm-system\scripts
.\auto_report.ps1
```

Nếu PowerShell chặn script do ExecutionPolicy, chạy lệnh sau ngay trong thư mục `scripts`:

```powershell
powershell -ExecutionPolicy Bypass -File .\auto_report.ps1
```

Script đọc `..\data\log-he-thong.log`, lọc các dòng `[ERROR]` và `[CRITICAL]`, rồi ghi báo cáo vào `..\backup\bao-cao-su-co.txt`. Mỗi lần chạy, ngày giờ báo cáo lấy từ `Get-Date`, không nhập cố định.

## 3. Checklist kiểm tra thiết bị

- [x] Đối chiếu 10 mã linh kiện của các trạm với danh mục bằng TRIM và VLOOKUP; không còn `#N/A`.
- [x] Kiểm tra log: có 8 dòng lỗi nghiêm trọng, trong đó 4 dòng liên quan `sensor-03`.
- [ ] Kiểm tra thực tế nguồn điện và đường truyền của `sensor-03`.
- [ ] Kiểm tra ổ đĩa của database vì log báo dung lượng sử dụng 97%.

## 4. Bảng thông số phần cứng

Dữ liệu lấy từ sheet `danh-muc-linh-kien` của file Excel được cung cấp. Đơn giá tính bằng đồng.

| Mã linh kiện | Tên thiết bị | Đơn giá (đồng) | Loại storage |
| --- | --- | ---: | --- |
| LK01 | Raspberry Pi 4 Model B | 1.450.000 | SSD |
| LK02 | Intel NUC i3 | 6.200.000 | SSD |
| LK03 | Orange Pi 5 | 2.300.000 | SSD |
| LK04 | Dell Optiplex Micro | 5.400.000 | HDD |
| LK05 | Mini PC Fanless N100 | 4.200.000 | SSD |
| LK06 | Synology DS220j NAS | 3.900.000 | HDD |

Trong sheet `trang-thai-tram`, cột `ma_linh_kien_sach` dùng `=TRIM(B2)` và cột `ten_thiet_bi` dùng `=VLOOKUP(E2,'danh-muc-linh-kien'!$A$2:$D$7,2,FALSE)`. Em sao chép hai công thức xuống hết 10 trạm và bật AutoFilter. `FALSE` yêu cầu mã khớp chính xác; dấu `$` giữ nguyên vùng danh mục khi sao chép công thức.

## 5. Phân tích hệ thống

### Mô hình IPO của chức năng lọc log

- **Input (đầu vào):** file `data/log-he-thong.log`, gồm các dòng nhật ký có ngày giờ, mức độ và nội dung sự kiện.
- **Process (xử lý):** đọc từng dòng, giữ dòng có `[ERROR]` hoặc `[CRITICAL]`, sau đó đếm số dòng được giữ.
- **Output (đầu ra):** file `backup/bao-cao-su-co.txt` có tiêu đề, ngày giờ tạo báo cáo, các dòng sự cố và tổng số. Với log được cung cấp, tổng số là **8**.

### Phân loại theo DIKW

DIKW là cách đi từ dữ liệu thô đến quyết định hành động:

- **Data (dữ liệu):** (b) Dòng log `2026-10-12 08:15:01 [ERROR] sensor-03 Connection TIMEOUT after 30s` là một ghi nhận riêng lẻ.
- **Information (thông tin):** (c) Thống kê 8 sự cố, trong đó 4 sự cố từ `sensor-03`, là dữ liệu đã được tổng hợp.
- **Knowledge (kiến thức):** (d) Phát biểu nêu nguyên nhân sóng yếu và giải pháp lắp anten cho `sensor-03`.
- **Wisdom (quyết định):** (a) Quyết định thay modem của `sensor-03` trước thứ Sáu là hành động cụ thể.

Nguyên nhân sóng yếu trong phát biểu (d) là thông tin đề bài cho để phân loại; riêng file log chưa đủ để tự kiểm chứng nguyên nhân này.

## 6. Bẫy phần cứng

Tốc độ mạng **100 Mbps** là megabit mỗi giây, còn kích thước file **500 MB** là megabyte. Vì 1 byte = 8 bit nên:

`100 Mbps ÷ 8 = 12,5 MB/s`

`500 MB ÷ 12,5 MB/s = 40 giây`

Vậy thời gian tải lý tưởng là **40 giây**. Thực tế có thể lâu hơn do tốc độ mạng và giao thức truyền tải.

# Star Explorer 360

Star Explorer 360 là ứng dụng tham quan không gian 360 độ được xây dựng bằng Flutter cho bài kiểm tra Thực tập sinh Lập trình App Mobile của StarGlobal.

Ứng dụng có hai địa điểm: phòng trưng bày điêu khắc và sân kiến trúc ngoài trời. Người dùng có thể vuốt để quan sát, phóng to hoặc thu nhỏ, mở thông tin tại các hotspot và chuyển giữa hai panorama.

Ứng dụng không sử dụng WebView và có thể hoạt động hoàn toàn offline sau khi cài đặt.

## APK

- File cài đặt: [`release/star-explorer-360-v1.0.0.apk`](release/star-explorer-360-v1.0.0.apk)
- Phiên bản: `1.0.0+1`
- Dung lượng: 23.416.348 byte (22,3 MB)
- SHA-256: `C9C476662445ACB660B81DD08D7AC7CEE758C0664D8A80482CEC4083F3E44C5F`
- Android application ID: `com.nhahn.star_global_360`

APK được build ở chế độ release và có thể cài trực tiếp để chấm bài.

## Tính năng đã hoàn thành

- Màn hình Home hiển thị danh sách địa điểm.
- Hai ảnh panorama 360 độ, kích thước `4096 x 2048`.
- Mỗi panorama có 3 hotspot, tổng cộng 6 hotspot.
- 4 hotspot thông tin có tiêu đề, mô tả và hình ảnh.
- 2 hotspot điều hướng để chuyển giữa các panorama.
- Có hiệu ứng mờ dần khi chuyển panorama.
- Vuốt để xoay góc nhìn.
- Chụm hai ngón tay để phóng to hoặc thu nhỏ.
- Hotspot giữ đúng vị trí khi panorama xoay hoặc zoom.
- Có trạng thái tải ảnh, báo lỗi và thử lại.
- Giao diện Material 3 tối giản và responsive.
- Có launcher icon riêng cho Android.
- Dữ liệu và hình ảnh được lưu cục bộ, không cần Internet.
- Có kiểm tra dữ liệu JSON và test tự động.

## Kiến trúc dự án

Dự án sử dụng cấu trúc feature-first. Phần dữ liệu, trạng thái và giao diện được tách riêng để code dễ đọc và dễ mở rộng.

```text
lib/
|-- app/
|   |-- app.dart
|   `-- theme.dart
|-- core/
|   |-- errors/
|   `-- widgets/
|-- features/
|   `-- panorama/
|       |-- data/
|       |   |-- datasources/
|       |   |-- models/
|       |   `-- repositories/
|       `-- presentation/
|           |-- controllers/
|           |-- screens/
|           `-- widgets/
`-- main.dart

assets/
|-- data/panoramas.json
|-- images/
`-- panoramas/
```

Luồng dữ liệu của ứng dụng:

```text
panoramas.json
    -> PanoramaLocalDataSource
    -> PanoramaRepository
    -> PanoramaCatalogController
    -> HomeScreen / PanoramaViewerScreen
```

- `PanoramaLocalDataSource` đọc file JSON.
- `PanoramaRepository` kiểm tra quan hệ giữa panorama và hotspot.
- `PanoramaCatalogController` quản lý trạng thái cho giao diện.
- `HomeScreen` và `PanoramaViewerScreen` hiển thị dữ liệu cho người dùng.

Dự án dùng `ChangeNotifier` có sẵn trong Flutter. Với ứng dụng chỉ có hai màn hình, cách này đơn giản và không cần thêm thư viện quản lý trạng thái.

## Quản lý dữ liệu

Thông tin panorama và hotspot được quản lý trong file [`assets/data/panoramas.json`](assets/data/panoramas.json), không viết trực tiếp trong widget.

Mỗi panorama gồm:

- ID, tiêu đề, phụ đề và mô tả.
- Ảnh thumbnail và ảnh panorama.
- Góc nhìn và mức zoom ban đầu.
- Danh sách hotspot.

Mỗi hotspot gồm:

- ID và loại hotspot.
- Tọa độ `latitude` và `longitude`.
- Tiêu đề và mô tả.
- Hình ảnh tùy chọn.
- ID panorama đích nếu là hotspot điều hướng.

Ứng dụng kiểm tra các lỗi dữ liệu như thiếu trường bắt buộc, ID trùng, tọa độ sai phạm vi hoặc panorama đích không tồn tại.

## Thư viện sử dụng

| Thư viện | Phiên bản | Mục đích |
|---|---:|---|
| Flutter SDK | 3.29.3 | Xây dựng giao diện, điều hướng và quản lý tài nguyên |
| `panorama_viewer` | 2.0.7 | Render panorama, xử lý xoay, zoom và hotspot |

`panorama_viewer` sử dụng `flutter_cube` ở bên trong để tạo bề mặt hình cầu. Chế độ cảm biến được tắt trong phiên bản hiện tại; người dùng điều khiển góc nhìn bằng thao tác chạm.

## Báo cáo nghiên cứu

### 1. Quá trình nghiên cứu

#### Tôi đã nghiên cứu vấn đề như thế nào?

1. Đọc đề bài và chia yêu cầu thành hai nhóm: bắt buộc và khuyến khích.
2. Tìm hiểu định dạng ảnh equirectangular dùng cho panorama 360 độ. Đây là ảnh có tỷ lệ 2:1 và được chiếu lên mặt trong của một hình cầu.
3. So sánh hai hướng triển khai: mở trình xem panorama bằng WebView hoặc render trực tiếp trong Flutter.
4. Kiểm tra các thư viện Flutter có hỗ trợ vuốt, zoom, hotspot và tọa độ hình cầu.
5. Chọn `panorama_viewer` và làm thử phần đọc JSON trước khi xây dựng giao diện.
6. Tối ưu ảnh panorama về `4096 x 2048` để giảm dung lượng và bộ nhớ sử dụng.
7. Build ứng dụng và kiểm tra trực tiếp trên điện thoại vivo V2041.
8. Dùng công cụ hiệu chỉnh của viewer để đặt hotspot đúng lên từng vật thể.

#### Tài liệu đã tham khảo

- [Google Photo Sphere metadata](https://developers.google.com/streetview/spherical-metadata): tìm hiểu ảnh equirectangular và hướng của panorama.
- [`panorama_viewer` trên pub.dev](https://pub.dev/packages/panorama_viewer): kiểm tra tính năng, nền tảng hỗ trợ và giấy phép.
- [`PanoramaViewer` API](https://pub.dev/documentation/panorama_viewer/latest/panorama_viewer/PanoramaViewer-class.html): tìm hiểu cách xoay, zoom, đặt góc nhìn và bắt sự kiện.
- [`Hotspot` API](https://pub.dev/documentation/panorama_viewer/latest/panorama_viewer/Hotspot-class.html): tìm hiểu cách đặt hotspot bằng latitude và longitude.
- [Flutter assets](https://docs.flutter.dev/ui/assets/assets-and-images): tìm hiểu cách đóng gói JSON và hình ảnh trong ứng dụng.

### 2. Giải pháp lựa chọn

#### Vì sao tôi chọn giải pháp này?

Tôi chọn Flutter kết hợp với `panorama_viewer` vì thư viện có thể render panorama trực tiếp mà không cần WebView. Thư viện cũng hỗ trợ sẵn các thao tác quan trọng như vuốt, zoom và đặt hotspot bằng tọa độ hình cầu.

Giải pháp này có API tương đối nhỏ, dễ đọc và phù hợp với thời gian làm bài test. Nhờ đó tôi có thể tập trung thêm vào giao diện, kiểm tra dữ liệu, xử lý lỗi, test và tài liệu.

Dữ liệu được lưu bằng local JSON vì bài test cần một bản demo tự chứa và không bắt buộc backend. Data source và repository được tách riêng nên sau này có thể chuyển sang REST API hoặc local database mà không phải viết lại phần giao diện.

#### Giải pháp đáp ứng được những yêu cầu nào?

- Sử dụng Flutter và chạy trên Android.
- Không sử dụng WebView.
- Hiển thị panorama 360 độ.
- Vuốt để xoay và chụm để zoom.
- Hotspot bám đúng vị trí trong panorama.
- Hotspot có thể mở thông tin gồm tiêu đề, mô tả và hình ảnh.
- Hotspot có thể chuyển sang panorama khác.
- Có hiệu ứng chuyển cảnh.
- Dữ liệu được quản lý bằng JSON.
- Có 2 panorama và mỗi panorama có 3 hotspot.
- Có màn hình Home và Panorama Viewer.
- Có source code, APK và README.

### 3. Đánh giá

#### Ưu điểm

- Không dùng WebView nên trải nghiệm đồng nhất với ứng dụng Flutter.
- Ứng dụng hoạt động offline, không phụ thuộc đường truyền mạng.
- Ảnh panorama đã được tối ưu để tải nhanh hơn và giảm bộ nhớ.
- Hotspot dùng tọa độ hình cầu nên không bị trôi khi xoay hoặc zoom.
- Nội dung được quản lý bằng JSON, dễ thêm panorama và hotspot mới.
- Cấu trúc thư mục gọn và các phần có trách nhiệm rõ ràng.
- Giao diện tối giản, tập trung vào nội dung 360 độ.
- Có xử lý loading, lỗi dữ liệu và lỗi hình ảnh.
- Có test tự động và đã kiểm tra trên điện thoại thật.

#### Hạn chế

- Dữ liệu đang đóng gói trong ứng dụng nên muốn thay đổi nội dung phải build APK mới.
- Chưa có cơ chế chia ảnh thành nhiều mức độ phân giải cho panorama rất lớn.
- Chưa có backend hoặc hệ thống quản trị nội dung.
- Chế độ điều khiển bằng gyroscope đang được tắt.
- Hiện tại mới kiểm tra trên một mẫu điện thoại Android.
- Chưa có bản iOS.
- APK đang dùng development key để phục vụ việc chấm bài, chưa dùng production signing key.

#### Khó khăn gặp phải

- Ảnh panorama gốc có dung lượng lớn, vì vậy cần giảm kích thước nhưng vẫn giữ đúng tỷ lệ 2:1.
- Hotspot phải bám đúng vật thể khi người dùng xoay. Tôi giải quyết bằng tọa độ latitude và longitude thay vì tọa độ màn hình.
- Tọa độ hotspot ban đầu chưa chính xác. Tôi đã cài app lên điện thoại, chạm trực tiếp lên vật thể để lấy tọa độ và hiệu chỉnh lại.
- Bottom sheet có hình ảnh từng bị tràn trên màn hình thấp. Nội dung đã được chuyển sang dạng có thể cuộn.
- Viewer từng chỉ hiển thị ở phần trên màn hình. Lỗi được sửa bằng cách điều chỉnh lại `Stack` và app bar overlay.

### 4. Hướng phát triển

Nếu có thêm thời gian, tôi sẽ cải tiến ứng dụng theo thứ tự sau:

1. Thêm integration test cho luồng Home, Viewer, mở hotspot và chuyển panorama.
2. Kiểm tra hiệu năng trên nhiều thiết bị Android cấu hình thấp, trung bình và cao.
3. Thêm API quản lý nội dung, có cache để vẫn sử dụng được khi mất mạng.
4. Sử dụng panorama nhiều mức độ phân giải để tải ảnh lớn nhanh hơn.
5. Thêm chế độ gyroscope và nút bật hoặc tắt rõ ràng.
6. Thêm mini-map và tour tự động theo từng điểm.
7. Bổ sung Favorite và History nếu phù hợp với sản phẩm thực tế.
8. Thêm analytics để theo dõi lượt mở hotspot và chuyển panorama.
9. Build phiên bản iOS.
10. Kiểm tra accessibility bằng TalkBack và VoiceOver.

## Tối ưu hiệu năng

- Hai panorama được giảm về `4096 x 2048` thay vì dùng ảnh gốc trên 8K.
- Hai ảnh panorama sau tối ưu có tổng dung lượng khoảng 2,5 MB.
- Ảnh chi tiết hotspot rộng 1280 pixel và được nén riêng.
- Toàn bộ JSON và hình ảnh được lưu cục bộ nên không có độ trễ mạng.
- Zoom được giới hạn trong khoảng `1x` đến `3x`.
- Mỗi thời điểm chỉ có panorama đang xem được tương tác.

## Cách chạy project

Yêu cầu:

- Flutter 3.29 hoặc mới hơn.
- Dart 3.7 hoặc mới hơn.
- Android SDK.
- Máy ảo Android hoặc điện thoại Android đã bật USB debugging.

Chạy các lệnh:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Build APK release:

```bash
flutter build apk --release
```

APK sau khi build nằm tại:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Kết quả kiểm thử

- `flutter analyze`: không có lỗi.
- `flutter test`: 4 test đều thành công.
- `flutter build apk --debug`: thành công.
- `flutter build apk --release`: thành công.
- Đã cài và kiểm tra trên vivo V2041, độ phân giải `1080 x 2408`.
- Đã kiểm tra hiển thị toàn màn hình, thao tác vuốt, vị trí hotspot, popup hình ảnh và chuyển panorama.

## Nguồn hình ảnh

Hai panorama gốc được cung cấp bởi [Poly Haven](https://polyhaven.com/) với giấy phép [CC0](https://polyhaven.com/license).

- [Sculpture Exhibition](https://polyhaven.com/a/sculpture_exhibition) của Oliksiy Yakovlyev.
- [Urban Courtyard](https://polyhaven.com/a/urban_courtyard) của Greg Zaal.

Bốn ảnh chi tiết hotspot được tạo lại từ các panorama CC0 trên với sự hỗ trợ của AI, sau đó được giảm kích thước và nén cho thiết bị di động.

Xem thêm thông tin về thư viện và tài nguyên tại [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

import 'package:dio/dio.dart';
import 'api_errors.dart';

// Endpoint yang digunakan:
// POST   /devices        — daftarkan / perbarui token
// DELETE /devices/{token} — cabut token (saat logout)
class DeviceRepository {
  DeviceRepository({required this._dio});

  final Dio _dio;

  // Kirim fcmToken ke backend (POST /devices)
  Future<void> registerToken(String fcmToken) async {
    try {
      await _dio.post<void>(
        '/devices',
        data: {'fcm_token': fcmToken},
      );
    } on DioException catch (e) {
      throwAppException(e);
    }
  }

  // Hapus fcmToken dari backend (DELETE /devices/{token})
  // Panggil saat user logout agar backend tidak mengirim push ke device
  Future<void> unregisterToken(String fcmToken) async {
    try {
      await _dio.delete<void>('/devices/$fcmToken');
    } on DioException catch (e) {
      throwAppException(e);
    }
  }
}

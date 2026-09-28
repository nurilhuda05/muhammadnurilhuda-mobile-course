import 'package:dio/dio.dart';

// Konversi DioException ke pesan ramah pengguna.
// Repository cukup memanggil friendlyMessage(e) dan melempar AppException.
// UI hanya perlu menampilkan AppException.message, tanpa tahu detail Dio.

class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

String friendlyMessage(DioException e) {
  // Tidak ada respons = tidak ada koneksi atau timeout
  if (e.response == null) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Koneksi terlalu lama. Periksa jaringan dan coba lagi.',
      DioExceptionType.connectionError =>
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      _ => 'Terjadi kesalahan jaringan. Coba lagi.',
    };
  }

  return switch (e.response!.statusCode) {
    400 => 'Permintaan tidak valid. Periksa data yang dikirim.',
    401 => 'Sesi habis. Silakan masuk kembali.',
    403 => 'Anda tidak memiliki akses ke halaman ini.',
    404 => 'Data tidak ditemukan.',
    422 => 'Data yang dikirim tidak sesuai format.',
    500 || 502 || 503 => 'Server sedang bermasalah. Coba beberapa saat lagi.',
    _ => 'Terjadi kesalahan (${e.response!.statusCode}). Coba lagi.',
  };
}

// Singkatan: lempar AppException langsung dari DioException
Never throwAppException(DioException e) =>
    throw AppException(friendlyMessage(e));

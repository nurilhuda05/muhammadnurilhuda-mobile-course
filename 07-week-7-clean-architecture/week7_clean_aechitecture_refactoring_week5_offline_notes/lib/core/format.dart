/// Fungsi-fungsi murni (pure functions) untuk formatting dan parsing.
///
/// Ditempatkan di `core/` agar bisa diuji tanpa widget
/// dan digunakan oleh semua fitur.
library;

// ── Formatting Tanggal ────────────────────────────────

const _bulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// Format DateTime lengkap: "05 Okt 2026, 14:30"
String formatDateTime(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = _bulan[date.month - 1];
  final y = date.year;
  final h = date.hour.toString().padLeft(2, '0');
  final min = date.minute.toString().padLeft(2, '0');
  return '$d $m $y, $h:$min';
}

/// Format hanya tanggal: "05 Okt 2026"
String formatDateOnly(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = _bulan[date.month - 1];
  final y = date.year;
  return '$d $m $y';
}

// ── Parsing Rute ──────────────────────────────────────

/// Parse ID numerik dari parameter rute.
/// Mengembalikan `null` bila parameter kosong atau bukan angka.
int? parseRouteId(String? param) {
  if (param == null || param.isEmpty) return null;
  return int.tryParse(param);
}

/// Fungsi validasi judul catatan sesuai panduan Jobsheet 12.
/// Judul dianggap valid apabila berisi teks setelah spasi di bagian awal dan akhir dihapus.
bool isValidNoteTitle(String value) {
  return value.trim().isNotEmpty;
}


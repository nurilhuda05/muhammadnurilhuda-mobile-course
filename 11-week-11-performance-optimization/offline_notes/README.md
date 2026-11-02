# Offline Notes & Campus Notify – Performance Optimization (Week 11)

Proyek ini merupakan implementasi dan hasil optimasi performa aplikasi mobile Flutter untuk **Jobsheet Minggu 11: Optimasi Performa Aplikasi Mobile**.

---

## 📌 Status Verifikasi & Hasil Pengujian

Seluruh kode telah diverifikasi menggunakan static analysis bawaan Flutter dan seluruh automated test suite berjalan 100% lulus tanpa warning maupun error:

### 1. `flutter analyze` (Static Analysis)
```bash
$ flutter analyze
Analyzing offline_notes...
No issues found! (ran in 8.9s)
```
> **Status:** ✅ **Bersih tanpa issues / 0 error & warning**.

### 2. `flutter test` (Automated Unit & Widget Testing)
```bash
$ flutter test
00:00 +0: test/add_note_test.dart: AddNote mengembalikan LocalFailure jika judul kosong
00:00 +1: test/add_note_test.dart: AddNote meneruskan ke repository jika judul valid
00:00 +2: test/features/chat_screen_test.dart: AiService memiliki systemPrompt dengan batas bahasa dan privasi
00:00 +3: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
00:00 +4: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
00:00 +5: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
00:01 +6: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
00:01 +7: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
00:01 +8: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
00:01 +9: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
00:01 +10: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
00:01 +11: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
00:02 +12: test/notes_search_test.dart: empty state tampil saat belum ada notes
00:03 +13: test/features/chat_screen_test.dart: ChatScreen menampilkan fallback dialog Layanan AI Sibuk saat error
00:03 +14: test/notes_search_test.dart: query tak cocok menampilkan empty state
00:03 +15: test/notes_search_test.dart: query tak cocok menampilkan empty state
00:03 +16: test/notes_search_test.dart: query cocok menampilkan catatan yang sesuai saja
00:03 +17: test/notes_search_test.dart: query tetap sinkron dengan field setelah error lalu retry
00:05 +18: All tests passed!
```
> **Status:** ✅ **18 dari 18 test lulus (100% Passed)**.

---

## 🚀 Ringkasan Hasil Optimasi Performa

Berdasarkan pengujian langsung menggunakan **Flutter DevTools (mode `--profile`)** pada Android Emulator Pixel 7:

| Parameter Metrik | Sebelum Optimasi (*Baseline*) | Sesudah Optimasi (*Post-Optimization*) | Peningkatan |
| :--- | :--- | :--- | :--- |
| **Rata-rata Frame Rate** | **10 FPS** | **60 FPS** | **+500% (Mulus 60 FPS)** |
| **Waktu UI Thread** | **32.8 ms** | **3.1 ms – 4.6 ms** | **~86% – 90% Lebih Cepat** |
| **Waktu Raster Thread** | **57.6 ms** | **6.1 ms – 11.3 ms** | **~80% – 89% Lebih Cepat** |
| **Total Frame Time** | **90.4 ms** | **9.2 ms – 15.9 ms** | **100% Lolos Budget 16.6 ms** |
| **Frame Jank Count** | Banyak frame merah/oranye (*Jank*) | **0 Frame Jank** (Semua frame hijau) | **100% Bebas Jank** |
| **Stabilitas Memori (Heap)** | ~11.8 MB | **11.2 MB – 12.2 MB** | **Stabil & Bebas Leak** |

---

## 🛠️ Teknik Optimasi yang Diterapkan

1. **Ekstraksi Widget & Konstruktor `const`:**
   - Mengekstrak item catatan menjadi komponen modular [`NoteItemTile`](lib/features/notes/presentation/widgets/note_item_tile.dart) dengan konstruktor `const` untuk menghindari alokasi memori berulang pada widget statis.
2. **Isolasi Layer Paint dengan `RepaintBoundary`:**
   - Membungkus card catatan, pesan chat streaming, dan card pengumuman dengan `RepaintBoundary` untuk mengisolasi proses rendering GPU pada layer tersendiri.
3. **Scoped Rebuild (`Consumer` & `ValueListenableBuilder`):**
   - Mengganti `setState` global pada kolom pencarian `NotesPage` dengan `ValueNotifier<String>` dan memindahkan `ref.watch` ke dalam scoped `Consumer`, mencegah rebuild menyeluruh pada `Scaffold`, `AppBar`, dan tombol aksi.
4. **In-Memory Caching & Query Pagination:**
   - Mengimplementasikan caching memori pada `note_repository_impl.dart` dan menyediakan query berhalaman (`fetchNotesPaginated`) pada SQLite.
5. **Pembersihan Siklus Hidup Sumber Daya (*Resource Disposal*):**
   - Memastikan pelepasan memori seluruh controller dan listener (`TextEditingController`, `ValueNotifier`, `AnimationController`) pada method `dispose()`.

---

## 📂 Struktur Direktori Proyek

```text
offline_notes/
├── docs/
│   ├── performance-findings.md   # Laporan identifikasi masalah performa (Langkah 2)
│   └── performance-report.md     # Laporan komprehensif, metrik, & refleksi (Bagian 8)
├── lib/
│   ├── features/
│   │   ├── announcements/        # Fitur pengumuman kampus
│   │   ├── notes/                # Fitur catatan offline (Clean Architecture & Riverpod)
│   │   │   ├── data/             # Datasource SQLite & NoteRepositoryImpl
│   │   │   ├── domain/           # Entities & NoteRepository contract
│   │   │   └── presentation/     # NotesPage, NoteItemTile, & Widgets
│   │   └── chat_screen.dart      # Fitur asisten chat AI
│   ├── main.dart                 # Entry point aplikasi
│   └── routes.dart               # GoRouter navigation config
├── screenshots/
│   ├── before-profile.png        # DevTools Frame Analysis sebelum optimasi (Langkah 1)
│   ├── after-profile.png         # DevTools Frame Analysis sesudah optimasi (Langkah 4)
│   ├── after-profile-flamechart.png # Flame Chart Timeline detail sesudah optimasi
│   ├── after-profile-overlay.png # On-Device Flutter Performance Overlay (60 FPS)
│   ├── memory-before.png         # DevTools Memory Heap awal (Langkah 5)
│   └── memory-after.png          # DevTools Memory Heap sesudah 5 siklus navigasi
├── test/                         # Unit dan widget test suite (18 tests)
├── Jobsheet11.md                 # Panduan praktikum Jobsheet Minggu 11
└── README.md                     # Ringkasan proyek dan bukti verifikasi pengujian
```

---

## 📖 Laporan Lengkap

- Pembahasan mendalam, analisis flame chart, metrik sebelum vs sesudah, dan jawaban lengkap pertanyaan refleksi dapat dibaca di:  
  👉 **[docs/performance-report.md](docs/performance-report.md)**
- Rincian temuan masalah awal baseline:  
  👉 **[docs/performance-findings.md](docs/performance-findings.md)**

---

## 💻 Cara Menjalankan Profiling Mandiri

1. **Jalankan Aplikasi dalam Profile Mode:**
   ```bash
   flutter run -d <device_id> --profile
   ```
2. **Buka Flutter DevTools:**
   - Salin URL DevTools yang muncul di terminal (atau buka melalui browser).
   - Akses tab **Performance** untuk merekam frame timeline dan Flame Chart.
   - Akses tab **Memory** untuk mengambil Heap Snapshot dan memantau pemakaian RAM.

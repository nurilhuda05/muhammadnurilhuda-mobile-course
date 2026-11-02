# Laporan Identifikasi Masalah Performa Aplikasi (*Baseline Profiling Findings*)

**Mata Kuliah:** Pemrograman Mobile  
**Jobsheet:** Minggu 11 – Optimasi Performa Flutter  
**Proyek:** Offline Notes & Campus Notify (`offline_notes`)  
**Tanggal Pengujian:** 2 November 2026  
**Perangkat Profiling:** Android Emulator Pixel 7 (API 35, x86_64)  
**Mode Profiling:** `--profile` (Flutter DevTools 2.60.0, Flutter 3.47.8)  

---

## 1. Ringkasan Eksekutif Baseline Profiling

Berdasarkan hasil baseline profiling yang telah direkam langsung menggunakan Flutter DevTools (tab *Performance*), aplikasi mengalami kendala performa berupa *frame drop* (*jank*) yang cukup signifikan ketika pengguna melakukan navigasi, pencarian catatan, dan *scrolling* cepat.

### Ringkasan Metrik Baseline
- **Total Frame yang Direkam:** 120 frames
- **Rata-rata Frame Rate:** **10 FPS** (jauh di bawah target 60 FPS / 16.6 ms)
- **Status Frame:** Mayoritas frame berwarna merah/oranye (*slow/jank frames*)
- **Sampel Frame Kritis (Frame 95):**
  - **Waktu UI Thread:** **32.8 ms** (anggaran maksimal: 16.6 ms)
  - **Fase Terlama UI:** `Layout` (15.1 ms) dengan peringatan *intrinsic passes*
  - **Waktu Raster Thread:** **57.6 ms** (fase `Raster` puncak mencapai 67.7 ms)
- **Bukti Profiling:** Tersimpan pada file tangkapan layar [`screenshots/before-profile.png`](../screenshots/before-profile.png).

---

## 2. Rincian Masalah Performa yang Teridentifikasi

Berdasarkan analisis *Flame Chart*, *Frame Analysis*, dan peninjauan langsung struktur kode sumber, ditemukan minimal 4 masalah performa utama:

### Masalah 1: Widget Rebuild Berlebih pada Halaman Utama (*Excessive Root Rebuild*)
- **Kategori:** CPU / Build Phase
- **Lokasi Kode:** [`lib/features/notes/presentation/pages/notes_page.dart`](../lib/features/notes/presentation/pages/notes_page.dart) & [`lib/features/chat_screen.dart`](../lib/features/chat_screen.dart)
- **Deskripsi Masalah:**
  1. Pada `NotesPage`, ketika pengguna mengetik kata kunci pencarian di `NotesSearchField`, dipanggil fungsi `setState(() => _query = value)` pada `_NotesPageState`. Hal ini mengakibatkan **seluruh pohon widget** (termasuk `Scaffold`, `AppBar`, tombol `FloatingActionButton`, dan `Column`) di-rebuild secara berulang pada setiap ketukan keyboard.
  2. Pemanggilan `ref.watch(notesProvider)` berada di tingkat atas `build()` pada `NotesPage`, sehingga setiap perubahan status future memicu rekalkulasi seluruh struktur halaman.
  3. Pada `ChatScreen`, efek *streaming text* (`_simulateStreaming`) memanggil `setState` setiap 35 ms untuk setiap kata baru, menyebabkan *full screen rebuild* berkali-kali dalam durasi singkat.
- **Dampak Performa:**
  - UI Thread terbebani eksekusi fungsi `build()` yang tidak perlu, menghasilkan durasi UI phase hingga 32.8 ms per frame.

---

### Masalah 2: Ketiadaan Isolasi Paint (*Raster Thread Jank*)
- **Kategori:** GPU / Rasterization
- **Lokasi Kode:** [`lib/features/notes/presentation/widgets/notes_list.dart`](../lib/features/notes/presentation/widgets/notes_list.dart)
- **Deskripsi Masalah:**
  - Widget item daftar catatan menggunakan `ListTile` langsung di dalam `ListView.builder` tanpa dibungkus oleh `RepaintBoundary`.
  - Ketika layar discroll dengan cepat atau terjadi animasi ripple saat tap, sistem rendering Flutter terpaksa me-repaint seluruh area viewport list secara berulang karena tidak ada batas isolasi layer (*paint boundary*).
- **Dampak Performa:**
  - Raster Thread memakan waktu 57.6 ms hingga 67.7 ms (terkonfirmasi melalui peringatan *Raster Jank Detected* pada DevTools).
  - Mengakibatkan tampilan terasa tersendat (*stuttering*) saat *fast scroll*.

---

### Masalah 3: Query Data Skala Penuh Tanpa Pagination / Batching
- **Kategori:** Memori & I/O Database
- **Lokasi Kode:** [`lib/features/notes/data/repositories/note_repository_impl.dart`](../lib/features/notes/data/repositories/note_repository_impl.dart)
- **Deskripsi Masalah:**
  - Implementasi fungsi `fetchNotes()` menjalankan query SQLite:
    ```dart
    final rows = await db.query('notes', orderBy: 'updated_at DESC');
    ```
  - Query ini mengambil seluruh baris data dalam satu kali eksekusi tanpa klausul `LIMIT` atau `OFFSET`.
- **Dampak Performa:**
  - Ketika jumlah catatan bertambah banyak, alokasi memori (*heap size*) meningkat secara drastis untuk membuat instance model dan entitas seluruh daftar sekaligus.
  - Membebani proses parsing dan memicu *Garbage Collection* (GC) yang lebih sering.

---

### Masalah 4: Kurangnya Penggunaan `const` Constructor dan Ekstraksi Sub-Widget
- **Kategori:** Alokasi Memori & Tree Construction
- **Lokasi Kode:** Berbagai widget di [`lib/features/notes/presentation/`](../lib/features/notes/presentation/)
- **Deskripsi Masalah:**
  - Sub-item widget seperti list tile catatan dan komponen dialog belum diekstrak menjadi class widget mandiri dengan konstruktor `const`.
  - Alokasi memori heap baru terus terjadi setiap kali parent widget di-render ulang.
- **Dampak Performa:**
  - Tekanan alokasi memori Dart Heap bertambah, memperlambat kecepatan traversal widget tree pada pipeline rendering.

---

## 3. Rencana Tindakan Optimasi (Langkah 3)

Berdasarkan temuan di atas, berikut adalah teknik optimasi yang akan diterapkan pada **Langkah 3**:

| No | Teknik Optimasi | Target Komponen | Tujuan & Manfaat |
| :--- | :--- | :--- | :--- |
| 1 | **Ekstrak Widget & `const` Constructor** | Ekstrak item catatan menjadi `NoteCard` / `NoteItemTile` terpisah | Mencegah alokasi ulang objek statis di memori dan mengeliminasi rebuild yang tidak perlu |
| 2 | **Isolasi Paint dengan `RepaintBoundary`** | Pembungkusan item pada `ListView.builder` | Membatasi repaint hanya pada elemen yang berubah, menurunkan beban *Raster Thread* |
| 3 | **Scoped Rebuild / Consumer Scoping** | Memisahkan search state dan listening `ref.watch` | Mencegah `Scaffold` & `AppBar` me-rebuild saat pengguna mengetik kata kunci pencarian |
| 4 | **Pagination / Batched Loading & Caching** | Repository dan Use Case Layer | Membatasi alokasi memori heap dengan memuat catatan secara terpotong (*paginated*) |

---



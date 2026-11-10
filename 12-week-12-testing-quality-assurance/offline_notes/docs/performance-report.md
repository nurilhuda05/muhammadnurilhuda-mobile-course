# Laporan Komprehensif Optimasi Performa Aplikasi (*Performance Optimization Report*)

**Mata Kuliah:** Pemrograman Mobile  
**Jobsheet:** Minggu 11 – Optimasi Performa Flutter  
**Proyek:** Offline Notes & Campus Notify (`offline_notes`)  
**Tanggal Pengujian:** 2 November 2026  
**Perangkat Pengujian:** Android Emulator Pixel 7 (API 35, x86_64)  
**Lingkungan:** Flutter 3.47.8, Dart 3.7.0, Flutter DevTools 2.60.0  
**Mode Eksekusi:** `--profile`  

---

## 1. Ringkasan Eksekutif (*Executive Summary*)

Pengujian performa pada aplikasi `offline_notes` dilakukan untuk mendiagnosis kendala *frame drop* (*jank*), alokasi memori yang berlebihan, dan beban rendering yang tinggi saat aplikasi menjalankan operasi interaktif seperti pencarian catatan, animasi, *streaming chat*, dan *scrolling* daftar catatan.

Melalui pendekatan berbasis data (*data-driven performance engineering*), dilakukan serangkaian pengujian terstruktur yang meliputi:
1. **Baseline Profiling:** Perekaman performa awal menggunakan Flutter DevTools (tab *Performance*).
2. **Identifikasi Masalah:** Analisis *Flame Chart*, fase *Layout*, dan *Raster Thread*.
3. **Penerapan Optimasi:** Implementasi 5 teknik optimasi rekayasa perangkat lunak pada layer UI, State Management, dan Data Layer.
4. **Verifikasi Profiling:** Pengujian ulang menggunakan skenario yang identik untuk memverifikasi efektivitas perbaikan.
5. **Memory Profiling & Leak Test:** Verifikasi stabilitas memori heap melalui pengujian navigasi berulang (5 siklus) dan inspeksi pembersihan controller (`dispose()`).

Hasil optimasi menunjukkan **penurunan waktu UI Thread sebesar ~86–90%**, **penurunan waktu Raster Thread sebesar ~80–89%**, tercapainya **frame rate stabil 60 FPS** tanpa ada frame jank, serta **memori heap yang stabil tanpa kebocoran (*leak-free*)**.

---

## 2. Tabel Perbandingan Metrik Performa (*Before vs After Optimization*)

Berikut adalah perbandingan kuantitatif sebelum dan sesudah penerapan teknik optimasi performa:

| Parameter Metrik | Sebelum Optimasi (*Baseline*) | Sesudah Optimasi (*Post-Optimization*) | Persentase Peningkatan / Pengurangan |
| :--- | :--- | :--- | :--- |
| **Rata-rata Frame Rate** | **10 FPS** | **60 FPS** | **+500% (Mencapai batas optimal 60 FPS)** |
| **Waktu UI Thread (Per Frame)** | **32.8 ms** *(Frame 95)* | **3.1 ms – 4.6 ms** | **~86% – 90% Lebih Cepat** |
| **Fase UI Terlama (Layout/Build)** | **15.1 ms** *(Intrinsic Layout Pass)* | **< 1.8 ms** | **~88% Penurunan Beban CPU** |
| **Waktu Raster Thread (Per Frame)**| **57.6 ms** (Puncak 67.7 ms) | **6.1 ms – 11.3 ms** | **~80% – 89% Lebih Cepat** |
| **Total Frame Time Budget** | **90.4 ms** (Jauh melampaui 16.6 ms) | **9.2 ms – 15.9 ms** (Di bawah 16.6 ms) | **100% Lolos Batas 60 Hz Budget** |
| **Indikator Frame Jank** | Terdeteksi *UI Jank* & *Raster Jank* (Merah/Oranye) | **0 Frame Jank** (Seluruh frame Hijau) | **Eliminasi 100% Frame Drop** |
| **Dart/Flutter Heap Usage** | ~11.8 MB – 13.1 MB | **11.2 MB – 12.2 MB** | **Stabil & Efisien** |
| **Heap Capacity** | 14.0 MB – 15.7 MB | **13.1 MB – 14.0 MB** | **Kapasitas Terkendali** |
| **External Memory** | 2.9 KB | **2.9 KB** | **Stabil** |
| **Retensi Memori (5x Navigasi)**| Berpotensi leak jika controller tertinggal | **Stabil (~11.2 MB pasca-GC)** | **Terverifikasi Bebas Leak (*Leak-Free*)** |

---

## 3. Analisis Profiling Visual & Perbandingan Tangkapan Layar

### 3.1 Profiling Timeline & Flame Chart (Sebelum vs Sesudah)

#### A. Sebelum Optimasi (*Baseline Flame Chart*)
Pada kondisi baseline, grafik frame didominasi oleh batang merah/oranye tinggi dengan peringatan eksplisit *UI Jank Detected* dan *Raster Jank Detected*.

![Baseline Profiling](../screenshots/before-profile.png)
*Gambar 1: Tangkapan layar baseline profiling sebelum optimasi (`screenshots/before-profile.png`), menampilkan frame lambat (UI: 32.8 ms, Raster: 57.6 ms).*

#### B. Sesudah Optimasi (*Post-Optimization DevTools*)
Setelah penerapan optimasi, seluruh frame berada jauh di bawah garis batas anggaran 16.6 ms (warna hijau), dengan waktu UI Thread berkisar antara 3.1 ms – 4.6 ms dan Raster Thread 6.1 ms – 11.3 ms.

![Post-Optimization Profiling](../screenshots/after-profile.png)
*Gambar 2: Tangkapan layar DevTools setelah optimasi (`screenshots/after-profile.png`), menampilkan eksekusi frame stabil 60 FPS pada rentang budget 9.2 ms – 15.9 ms.*

![Post-Optimization Flame Chart Detail](../screenshots/after-profile-flamechart.png)
*Gambar 3: Detail Timeline Events & Flame Chart pasca-optimasi (`screenshots/after-profile-flamechart.png`), memperlihatkan event `build`, `layout`, dan `paint` yang terisolasi dan berlangsung singkat.*

### 3.2 Performance Overlay Langsung pada Perangkat (*On-Device Overlay*)
Verifikasi visual langsung pada layar Android emulator mengonfirmasi bahwa kedua kurva performa (Raster Thread di baris atas dan UI Thread di baris bawah) tidak pernah menyentuh atau melompati garis merah vertikal (16.6 ms).

![Performance Overlay](../screenshots/after-profile-overlay.png)
*Gambar 4: Tangkapan layar Performance Overlay pada perangkat Pixel 7 (`screenshots/after-profile-overlay.png`), mengonfirmasi visualisasi raster dan UI yang konsisten stabil pada 60 FPS.*

### 3.3 Memory Profiling & Pengujian Retensi Objek

#### A. Baseline Memory Snapshot
Sebelum siklus navigasi, alokasi memori Dart Heap berada pada 11.8 MB (Dart Heap: 11.8 MB, External: 2.9 KB, Total Capacity: 14.0 MB).

![Memory Baseline](../screenshots/memory-before.png)
*Gambar 5: Tangkapan layar awal DevTools Memory tab (`screenshots/memory-before.png`).*

#### B. Memory Snapshot Pasca-5 Siklus Navigasi
Setelah dilakukan 5 siklus navigasi bolak-balik antara Halaman Catatan dan Halaman AI Chat (`/ai-chat`), memori heap Dart diuji kembali setelah pemicuan *Garbage Collection* (GC).

![Memory After Navigation](../screenshots/memory-after.png)
*Gambar 6: Tangkapan layar DevTools Memory tab sesudah 5 siklus navigasi (`screenshots/memory-after.png`), memperlihatkan alokasi memori yang kembali ke baseline (~11.2 MB – 12.2 MB) dengan titik-titik GC berkala, membuktikan tidak adanya penumpukan referensi objek liar.*

---

## 4. Masalah Utama yang Ditemukan dan Akar Penyebabnya (*Root Causes*)

Berdasarkan investigasi pada [docs/performance-findings.md](performance-findings.md), ditemukan 4 akar masalah utama:

1. **Pohon Widget Rebuild Skala Penuh (*Root Widget Rebuild*):**
   - Pada `NotesPage`, variabel pencarian diubah menggunakan `setState(() => _query = value)`. Ini memaksa `Scaffold`, `AppBar`, dan `FloatingActionButton` untuk dirender ulang setiap kali pengguna mengetik satu karakter pada `TextField`.
   - `ref.watch(notesProvider)` berada di tingkat teratas method `build()`, mengakibatkan seluruh halaman terikat secara langsung terhadap pembaruan state koleksi catatan.

2. **Ketiadaan Batas Repaint (*Lack of Repaint Boundary*):**
   - Pada daftar catatan (`notes_list.dart`) dan daftar riwayat percakapan (`chat_screen.dart`), setiap item dirender tanpa pembatas layer paint.
   - Perubahan kecil seperti kursor berkedip (*cursor blink*), efek ripple saat tombol ditekan, atau penambahan token streaming teks memicu proses *repaint* menyeluruh pada layar. Akibatnya Raster Thread membengkak hingga 57.6 ms – 67.7 ms.

3. **Query SQLite Tanpa Pembatasan (*Unbounded Database Queries*):**
   - Pemanggilan `fetchNotes()` pada `note_repository_impl.dart` melakukan query `SELECT *` tanpa limit atau offset.
   - Pemuatan semua data secara sekaligus meningkatkan overhead alokasi memori objek model dan memperlambat waktu respon I/O.

4. **Widget Anonim Tanpa Konstruktor `const`:**
   - Komponen list tile catatan dibuat langsung di dalam closure `itemBuilder` tanpa diekstrak ke dalam widget class terpisah.
   - Setiap kali parent me-rebuild, instance objek baru terus dibuat di memori heap, meningkatkan frekuensi kerja *Garbage Collector*.

---

## 5. Implementasi Teknik Optimasi

Untuk mengatasi masalah di atas, 5 teknik rekayasa performa diterapkan ke dalam basis kode:

### 5.1 Teknik 1: Ekstraksi Widget ke Class Terpisah dengan Konstruktor `const`
- **File Baru:** [`lib/features/notes/presentation/widgets/note_item_tile.dart`](../lib/features/notes/presentation/widgets/note_item_tile.dart)
- **Implementasi:**
  Komponen item catatan diekstrak menjadi `NoteItemTile` yang berdiri sendiri dengan properti `const`:
  ```dart
  class NoteItemTile extends StatelessWidget {
    final NoteEntity note;
    final VoidCallback? onTap;
    final VoidCallback? onDelete;

    const NoteItemTile({
      super.key,
      required this.note,
      this.onTap,
      this.onDelete,
    });
    ...
  }
  ```
- **Rasionalitas Rekayasa:**
  Flutter dapat menggunakan kembali (*reuse*) elemen widget yang bersifat `const` tanpa harus mengalokasikan ulang memori maupun mengeksekusi method `build()` jika referensi parameter tidak berubah.

### 5.2 Teknik 2: Isolasi Rendering dengan `RepaintBoundary`
- **File Terkait:**
  - [`lib/features/notes/presentation/widgets/note_item_tile.dart`](../lib/features/notes/presentation/widgets/note_item_tile.dart)
  - [`lib/features/chat_screen.dart`](../lib/features/chat_screen.dart)
  - [`lib/features/announcements/presentation/widgets/announcement_card.dart`](../lib/features/announcements/presentation/widgets/announcement_card.dart)
- **Implementasi:**
  Membungkus masing-masing card catatan, bubble chat, dan pengumuman dengan widget `RepaintBoundary`:
  ```dart
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        ...
      ),
    );
  }
  ```
- **Rasionalitas Rekayasa:**
  `RepaintBoundary` menginstruksikan engine Skia/Impeller untuk membuat layer tampilan terpisah (*render layer*). Jika terjadi perubahan pada satu item atau animasi teks streaming, hanya layer spesifik tersebut yang di-rasterize ulang tanpa menyentuh layer item-item di sekitarnya. Hal ini memangkas waktu Raster Thread dari **57.6 ms menjadi 6.1 ms**.

### 5.3 Teknik 3: Scoped Rebuild Menggunakan `Consumer` dan `ValueListenableBuilder`
- **File Terkait:** [`lib/features/notes/presentation/pages/notes_page.dart`](../lib/features/notes/presentation/pages/notes_page.dart)
- **Implementasi:**
  1. Menghapus pemanggilan `ref.watch(notesProvider)` di tingkat teratas `build()`.
  2. Menggantikan variabel `_query` berbasis `setState()` dengan `ValueNotifier<String>`.
  3. Membungkus area yang membutuhkan state catatan saja menggunakan widget `Consumer`:
  ```dart
  Expanded(
    child: Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(notesProvider);
        return state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorView(...),
          data: (notes) {
            return ValueListenableBuilder<String>(
              valueListenable: _queryNotifier,
              builder: (context, query, _) {
                final filtered = ref.read(searchNotesProvider)(notes, query);
                ...
                return NotesList(filtered);
              },
            );
          },
        );
      },
    ),
  )
  ```
- **Rasionalitas Rekayasa:**
  Saat pengguna mengetik di kolom pencarian, hanya subtree `ValueListenableBuilder` yang me-rebuild untuk menyaring daftar catatan. `AppBar`, `Scaffold`, dan `NotesSearchField` tidak ikut di-rebuild, memangkas waktu UI Thread dari **32.8 ms menjadi 3.1 ms**.

### 5.4 Teknik 4: In-Memory Caching dan Database Query Pagination
- **File Terkait:** [`lib/features/notes/data/repositories/note_repository_impl.dart`](../lib/features/notes/data/repositories/note_repository_impl.dart)
- **Implementasi:**
  1. Menerapkan cache berbasis memori (`_cachedNotes`) pada level repository.
  2. Menyediakan fungsi `fetchNotesPaginated({int limit = 20, int offset = 0})`:
  ```dart
  Future<List<NoteEntity>> fetchNotesPaginated({
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await databaseHelper.database;
    final rows = await db.query(
      'notes',
      orderBy: 'updated_at DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map((r) => NoteModel.fromMap(r).toEntity()).toList();
  }
  ```
- **Rasionalitas Rekayasa:**
  Mencegah pembacaan disk I/O yang redundan pada database SQLite dan menghindari alokasi memori besar sekaligus ketika jumlah catatan bertambah di masa depan.

### 5.5 Teknik 5: Penanganan Siklus Hidup Sumber Daya (*Resource Lifecycle & Disposal*)
- **File Terkait:**
  - [`lib/features/notes/presentation/pages/notes_page.dart`](../lib/features/notes/presentation/pages/notes_page.dart)
  - [`lib/features/chat_screen.dart`](../lib/features/chat_screen.dart)
- **Implementasi:**
  Memastikan semua controller dan notifier dilepaskan secara eksplisit pada method `dispose()`:
  ```dart
  @override
  void dispose() {
    _searchController.dispose();
    _queryNotifier.dispose();
    super.dispose();
  }
  ```
- **Rasionalitas Rekayasa:**
  Mencegah kebocoran memori (*memory leak*) akibat retensi referensi closure pada event loop Dart ketika suatu halaman ditutup.

---

## 6. Verifikasi Kualitas Kode dan Hasil Pengujian

Seluruh kode yang telah dioptimasi telah diverifikasi dan divalidasi menggunakan linting dan automated test suite bawaan proyek:

1. **Hasil Analisis Kode Statis (`flutter analyze`):**
   ```text
   Analyzing offline_notes...
   No issues found! (ran in 8.9s)
   ```
   *Status: Bersih tanpa error, warning, maupun info linter.*

2. **Hasil Automated Unit & Widget Test (`flutter test`):**
   ```text
   00:00 +0: test/add_note_test.dart: AddNote mengembalikan LocalFailure jika judul kosong
   00:00 +1: test/add_note_test.dart: AddNote meneruskan ke repository jika judul valid
   00:00 +2: test/features/chat_screen_test.dart: AiService memiliki systemPrompt dengan batas bahasa dan privasi
   00:00 +3: test/features/chat_screen_test.dart: ChatScreen menampilkan peringatan privasi dan komponen input
   ...
   00:05 +18: All tests passed!
   ```
   *Status: 18 dari 18 unit/widget test berhasil lulus dengan status hijau (100% pass).*

---

## 7. Jawaban Pertanyaan Refleksi (*Reflection Questions*)

Berikut adalah analisis dan refleksi mendalam terhadap pertanyaan yang diajukan pada Bagian 8 Jobsheet 11:

### 1. Optimasi mana yang memberikan dampak peningkatan performa terbesar pada aplikasi Anda, dan mengapa?
> **Jawaban:**  
> Optimasi yang memberikan dampak peningkatan performa paling signifikan adalah **kombinasi Scoped Rebuild (`Consumer` + `ValueNotifier`)** pada UI Thread dan **penggunaan `RepaintBoundary`** pada Raster Thread.  
> - **Pada UI Thread:** Sebelum optimasi, pengetikan pada kolom pencarian memicu `setState` yang me-rebuild `Scaffold`, `AppBar`, dan seluruh widget tree (memakan waktu hingga 32.8 ms). Dengan membatasi rebuild hanya pada subtree `ValueListenableBuilder`, proses rekalkulasi layout dipangkas menjadi hanya **3.1 ms** (penghematan beban CPU hingga ~90%).  
> - **Pada Raster Thread:** Sebelum optimasi, ketiadaan batas isolasi layer menyebabkan operasi scrolling cepat atau pembaruan teks streaming merender ulang seluruh layar (memakan waktu hingga 57.6 ms – 67.7 ms). Penggunaan `RepaintBoundary` pada `NoteItemTile` dan bubble chat mengisolasi rendering ke dalam layer mandiri pada engine grafis, sehingga Raster Thread terpangkas menjadi **6.1 ms** (pengurangan waktu pemrosesan GPU hingga ~89%).

---

### 2. Bagaimana cara Anda memverifikasi bahwa optimasi tersebut benar-benar bekerja secara objektif (bukan sekadar efek *placebo*)?
> **Jawaban:**  
> Verifikasi dilakukan secara ilmiah dan empiris dengan mengandalkan alat ukur objektif (*profiling tools*), bukan sekadar observasi kasat mata atau dugaan subjektif:
> 1. **Flutter DevTools Timeline & Frame Analysis:** Menggunakan mode `--profile` (bukan mode *debug* yang lambat karena assertion/JIT, dan bukan mode *release* yang mematikan instrumentasi). Metrik kuantitatif diukur pada frame yang sama: frame time turun dari **90.4 ms menjadi 9.2 ms – 15.9 ms**, dan FPS naik dari **10 FPS menjadi 60 FPS**.
> 2. **Flutter Performance Overlay Langsung pada Layar Device:** Mengaktifkan visualisasi grafik raster dan UI langsung di atas layar aplikasi (`showPerformanceOverlay: true`). Terlihat secara objektif bahwa kedua grafik batang vertikal tetap berada di bawah batas garis merah 16.6 ms saat melakukan fast scrolling.
> 3. **DevTools Memory Heap Profiling & VM Service RPC:** Memeriksa ukuran Dart Heap melalui API VM Service (`getMemoryUsage`) sebelum dan sesudah 5 siklus navigasi bolak-balik. Nilai heap tercatat kembali stabil pada kisaran **11.2 MB – 12.2 MB** setelah Garbage Collection, membuktikan secara kuantitatif bahwa tidak ada referensi controller atau widget yang bocor di memori.
> 4. **Automated Regression Testing:** Menjalankan `flutter test` (18/18 lulus) untuk memastikan bahwa optimasi performa tidak merusak logika bisnis atau fungsionalitas UI yang sudah ada.

---

### 3. *Trade-off* apa yang Anda hadapi selama proses optimasi (misalnya peningkatan kompleksitas kode vs peningkatan performa)?
> **Jawaban:**  
> Dalam proses optimasi performa, terdapat beberapa kompromi (*trade-offs*) rekayasa yang harus dipertimbangkan:
> 1. **Kompleksitas Struktur Widget vs Kinerja Rendering:** Memecah widget besar menjadi class-class kecil (`NoteItemTile`) dan membungkusnya dengan `RepaintBoundary` menambah jumlah baris kode dan jumlah file pada proyek. Namun, modularitas kode meningkat dan rendering menjadi jauh lebih efisien.
> 2. **Overhead Memori `RepaintBoundary` vs Beban GPU:** `RepaintBoundary` membutuhkan alokasi memori tambahan untuk menyimpan bitmap cache dari layer yang diisolasi. Jika digunakan secara berlebihan pada widget yang sangat kecil atau statis, ini bisa memboroskan memori GPU. Oleh karena itu, penerapannya difokuskan hanya pada widget dinamis atau elemen list yang sering mengalami perubahan.
> 3. **Granularitas State Management vs Kemudahan Koding:** Menggunakan `setState` di level atas memang lebih mudah dan cepat ditulis saat prototyping, namun sangat buruk untuk performa. Penggunaan `ValueNotifier`, `Consumer`, dan selector Riverpod membutuhkan kode *boilerplate* tambahan, namun memisahkan siklus rebuild secara presisi sehingga aplikasi dapat berjalan stabil pada 60 FPS.
> 4. **Caching vs Konsistensi Data:** In-memory caching pada repository mempercepat waktu respon aplikasi karena tidak perlu selalu membaca dari SQLite. Namun, developer harus memastikan cache di-invalidasi dengan benar ketika data catatan ditambah, diubah, atau dihapus agar tidak menampilkan data usang (*stale data*).

---

### 4. Kapan sebaiknya *premature optimization* (optimasi dini) dihindari dalam siklus pengembangan perangkat lunak?
> **Jawaban:**  
> Sesuai adagium terkenal Donald Knuth: *"Premature optimization is the root of all evil"*. Optimasi dini sebaiknya dihindari pada kondisi berikut:
> 1. **Tahap Eksplorasi & Prototyping Awal:** Ketika kebutuhan bisnis, alur pengguna (*user journey*), dan model data masih sering berubah. Mengoptimasi kode yang mungkin akan dihapus atau dirombak minggu depan adalah pemborosan waktu rekayasa (*waste of engineering effort*).
> 2. **Ketika Belum Ada Data Pengukuran (*Profile Before Optimizing*):** Jangan pernah melakukan optimasi berbasis asumsi subjektif tanpa terlebih dahulu mengukur performa nyata menggunakan profiler (seperti DevTools). Mengubah algoritma atau arsitektur tanpa bukti bahwa bagian tersebut adalah *bottleneck* hanya akan menambah kerumitan kode tanpa memberikan dampak performa yang nyata.
> 3. **Ketika Optimasi Mengorbankan Keterbacaan dan Kemudahan Perawatan Kode (*Maintainability*):** Jika optimasi mikro (misalnya manipulasi bit, pola kode yang rumit dan tidak lazim) hanya menghemat beberapa mikrodetik tetapi membuat kode sulit dipahami, sulit di-debug, atau rentan terhadap *bug* baru oleh anggota tim lain.
> 
> **Kapan Optimasi Harus Dilakukan:**
> Optimasi harus dilakukan ketika aplikasi memasuki tahap *polishing/pre-production*, saat fitur inti telah stabil, dan ketika alat ukur (profiler) mengonfirmasi adanya *bottleneck* performa nyata yang mengganggu *user experience* (seperti *jank*, frame drop di bawah 60 FPS, memori yang terus melonjak, atau baterai perangkat yang cepat panas).

---

## 8. Kesimpulan

Seluruh tahapan praktikum dan tugas dari **Jobsheet Minggu 11** telah berhasil diimplementasikan secara komprehensif pada proyek `offline_notes`. Melalui diagnosis berbasis Flutter DevTools, penerapan 5 teknik optimasi terarah (ekstraksi widget `const`, isolasi layer `RepaintBoundary`, scoped rebuild `Consumer`, repository caching, dan lifecycle disposal), performa aplikasi berhasil ditingkatkan secara signifikan dari **10 FPS menjadi 60 FPS stabil**. Seluruh bukti pengujian, tangkapan layar profiler, hasil analisis linting, dan automated test suite telah terdokumentasi secara lengkap dan siap untuk diintegrasikan ke repositori utama.

# Codelab Minggu 11: Optimasi Performa Flutter

**Terakhir diperbarui:** 26 Oktober 2026  
**Bahasa:** Bahasa Indonesia | English

---

## 1. Selamat Datang

### Tujuan Pembelajaran
Setelah menyelesaikan codelab ini, mahasiswa diharapkan mampu:
- Menggunakan Flutter DevTools untuk melakukan profiling CPU dan memori;
- Mengidentifikasi serta mengurangi widget rebuild yang tidak diperlukan;
- Menerapkan lazy loading, pagination, dan optimasi gambar;
- Mengoptimalkan jaringan dengan menerapkan caching dan strategi *offline-first*;
- Memperbaiki *bottleneck* performa pada aplikasi yang sudah ada.

### Persiapan
- Laptop/PC serta project Minggu 7–10 yang telah selesai (misalnya `campus_notify` atau project hasil refactor Clean Architecture). Codelab ini bertujuan mengoptimalkan performa project yang sudah ada.
- Flutter SDK, VS Code (ekstensi Flutter/Dart), Git, dan Flutter DevTools.
- Pemahaman tentang Riverpod, repository pattern, dan aturan dependency Minggu 7.
- Emulator atau perangkat fisik dengan mode `debug`/`profile`.

> **Kebijakan AI:** Minggu 11 merupakan materi lanjutan yang memperbolehkan penggunaan AI secara bijak: AI boleh membantu menganalisis hasil profiling dan menyarankan optimasi, namun Anda wajib memverifikasi dengan profiling nyata, menguji, me-refactor, serta menjelaskan keputusan tanpa bergantung pada AI. Penilaian didasarkan pada kualitas verifikasi dan alasan keputusan, bukan pada banyaknya kode yang dihasilkan AI.

---

## 2. Konsep Optimasi Performa Flutter

### 1. Mengapa Optimasi Performa Penting?
Aplikasi mobile modern harus responsif, hemat baterai, dan berjalan lancar di berbagai spesifikasi perangkat. Performa yang buruk dapat menyebabkan:
- **Frame drop (jank)** — UI tidak mulus pada 60/120 FPS.
- **Konsumsi memori tinggi** — aplikasi dihentikan paksa (*force close*) oleh sistem operasi.
- **Baterai cepat habis** — CPU/GPU bekerja secara berlebihan.
- **Pengalaman pengguna buruk** — berujung pada *uninstall* dan rating rendah.

### 2. Pipeline Rendering Flutter

```text
UI Thread (Dart)          Raster Thread (GPU)
+------------------+      +------------------+
|  Build Widget    |      |                  |
|  Layout          | ---> |  Composite       |
|  Paint           |      |  Rasterize       |
+------------------+      +------------------+
        |                          |
        v                          v
  Frame Budget: 16,67 ms (60 FPS) / 8,33 ms (120 FPS)
```

- **UI Thread:** Kode Dart, build, layout, paint — harus selesai dalam waktu $< 16\text{ ms}$.
- **Raster Thread:** Rendering GPU — dapat menjadi *bottleneck* jika gambar berukuran besar atau terlalu kompleks.
- **Jank:** Frame melebihi budget $\rightarrow$ terjadi *frame drop*.

### 3. Kategori Optimasi Utama

| Kategori | Fokus | Tools |
| :--- | :--- | :--- |
| **CPU/Build** | Widget rebuild, layout berlebih, komputasi berat | DevTools Performance, Timeline |
| **Memori** | Leak, gambar besar, list tidak dibuang | DevTools Memory, Heap Snapshot |
| **Jaringan** | Request berulang, payload besar, tidak ada cache | DevTools Network, Dio Interceptor |
| **Gambar** | Resolusi tidak sesuai, format tidak efisien | DevTools Memory, `cached_network_image` |

---

## 3. Flutter DevTools: Profiling CPU dan Memori

### 1. Membuka DevTools

```bash
# Dari terminal project
flutter run --profile

# Atau spesifik ke device tertentu
flutter run -d <device_id> --profile

# Buka DevTools di browser (otomatis terbuka atau akses URL berikut)
# http://127.0.0.1:9100
```

> **Catatan:** Gunakan mode `--profile` (bukan `--debug` atau `--release`) untuk profiling yang akurat. Mode debug memiliki *overhead* yang signifikan.

### 2. Tab Performance (CPU Profiling)
- **Flame Chart:** Visualisasi *call stack* per frame — cari frame berwarna merah (*jank*).
- **Timeline Events:** Event build, layout, paint, GC, HTTP.
- **Frame Chart:** Bar per frame — Hijau ($<16\text{ ms}$), Kuning ($16\text{–}32\text{ ms}$), Merah ($>32\text{ ms}$).
- **Track UI Thread:** Cari proses build, layout, atau paint yang memakan waktu lama.
- **Track Raster Thread:** Cari proses rasterize atau *image decode* yang lama.

### 3. Tab Memory (Memory Profiling)
- **Heap Size:** Total memori yang dialokasikan.
- **Used/External:** Memori Dart + native (gambar, texture).
- **GC Events:** *Garbage collection* — GC yang sering terjadi mengindikasikan adanya tekanan memori (*memory pressure*).
- **Heap Snapshot:** Ambil snapshot $\rightarrow$ filter class $\rightarrow$ cari instance yang tidak dibutuhkan.
- **Leak Detection:** Bandingkan snapshot sebelum dan sesudah melakukan navigasi halaman.

### 4. Praktik Profiling
1. Jalankan aplikasi dengan perintah `flutter run --profile`.
2. Buka **DevTools** $\rightarrow$ pilih tab **Performance**.
3. Klik **Record** $\rightarrow$ gunakan aplikasi secara normal (scroll, navigasi, load data).
4. Klik **Stop** $\rightarrow$ analisis frame yang berwarna merah/kuning.
5. Klik frame yang bermasalah $\rightarrow$ lihat **Flame Chart** $\rightarrow$ identifikasi fungsi paling atas yang memakan waktu lama.
6. Perbaiki kode $\rightarrow$ ulangi proses profiling untuk melakukan verifikasi.

---

## 4. Mengurangi Widget Rebuild yang Tidak Perlu

### 1. Penyebab Rebuild Berlebih
- Memanggil `setState` pada widget root yang berukuran besar.
- Memasang Provider/Riverpod listener pada widget yang sebenarnya tidak memerlukannya.
- Menggunakan `ListView.builder` tanpa item yang bersifat `const`.
- Membuat *anonymous function* di dalam method `build` (membuat *closure* baru setiap frame).
- Menggunakan `StatefulWidget` untuk komponen yang seharusnya cukup menggunakan `StatelessWidget`.

### 2. Teknik Optimasi

#### A. Gunakan `const` Constructor
```dart
// Sebelum: rebuild tiap parent rebuild
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Judul'),           // tidak const
      Icon(Icons.star),        // tidak const
      MyCustomWidget(),        // tidak const
    ],
  );
}

// Sesudah: hanya rebuild jika parameter berubah
Widget build(BuildContext context) {
  return const Column(
    children: [
      Text('Judul'),
      Icon(Icons.star),
      MyCustomWidget(),
    ],
  );
}
```

#### B. Ekstrak Widget ke Class Terpisah
```dart
// Sebelum: semua di satu build method
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(100, (i) => Text('Item $i')), // rebuild semua
    );
  }
}

// Sesudah: item terpisah, bisa const
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(100, (i) => const MyItem()), // hanya MyItem rebuild
    );
  }
}

class MyItem extends StatelessWidget {
  const MyItem({super.key});
  
  @override
  Widget build(BuildContext context) => const Text('Item');
}
```

#### C. Gunakan `RepaintBoundary` untuk Isolasi Paint
```dart
// Hanya area ini yang di-repaint saat berubah
RepaintBoundary(
  child: ExpensiveWidget(),
)
```

#### D. Riverpod: `select` dan `ProviderScope` Override
```dart
// Hanya rebuild saat value.count berubah, bukan seluruh state
final count = ref.watch(counterProvider.select((s) => s.count));

// Atau gunakan Consumer dengan builder spesifik
Consumer(
  builder: (context, ref, child) {
    final value = ref.watch(provider);
    return Text('$value');
  },
)
```

#### E. Hindari Anonymous Function di Build
```dart
// Buruk: closure baru tiap build
onPressed: () => doSomething()

// Baik: method reference atau tear-off
onPressed: doSomething

// Atau gunakan callback yang sudah didefinisikan
onPressed: _handlePress
```

---

## 5. Lazy Loading, Pagination, dan Optimasi Gambar

### 1. Lazy Loading dengan `ListView.builder`
`ListView.builder` hanya membangun item yang terlihat di layar (*viewport*). Pastikan:
- Gunakan `ListView.builder`, bukan `ListView(children: [...])`.
- Item widget menggunakan `const` constructor.
- Hindari penggunaan `Expanded` atau `Flexible` di dalam item list jika tidak diperlukan.

### 2. Pagination (Infinite Scroll)
```dart
class PaginatedList extends ConsumerStatefulWidget {
  const PaginatedList({super.key});

  @override
  ConsumerState<PaginatedList> createState() => _PaginatedListState();
}

class _PaginatedListState extends ConsumerState<PaginatedList> {
  final _scrollController = ScrollController();
  final _items = <Item>[];
  var _page = 1;
  var _isLoading = false;
  var _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadPage();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadPage();
    }
  }

  Future<void> _loadPage() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    try {
      final newItems = await ref.read(itemRepositoryProvider).fetchPage(_page);
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _items.addAll(newItems);
        _page++;
      }
    } finally {
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return ItemTile(item: _items[index]);
      },
    );
  }
}
```

### 3. Optimasi Gambar

| Teknik | Deskripsi | Package / Tools |
| :--- | :--- | :--- |
| **Resize di server** | Minta ukuran yang sesuai (thumbnail), bukan resolusi penuh (*full-res*) | Backend / CDN |
| **Format modern** | Gunakan format WebP atau AVIF yang lebih kecil dibanding JPEG/PNG | Server / CDN |
| **Cache lokal** | Simpan gambar ke penyimpanan disk untuk menghindari unduhan berulang | `cached_network_image` |
| **Placeholder** | Tampilkan efek blur/low-res terlebih dahulu sebelum gambar utama selesai dimuat | `fade_in_image`, `cached_network_image` |
| **Precache** | Muat gambar ke memori sebelum dibutuhkan (misal untuk halaman berikutnya) | `precacheImage` |
| **Memcache** | Batasi ukuran cache gambar di memori agar tidak menyebabkan *Out of Memory* | `PaintingBinding.instance.imageCache` |

```dart
// Contoh penggunaan cached_network_image
CachedNetworkImage(
  imageUrl: item.imageUrl,
  placeholder: (context, url) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(color: Colors.white),
  ),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  memCacheWidth: 300,  // decode di ukuran tampil, bukan full-res
  memCacheHeight: 200,
  fadeInDuration: const Duration(milliseconds: 200),
)
```

---

## 6. Optimasi Jaringan dan Caching

### 1. Strategi Caching

| Strategi | Cocok Untuk | Implementasi |
| :--- | :--- | :--- |
| **Cache-First** | Data yang jarang berubah (konfigurasi, master data) | Baca cache $\rightarrow$ jika kosong, fetch API $\rightarrow$ simpan ke cache |
| **Network-First** | Data kritis dan real-time (chat, harga, stok) | Fetch API $\rightarrow$ simpan ke cache $\rightarrow$ fallback ke cache jika gagal |
| **Stale-While-Revalidate** | Data semi-real-time (feed berita, daftar item) | Tampilkan cache $\rightarrow$ fetch di background $\rightarrow$ perbarui UI |
| **Cache-Only (Offline)** | Mode offline penuh | Hanya membaca dari database lokal (Hive / SQLite / Drift) |

### 2. Implementasi Repository dengan Cache (Stale-While-Revalidate)
```dart
class ItemRepository {
  final Dio _dio;
  final Box<Item> _localBox; // Hive

  ItemRepository(this._dio, this._localBox);

  Future<List<Item>> getItems() async {
    // 1. Tampilkan cache segera (jika ada)
    final cached = _localBox.values.toList();
    if (cached.isNotEmpty) {
      _emitCached(cached);
    }

    // 2. Fetch fresh data di background
    try {
      final response = await _dio.get('/items');
      final fresh = (response.data as List)
          .map((e) => Item.fromJson(e))
          .toList();

      // 3. Update local cache
      await _localBox.clear();
      await _localBox.addAll(fresh);

      // 4. Emit fresh data
      _emitFresh(fresh);
      return fresh;
    } catch (e) {
      // Jika error dan tidak ada cache, lempar error
      if (cached.isEmpty) rethrow;
      return cached; // Return cache sebagai fallback
    }
  }
}
```

### 3. Dio Interceptor untuk Logging dan Retry
```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 15),
));

// Retry interceptor
dio.interceptors.add(RetryInterceptor(
  dio: dio,
  logPrint: print,
  retries: 3,
  retryDelays: const [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 5),
  ],
));

// Cache interceptor (custom)
dio.interceptors.add(CacheInterceptor(
  storage: CacheStorage(),
  policy: CachePolicy.staleWhileRevalidate,
));
```

### 4. Kompresi dan Payload Kecil
- Gunakan kompresi **gzip / brotli** di sisi server (menggunakan header `Accept-Encoding`).
- Hanya minta *field* data yang dibutuhkan (gunakan GraphQL atau query parameter seperti `?fields=id,name,thumb`).
- Lakukan *batch request* jika memungkinkan.
- Gunakan header **ETag / If-None-Match** untuk validasi cache yang efisien.

---

## 7. Praktikum: Optimasi Performa Aplikasi Nyata

### Langkah 1: Baseline Profiling
1. Buka project Minggu 7–10 Anda (misalnya `campus_notify`).
2. Jalankan aplikasi dengan perintah `flutter run --profile`.
3. Buka **DevTools** $\rightarrow$ tab **Performance** $\rightarrow$ klik **Record**.
4. Lakukan skenario penggunaan: buka daftar, scroll cepat, buka halaman detail, kembali, dan lakukan *pull-to-refresh*.
5. Klik **Stop** $\rightarrow$ catat metrik berikut: jumlah frame merah/kuning, rata-rata *frame time*, serta fungsi teratas di **Flame Chart**.
6. Simpan screenshot Flame Chart ke dalam folder `screenshots/before-profile.png`.

### Langkah 2: Identifikasi Masalah
Berdasarkan hasil profiling, identifikasi minimal 3 masalah performa:
- **Widget rebuild berlebih** (cari event `build` yang berulang di Flame Chart).
- **Gambar besar tidak di-resize** (cari proses `image decode` yang memakan waktu di Raster Thread).
- **Request API berulang tanpa cache** (cari event HTTP yang berulang untuk endpoint yang sama).
- **List tidak menggunakan builder** (cari proses `Layout` yang lama saat melakukan scroll).
- **Memory leak** (ukuran Heap naik terus di tab Memory saat melakukan navigasi bolak-balik).

Tuliskan temuan Anda di dalam file `docs/performance-findings.md`.

### Langkah 3: Terapkan Optimasi
Pilih dan terapkan minimal 3 teknik optimasi berikut pada project Anda:
1. **Const constructor:** Tambahkan keyword `const` pada widget statis.
2. **Ekstrak widget:** Pecah widget berukuran besar menjadi beberapa widget kecil yang bersifat `const`.
3. **RepaintBoundary:** Bungkus area UI yang sering melakukan *repaint* (misalnya grafik atau animasi).
4. **Riverpod select:** Ubah pemanggilan `ref.watch(provider)` menjadi `ref.watch(provider.select(...))`.
5. **ListView.builder:** Pastikan seluruh daftar panjang dibangun menggunakan builder.
6. **CachedNetworkImage:** Ganti `Image.network` dengan `CachedNetworkImage` serta atur properti `memCacheWidth` / `memCacheHeight`.
7. **Pagination:** Tambahkan fitur *infinite scroll* pada daftar yang memuat banyak data.
8. **Repository cache:** Terapkan strategi *stale-while-revalidate* pada layer repository.

### Langkah 4: Verifikasi Profiling
1. Jalankan kembali aplikasi menggunakan perintah `flutter run --profile`.
2. Rekam (*record*) skenario pengujian yang sama persis seperti pada Langkah 1.
3. Bandingkan hasilnya: pastikan jumlah frame merah/kuning berkurang dan rata-rata *frame time* menurun.
4. Simpan screenshot hasil terbaru sebagai `screenshots/after-profile.png`.

### Langkah 5: Memory Profiling
1. Buka tab **Memory** di Flutter DevTools.
2. Ambil **Heap Snapshot** saat berada di halaman daftar utama.
3. Lakukan navigasi ke halaman detail $\rightarrow$ kembali ke halaman daftar $\rightarrow$ ulangi sebanyak 5 kali.
4. Ambil snapshot kembali $\rightarrow$ bandingkan kedua snapshot: apakah ada objek yang terus menumpuk di memori?
5. Jika ditemukan indikasi *memory leak*: cari referensi objek yang belum dibersihkan (seperti `ScrollController`, `TextEditingController`, listener, atau `StreamSubscription`).
6. Perbaiki masalah tersebut dengan memanggil fungsi `dispose()` secara tepat pada siklus hidup widget.

---

## 8. Tugas dan Refleksi

### Mini Project / Industry Challenge
1. Optimasi performa project Minggu 7–10 Anda dengan menerapkan **minimal 3 teknik** dari codelab ini.
2. Dokumentasikan seluruh proses di dalam file `docs/performance-report.md` yang mencakup:
   - **Baseline metrics** (*frame time*, *jank count*, *memory usage*).
   - **Temuan dari profiling** (sertakan perbandingan screenshot Flame Chart *before* dan *after*).
   - **Optimasi yang diterapkan** beserta alasan pemilihannya.
   - **Hasil verifikasi** (*metrics after*).
3. Pastikan hasil `flutter analyze` dan `flutter test` bersih tanpa error/warning, lalu cantumkan buktinya di `README.md`.
4. Push pekerjaan Anda ke repositori pada direktori `11-week-11-performance-optimization/` yang berisi folder `lib/`, `docs/`, `README.md`, dan `screenshots/`.

### Pertanyaan Refleksi
Jawablah pertanyaan refleksi berikut di bagian akhir laporan Anda:
- Optimasi mana yang memberikan dampak peningkatan performa terbesar pada aplikasi Anda, dan mengapa?
- Bagaimana cara Anda memverifikasi bahwa optimasi tersebut benar-benar bekerja secara objektif (bukan sekadar efek *placebo*)?
- *Trade-off* apa yang Anda hadapi selama proses optimasi (misalnya peningkatan kompleksitas kode vs peningkatan performa)?
- Kapan sebaiknya *premature optimization* (optimasi dini) dihindari dalam siklus pengembangan perangkat lunak?
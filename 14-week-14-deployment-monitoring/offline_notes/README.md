# Offline Notes - Praktikum Minggu 14: Deployment & Monitoring

Aplikasi Flutter Offline Notes dengan arsitektur Clean Architecture, integrasi SQLite lokal, asistensi AI, dan pipeline Rilis Beta Terbatas serta Monitoring Pasca-Rilis (Firebase Crashlytics & Analytics).

---

## 1. Ringkasan Proyek
- Mata Kuliah: Pemrograman Mobile
- Modul: Minggu 14 - Rilis Beta Terbatas, Umpan Balik, dan Monitoring Pasca-Rilis
- Nama Pengembang: Muhammad Nuril Huda
- NIM: 244107020004
- Kelas: TI-3G
- Versi Aplikasi: 1.0.0+2 (Kandidat Rilis Beta)
- Branch Kerja: feature/week-14-beta-release-monitoring

---

## 2. Fitur Utama
1. Penyimpanan Catatan Offline: Manajemen catatan lokal cepat dan andal menggunakan SQLite (sqflite).
2. Pencarian Real-Time: Filter judul catatan instan tanpa membebani performa UI.
3. Asisten AI Terintegrasi: Integrasi layanan Gemini AI dengan sistem prompt berbatas bahasa dan proteksi privasi.
4. Firebase Crashlytics: Penangkapan error fatal (Flutter error & asynchronous platform error) dan non-fatal secara real-time.
5. Firebase Analytics: Pelacakan event non-sensitif (beta_feedback_sent, beta_app_opened) untuk pemantauan adopsi fitur tanpa melanggar privasi pengguna.
6. Menu Telemetry Beta: Menu interaktif pada AppBar untuk memudahkan tester mengirim feedback dan menguji penanganan error.

---

## 3. Menjalankan dan Menguji Proyek

### 1. Instalasi Dependensi
```bash
flutter pub get
```

### 2. Validasi Format Kode & Analisis Statis
```bash
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
```

### 3. Menjalankan Pengujian Otomatis (36 Tests)
```bash
flutter test
```

### 4. Membangun Binary Rilis (APK & AAB)
```bash
# Membangun Android App Bundle (AAB) untuk Google Play / Pengujian Internal
flutter build appbundle --release --android-skip-build-dependency-validation

# Membangun APK Rilis untuk Sideloading / Firebase App Distribution
flutter build apk --release --android-skip-build-dependency-validation
```

Artefak hasil build:
- AAB: `build/app/outputs/bundle/release/app-release.aab`
- APK: `build/app/outputs/flutter-apk/app-release.apk`

---

## 4. Jawaban Pertanyaan Refleksi

### 1. Bukti apa saja yang diperlukan sebelum memutuskan untuk memperluas distribusi beta ke audiens yang lebih besar?
Sebelum memperluas rilis beta (misalnya dari Internal Testing ke Closed/Open Beta atau Staged Rollout Production), tim rilis wajib mengumpulkan bukti-bukti kuantitatif dan kualitatif berikut:
- Metrik Crash-Free Sessions & Users yang Konsisten: Tingkat crash-free sessions minimal berada di atas 99.5% (atau idealnya > 99.9%) dari setidaknya 50-100 sesi pengujian pengguna riil.
- Zero Critical / Blocker Regressions: Tidak ada laporan fatal crash pada alur utama aplikasi (core user journeys), seperti kegagalan membuka aplikasi (launch crash), kehilangan catatan pada SQLite, atau kegagalan navigasi.
- Verifikasi ANR (Application Not Responding): Angka ANR rate di bawah ambang batas Google Play (bad behavior threshold < 0.47%).
- Kelulusan Seluruh Automated Tests & CI Verification: Pipeline CI harus 100% hijau (green build) pada commit kandidat rilis, meliputi format, analisis statis, dan regression tests.
- Umpan Balik Positif Tester: Umpan balik kualitatif mengenai kinerja UI, keterbacaan, dan responsivitas pada ragam resolusi layar serta versi sistem operasi Android yang berbeda.

### 2. Bagaimana kriteria dan proses Anda dalam memutuskan untuk menahan (hold/rollback) atau melanjutkan rilis?
Kriteria Pengambilan Keputusan:
- Lanjutkan Rilis (Proceed / Rollout):
  - Metrik crash-free sessions stabil >= 99.5%.
  - Tidak ditemukan masalah keamanan (security vulnerability) atau kebocoran data.
  - Sinyal telemetry membuktikan adopsi fitur berjalan normal tanpa anomali lonjakan error.
- Tahan / Hentikan Distribusi (Hold / Pause Rollout):
  - Terjadi lonjakan issue baru (new crash cluster) segera setelah update diunduh tester.
  - Ditemukan error non-fatal yang merusak integritas data (misal catatan gagal disimpan).
  - Terdapat laporan kendala performa berat (stuttering, battery drain ekstrem, atau memory leak).
- Lakukan Penarikan (Rollback):
  - Terjadi crash fatal saat aplikasi pertama kali dibuka (crash-on-launch) yang memengaruhi lebih dari 1% pengguna.
  - Terjadi kerusakan atau corruption pada skema database lokal saat migrasi.

Prosedur Eksekusi Triage & Rollback:
1. Identifikasi & Hentikan: Hentikan sementara persentase rilis (halt staged rollout) pada Play Console atau nonaktifkan link distribusi tester.
2. Reproduksi Masalah: Mengunduh stack trace dan metadata perangkat dari Crashlytics, lalu mereproduksi masalah pada perangkat lab/emulator lokal.
3. Analisis Akar Masalah (Root Cause Analysis): Menentukan apakah bug disebabkan oleh kode Dart, dependensi native, atau kompatibilitas OS.
4. Perbaikan & Pengujian Tambahan: Membuat branch fix/*, memperbaiki bug, menambahkan unit/widget test regresi untuk mencegah kejadian berulang.
5. Rilis Patch Baru: Menaikkan build number (misal 1.0.0+3), memvalidasi di CI, dan merilis ulang kandidat patch perbaikan.

### 3. Data apa saja yang tidak perlu dan dilarang dikirim ke layanan monitoring (Analytics & Crashlytics)?
Berdasarkan prinsip Privacy by Design, regulasi privasi global (GDPR, CCPA), dan ketentuan keamanan Jobsheet 14, data berikut dilarang keras dikirim ke Analytics, Crashlytics, maupun prompt AI:
- Informasi Pribadi Pengguna (Personally Identifiable Information / PII): Nama lengkap, alamat email pribadi, nomor telepon, tanggal lahir, NIK/NIM, alamat rumah, atau nomor identitas kependudukan.
- Data Kredensial & Autentikasi: Password akun, token sesi JWT, refresh token, API keys privat (seperti Gemini AI API Key), PIN, atau private cryptographic keys.
- Isi Konten Pribadi Pengguna (User-Generated Content): Teks judul dan isi catatan pengguna, log obrolan dengan asisten AI, isi clipboard perangkat, atau lampiran foto/file privat.
- Informasi Finansial & Medis: Nomor kartu kredit, rekening bank, maupun data kesehatan sensitif.
- Pengenal Perangkat yang Bersifat Permanen (Hardware Identifiers): Nomor IMEI perangkat fisik, MAC Address Wi-Fi, atau Serial Number perangkat (Google mewajibkan penggunaan Advertising ID yang dapat direset pengguna atau App Instance ID acak).

Praktik Terbaik yang Diterapkan:
Hanya kirimkan data telemetri yang bersifat teknis, agregat, dan non-identifiable, seperti nama aksi/event abstrak (beta_feedback_sent), nama layar tampilan (screen_name: home), versi aplikasi (1.0.0+2), versi OS Android, model perangkat teknis, serta obfuscated stack trace tanpa string input pengguna.

---

## 5. Dokumentasi Pengujian dan Screenshot

Dokumentasi tangkapan layar pengujian pada Android Emulator Pixel 7:
1. Aplikasi Terinstal dan Terbuka: [docs/screenshots/01_app_installed_and_opened.png](docs/screenshots/01_app_installed_and_opened.png)
2. Home Notes Berjalan: [docs/screenshots/02_home_notes_running.png](docs/screenshots/02_home_notes_running.png)
3. Menu Beta & Telemetry: [docs/screenshots/03_beta_telemetry_menu_open.png](docs/screenshots/03_beta_telemetry_menu_open.png)
4. Event Analytics Terpicu: [docs/screenshots/04_feedback_event_triggered.png](docs/screenshots/04_feedback_event_triggered.png)
5. Laporan Crashlytics Non-Fatal: [docs/screenshots/05_telemetry_events_triggered.png](docs/screenshots/05_telemetry_events_triggered.png)

---

## 6. Laporan Praktikum dan Catatan Rilis
Laporan resmi jobsheet beserta analisis mendalam, catatan rilis, dan hasil telemetry tersedia di:
- Laporan Praktikum Rilis dan Monitoring: [docs/release-report.md](docs/release-report.md)
- Catatan Rilis Beta (Release Notes): [docs/release-notes.md](docs/release-notes.md)

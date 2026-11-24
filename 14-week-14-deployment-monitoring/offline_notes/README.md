# Offline Notes - Praktikum Minggu 14: Deployment & Monitoring

Aplikasi Flutter **Offline Notes** dengan arsitektur Clean Architecture, integrasi SQLite lokal, asistensi AI, dan pipeline **Rilis Beta Terbatas serta Monitoring Pasca-Rilis (Firebase Crashlytics & Analytics)**.

---

## 📱 Ringkasan Proyek
- **Mata Kuliah:** Pemrograman Mobile
- **Modul:** Minggu 14 – Rilis Beta Terbatas, Umpan Balik, dan Monitoring Pasca-Rilis
- **Nama Pengembang:** Muhammad Nuril Huda
- **NIM:** 244107020004
- **Versi Aplikasi:** `1.0.0+2` (Kandidat Rilis Beta)
- **Branch Kerja:** `feature/week-14-beta-release-monitoring`

---

## ✨ Fitur Utama
1. **Penyimpanan Catatan Offline:** Manajemen catatan lokal cepat dan andal menggunakan SQLite (`sqflite`).
2. **Pencarian Real-Time:** Filter judul catatan instan tanpa membebani performa UI.
3. **Asisten AI Terintegrasi:** Integrasi layanan Gemini AI dengan sistem prompt berbatas bahasa dan proteksi privasi.
4. **Firebase Crashlytics:** Penangkapan error fatal (Flutter error & asynchronous platform error) dan non-fatal secara real-time.
5. **Firebase Analytics:** Pelacakan event non-sensitif (`beta_feedback_sent`, `beta_app_opened`) untuk pemantauan adopsi fitur tanpa melanggar privasi pengguna.
6. **Menu Telemetry Beta:** Menu interaktif pada AppBar untuk memudahkan tester mengirim feedback dan menguji penanganan error.

---

## 🚀 Menjalankan dan Menguji Proyek

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
- **AAB:** `build/app/outputs/bundle/release/app-release.aab`
- **APK:** `build/app/outputs/flutter-apk/app-release.apk`

---

## 📑 Laporan Praktikum Lengkap
Laporan resmi pengerjaan Jobsheet 14 beserta bukti screenshot, analisis log AI, dan refleksi rilis tersedia di:
👉 **[Laporan Rilis dan Monitoring (release-report.md)](docs/release-report.md)**

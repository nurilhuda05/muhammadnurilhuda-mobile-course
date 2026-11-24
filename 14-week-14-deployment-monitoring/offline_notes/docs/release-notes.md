# Catatan Rilis Beta (Release Notes) - Offline Notes

**Nama Aplikasi:** Offline Notes  
**Versi Aplikasi:** 1.0.0  
**Build Number:** 2 (Versi Kode: 2)  
**Target Rilis:** Internal Testing (Google Play Console) / Firebase App Distribution  
**Tanggal Rilis:** 24 November 2026  
**Kandidat Tag/Commit:** `v1.0.0+2-beta`  

---

## 1. Ringkasan Perubahan
* **Peningkatan Build Number:** Menaikkan build number dari `1.0.0+1` ke `1.0.0+2` untuk memenuhi persyaratan versioning artefak Google Play / Firebase Distribution.
* **Kesiapan Rilis Produksi/Beta:** Menghasilkan Android App Bundle (`app-release.aab`) teroptimasi dengan tree-shaking font assets.
* **Integrasi Monitoring Telemetry:** Menyiapkan integrasi Firebase Crashlytics untuk penangkapan crash fatal dan non-fatal, serta Firebase Analytics untuk pengumpulan umpan balik pengguna non-sensitif.
* **Menu Uji Telemetry Internal:** Menyediakan menu pengujian terkontrol pada antarmuka aplikasi untuk memvalidasi alur telemetry sebelum distribusi luas.

---

## 2. Batasan Rilis (Release Constraints & Known Limitations)
1. **Audiens Terbatas:** Build ini khusus ditujukan untuk kelompok penguji internal (internal tester) yang terdaftar.
2. **Kerahasiaan Kredensial:** Seluruh data sensitif, signing key, token API, dan data pengguna disamarkan dan tidak diunggah ke repositori publik.
3. **Penyimpanan Lokal:** Penyimpanan catatan bersifat offline-first berbasis SQLite lokal; sinkronisasi cloud real-time belum diaktifkan pada build beta terbatas ini.
4. **Pengujian Crash:** Pemicuan crash fatal sengaja dibatasi hanya melalui tombol uji khusus pada menu pengujian telemetry terkontrol di perangkat uji.

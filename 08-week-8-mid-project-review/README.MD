# PRAKTIKUM 1
### 1. Audit Riwayat
![screenshot](screenshot/praktikum-1/1.png)
#### a. Commit langsung ke main<
Seluruh 15 commit berada di branch main. Tidak ada branch develop maupun feature/*. Dampaknya, tidak ada tahap review sebelum kode masuk ke branch utama.
#### b. Pesan commit tidak deskriptif
Beberapa pesan commit hanya menyebut waktu, bukan perubahan yang dilakukan, misalnya Praktikum 1 Minggu 7 (muncul 3 kali, satu di antaranya typo “MInggu”), Praktikum 2 Minggu 7, dan Memperbaiki Tampilan Readme (muncul 3 kali). Dampaknya, riwayat sulit dilacak dan sulit di-revert.
#### c. Branch berumur Panjang
Tidak ditemukan. Repository hanya memiliki branch main, sehingga belum menerapkan Git Flow.
#### d. File untracked
Tidak ditemukan. Hasil git status menunjukkan working tree clean.

### 2. Buat branch kerja yang benar
#### a. Buat branch develop dari main
- git checkout -b develop<br>
![screenshot](screenshot/praktikum-1/2.png)<br>
 Membuat branch baru bernama develop dan langsung pindah ke branch itu. Branch baru ini salinan dari branch tempat kamu berada sekarang (yaitu main). Tanda -b artinya “buat baru”.<br>
- git push -u origin develop<br>
![screenshot](screenshot/praktikum-1/3.png)<br>
Mengirim branch develop dari laptop ke GitHub (origin). Tanda -u menghubungkan branch lokal dengan branch di GitHub, jadi nanti cukup mengetik git push atau git pull tanpa menyebut nama branch lagi.<br>
#### b. Buat branch fitur dari develop
- git checkout -b feat/notes-validation<br>
![screenshot](screenshot/praktikum-1/4.png)<br>
Sama seperti sebelumnya yaitu membuat branch baru feat/notes-validation dan pindah ke sana. Karena sedang di develop, branch fitur ini dibuat dari develop. Semua perubahanmu nanti aman di branch ini dan tidak mengganggu develop atau main.<br>
- git branch<br>
![screenshot](screenshot/praktikum-1/5.png)<br>
git branch menampilkan tiga branch lokal, yaitu main, develop, dan feat/notes-validation. Tanda * berada pada feat/notes-validation, artinya branch fitur tersebut sedang aktif dan dibuat dari develop. Branch main yang selalu siap dirilis dan branch develop untuk integrasi fitur tetap tidak berubah.<br>
#### c. Melakukan perubahan kecil
menambah validasi di file add_note.dart yaitu catatan dengan judul kosong tidak boleh disimpan.<br>
#### d. Simpan dengan commit yang rapi
- Cek Perubahan<br>
![screenshot](screenshot/praktikum-1/6.png)<br>
git push -u origin feat/notes-validation<br>
- git add -p<br>
![screenshot](screenshot/praktikum-1/7.png)<br>
Perintah git add -p digunakan untuk memilih perubahan secara bertahap (per potongan) sebelum dimasukkan ke commit. Git menampilkan satu potongan perubahan (1/1) berisi penambahan async dan validasi title.trim().isEmpty, lalu dijawab y agar masuk ke staging.<br>
- git commit -m "feat(notes): validasi judul kosong di use case AddNote"<br>
![screenshot](screenshot/praktikum-1/8.png)<br>
Perintah ini menyimpan perubahan yang sudah di-staging ke riwayat Git dengan pesan berformat tipe(scope): deskripsi. Hasilnya adalah commit 37094a6 dengan 1 file berubah, 4 baris ditambah, dan 1 baris dihapus. Pesan commit menjelaskan dengan jelas apa yang diubah dan di bagian mana.<br>
- git push -u origin feat/notes-validation<br>
![screenshot](screenshot/praktikum-1/9.png)<br>
Perintah ini mengirim branch feat/notes-validation dari laptop ke GitHub (origin). Opsi -u menghubungkan branch lokal dengan branch di GitHub sehingga selanjutnya cukup memakai git push. Hasil [new branch] feat/notes-validation -> feat/notes-validation menandakan push berhasil dan branch siap dibuatkan Pull Request<br>

### 3. Perbaiki satu commit buruk (simulasi)
a. **Sebelum**: Mengcopy projek minggu ke 5 ke project minggu 7<br>
**Sesudah**: chore(week7): salin project minggu 5 sebagai dasar refactoring<br>
**Alasan**: pesan lama sudah menjelaskan isi, tetapi belum memakai tipe dan scope. Tipe chore tepat karena ini tugas pendukung, bukan fitur.<br>

b. **Sebelum**: Memperbaiki Tampilan Readme<br>
**Sesudah**: docs(readme): rapikan tampilan dan format README<br>
**Alasan**: tipe docs langsung menunjukkan perubahan dokumentasi, dan scope readme menunjukkan lokasinya.<br>

c. **Sebelum**: Menghapus isi screenshot dan readme<br>
**Sesudah**: docs(readme): hapus isi README dan screenshot lama<br>
**Alasan**: pesan lama tidak memakai tipe. Tipe docs dan scope readme membuat jenis dan lokasi perubahan langsung terbaca<br>






# HW 2 - Computational Thinking dengan Dart

Use case: Pembayaran (E-Wallet)

Business rule:
- Saldo tidak boleh minus
- Limit transaksi harian Rp2.000.000
- PIN salah 3 kali, akun terblokir

---

## Bagian A - Dokumen Analisis

### 1. Problem Statement
Aplikasi e-wallet butuh fitur pembayaran. Pengguna membayar dengan saldo e-wallet setelah memasukkan PIN. Pembayaran ditolak kalau saldo tidak cukup, total transaksi hari itu lebih dari Rp2.000.000, atau akun terblokir karena salah PIN 3 kali.

### 2. Actor
- Pengguna
- Sistem e-wallet

### 3. Input & Output
- Input: PIN dan nominal pembayaran
- Output: hasil pembayaran (berhasil / pinSalah / terblokir / melebihiLimit / saldoKurang)

### 4. Functional Requirement
- FR-01: Pengguna dapat membayar memakai saldo e-wallet.
- FR-02: Sistem mengecek PIN sebelum membayar.
- FR-03: Sistem menampilkan hasil pembayaran.
- FR-04: Sistem menyimpan riwayat pembayaran yang berhasil.

### 5. Business Rules
- BR-01: Saldo tidak boleh minus.
- BR-02: Total transaksi per hari maksimal Rp2.000.000.
- BR-03: PIN salah 3 kali, akun terblokir.
- BR-04: Akun terblokir tidak bisa bayar lagi, walaupun PIN benar.

### 6. Decomposition
```
bayar
├── cekPin            -> cek PIN, blokir kalau salah 3 kali   (BR-03)
├── cekSaldo          -> cek saldo tidak minus                (BR-01)
├── cekLimit          -> cek limit harian                     (BR-02)
└── simpanTransaksi   -> kurangi saldo, catat riwayat         (FR-04)
```

### 7. Pattern Recognition
- Setiap pembayaran dicek berurutan: terblokir, PIN, saldo, limit. Kalau ada yang gagal, langsung berhenti.
- Salah PIN dihitung pakai counter, balik ke 0 kalau PIN benar.
- Saldo dan limit sama-sama membandingkan angka dengan batas.

### 8. Abstraction
- enum StatusBayar: berhasil, pinSalah, terblokir, melebihiLimit, saldoKurang
- Variabel akun: pinBenar, saldo, totalHariIni, salahPin, terblokir
- List riwayat untuk menyimpan pembayaran yang berhasil

### 9. Algorithm
1. Kalau akun terblokir, gagal.
2. Cek PIN. Kalau salah, tambah hitungan salah. Kalau sudah 3, akun diblokir. Gagal.
3. Kalau saldo kurang dari nominal, gagal.
4. Kalau total hari ini + nominal lebih dari 2.000.000, gagal.
5. Kurangi saldo, tambah total hari ini, simpan riwayat.
6. Hasilnya berhasil.

### 10. Flowchart
```
          START
            |
            v
    Input pin, nominal
            |
            v
   Akun terblokir? --- Ya ---> "terblokir" ----------+
            | Tidak                                  |
            v                                        |
      PIN benar? --- Tidak --> "pinSalah" -----------+
            | Ya               (salah 3x = blokir)   |
            v                                        |
   Saldo < nominal? --- Ya ---> "saldoKurang" -------+
            | Tidak                                  |
            v                                        |
  Total + nominal > 2.000.000? -- Ya --> "melebihiLimit" --+
            | Tidak                                  |
            v                                        |
  Kurangi saldo, simpan riwayat                      |
            |                                        |
            v                                        |
       "berhasil"                                    |
            |                                        |
            v                                        |
     Tampilkan hasil <-------------------------------+
            |
            v
           END
```

### 11. Pseudocode
```
mulai
input pin, nominal

jika akun terblokir
    hasil = terblokir
jika tidak, jika pin salah
    salahPin = salahPin + 1
    jika salahPin == 3, akun diblokir
    hasil = pinSalah (atau terblokir)
jika tidak, jika saldo < nominal
    hasil = saldoKurang
jika tidak, jika totalHariIni + nominal > 2000000
    hasil = melebihiLimit
jika tidak
    saldo = saldo - nominal
    totalHariIni = totalHariIni + nominal
    simpan riwayat
    hasil = berhasil

tampilkan hasil
selesai
```

---

## Bagian B - Program Dart

Kode ada di `main.dart`, bisa dijalankan di DartPad.

Checklist:
- [x] Memakai enum (enum StatusBayar)
- [x] Minimal 4 function (cekPin, cekSaldo, cekLimit, simpanTransaksi, bayar)
- [x] Menggunakan List (riwayat)
- [x] Menggunakan percabangan (if) dan perulangan (for)
- [x] Semua business rule diimplementasikan
- [x] main() berisi minimal 5 skenario uji (sukses dan gagal) dengan komentar expected output
- [x] Tidak menggunakan Flutter

Skenario uji (saldo awal 5.000.000, PIN benar 1234):

| No | Skenario | Expected |
|---|---|---|
| 1 | Bayar 1.500.000, PIN benar | berhasil |
| 2 | Bayar 4.000.000 (saldo sisa 3.500.000) | saldoKurang |
| 3 | Bayar 600.000 (total hari ini jadi 2.100.000) | melebihiLimit |
| 4 | PIN salah ke-1 | pinSalah |
| 5 | PIN salah ke-2 | pinSalah |
| 6 | PIN salah ke-3 | terblokir |
| 7 | PIN benar tapi akun sudah terblokir | terblokir |

Output di layar:
```
StatusBayar.berhasil
StatusBayar.saldoKurang
StatusBayar.melebihiLimit
StatusBayar.pinSalah
StatusBayar.pinSalah
StatusBayar.terblokir
StatusBayar.terblokir
Saldo akhir: 3500000
Riwayat pembayaran:
Bayar 1500000
```

---

## Bagian C - Tabel Traceability

| Business Rule | Function | Skenario Uji |
|---|---|---|
| BR-01 Saldo tidak boleh minus | cekSaldo, bayar | Skenario 2 (saldoKurang) |
| BR-02 Limit harian Rp2.000.000 | cekLimit, bayar | Skenario 3 (melebihiLimit) |
| BR-03 PIN salah 3 kali, terblokir | cekPin, bayar | Skenario 4, 5 (pinSalah), Skenario 6 (terblokir) |
| BR-04 Akun terblokir tidak bisa bayar | bayar | Skenario 7 (terblokir, PIN benar) |
| FR-01 Membayar dengan saldo | bayar | Skenario 1 (berhasil) |
| FR-04 Simpan riwayat | simpanTransaksi | Skenario 1 (riwayat Bayar 1500000) |

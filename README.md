# FermSense - Firmware Sensor Fermentasi Sourdough

Firmware ESP32 untuk memantau fermentasi sourdough: 3 sensor suhu DS18B20 dan satu sensor pH analog, lalu mengirim telemetri lewat WiFi (HTTPS) ke backend FermSense.

Alur data: sensor (suhu + pH) -> ESP32 -> WiFi/HTTPS -> API Vercel -> Supabase + bot Discord.

> **Baru pertama kali pakai alat IoT?** Lewati bagian teknis dulu. Cukup ikuti **Panduan Pemula (Windows 11)** di bawah. Kamu hanya perlu memasang 2 aplikasi, tanpa perangkat keras.

---

## Panduan Pemula (Windows 11)

### Yang TIDAK perlu kamu lakukan

- Tidak perlu punya ESP32 atau komponen fisik.
- Tidak perlu memasang arduino-cli, Python, driver USB, atau Arduino IDE.
- Tidak perlu memasang Docker (Docker hanya untuk yang mau mengubah kode program).
- Tidak perlu menyalakan solder atau apa pun.

Kamu hanya **menjalankan simulasi di komputer** untuk melihat alat ini bekerja.

### Checklist kebutuhan

| Kebutuhan | Keterangan |
|---|---|
| Windows 11 | Sudah ada |
| Internet | Wajib (untuk login Wokwi dan demo kirim data) |
| VS Code | Editor gratis, akan dipasang |
| Ekstensi Wokwi | Dipasang dari dalam VS Code |
| Akun Wokwi | Gratis (Community License) |
| Ruang disk | Sekitar 500 MB untuk VS Code + ekstensi |

### Langkah 1 - Dapatkan folder proyek ini

Pastikan kamu punya **seluruh folder** (bukan hanya file `.ino`). Kalau dari GitHub, klik **Code -> Download ZIP**, lalu ekstrak.

Pindahkan folder itu ke path **tanpa spasi**, contoh:

```
C:\dev\SensorSourDough
```

Hindari `Downloads` atau `Documents` karena biasanya mengandung spasi.

> **Jangan mengganti nama folder atau nama file `SensorSourDough.ino`.** Nama keduanya harus sama, kalau tidak, alat ini tidak bisa dijalankan.

### Langkah 2 - Pasang VS Code

1. Buka https://code.visualstudio.com/ .
2. Klik tombol **Download for Windows**.
3. Jalankan file hasil unduhan, klik **Next** sampai selesai (pengaturan bawaan sudah cukup).
4. Buka **Visual Studio Code**.

### Langkah 3 - Pasang ekstensi Wokwi

1. Di VS Code, klik ikon **Extensions** di bar kiri (atau tekan `Ctrl` + `Shift` + `X`).
2. Di kotak pencarian, ketik **Wokwi**.
3. Pilih **Wokwi Simulator** (pembuat: Wokwi), klik **Install**.
4. Kalau diminta login/aktivasi, ikuti petunjuknya memakai akun Wokwi (daftar gratis di https://wokwi.com ).

### Langkah 4 - Buka folder proyek

1. Di VS Code: menu **File -> Open Folder...**
2. Pilih folder `C:\dev\SensorSourDough`, klik **Select Folder**.
3. Kalau muncul pertanyaan "Do you trust the authors?", pilih **Yes**.
4. Periksa panel kiri: kamu harus melihat file `wokwi.toml`, `diagram.json`, dan `SensorSourDough.ino`. Kalau tidak ada, berarti folder yang dibuka salah.

### Langkah 5 - Jalankan simulasi

1. Tekan `F1` (Command Palette).
2. Ketik **Wokwi: Start Simulator**, lalu tekan `Enter`.
3. Akan terbuka tab **Wokwi Simulator** berisi gambar rangkaian (ESP32, sensor suhu, dan potensiometer).
4. Tunggu beberapa detik. Kamu akan melihat tulisan berjalan seperti di bawah ini.

### Apa yang harus muncul (tanda berhasil)

```
=== Fermentation Monitor Started ===
DS18B20 found: 3
Connecting to WiFi.... WiFi Connected!
--- Reading ---
Sensor 1: 24.00 °C
Sensor 2: 22.00 °C
Sensor 3: 26.00 °C
pH (simulated): 3.00
ADC raw: 0 | voltage: 0.000 V
Status fermentasi: FERMENTASI AKTIF (pH <= 4.6)
```

- Tulisan ini muncul di panel **Terminal** -> tab **Wokwi Terminal**, atau di jendela **Serial Monitor** dalam tab simulator.
- Kalau `DS18B20 found: 3` dan ada baris `Response Code: 200`, berarti semuanya bekerja.

### Langkah 6 - Coba ubah sensornya

- **Ubah pH:** tarik kenop **potensiometer** (bulatan berwarna) ke kiri/kanan. Nilai pH berubah dari `3.00` sampai `6.00`.
- **Ubah suhu:** klik salah satu kotak sensor DS18B20, akan muncul popup dengan slider suhu.
- **Hentikan simulasi:** tekan tombol **kotak (Stop)** di pojok kiri atas simulator.

---

## Troubleshooting (kalau ada masalah)

| Gejala | Kemungkinan penyebab | Solusi |
|---|---|---|
| `Wokwi: Start Simulator` tidak ada di daftar `F1` | Ekstensi belum terpasang / VS Code belum dimuat ulang | Pasang ulang ekstensi Wokwi, lalu tutup dan buka VS Code |
| Diminta lisensi atau "sign in" | Belum login Wokwi | Login akun Wokwi (gratis), pastikan internet aktif |
| Simulator jalan tapi tidak ada teks | Panel yang dilihat salah | Buka panel **Terminal**, pilih tab **Wokwi Terminal**. Atau tekan Stop lalu Play lagi |
| Error firmware / `.bin` tidak ditemukan | Folder `build/` tidak ikut terunduh | Unduh repo/ZIP secara lengkap, bukan hanya file `.ino` |
| Muncul `DS18B20 found: 1` | `diagram.json` versi lama | Pakai versi terbaru dari repo ini |
| pH selalu `3.00` dan `raw 0` | Potensiometer di posisi paling kiri | Tarik kenop potensiometer ke kanan |
| Simulasi tidak bisa konek WiFi | Tidak ada internet | Nyalakan internet (simulasi memakai gateway Internet Wokwi) |
| Tidak ada `Response Code: 200` | Server/pengiriman gagal | Cek internet; server backend harus aktif |
| Tombol simulator tidak merespons | Tab simulator tidak fokus | Klik sekali di area simulator |

---

## Istilah singkat

| Istilah | Arti |
|---|---|
| Firmware | Program yang ditanam ke chip ESP32 |
| Compile / build | Mengubah kode menjadi firmware |
| Simulator | Menjalankan firmware secara maya, tanpa alat fisik |
| Wokwi | Layanan simulator rangkaian dan ESP32 |
| VS Code | Aplikasi editor kode (gratis) |
| Ekstensi | Tambahan yang dipasang di VS Code |
| Docker | "Kotak" berisi alat build agar hasilnya sama di semua komputer |

---

## Bagian teknis

### Pin

| Fungsi | Pin board | GPIO |
|---|---|---|
| DS18B20 (1-Wire, 3 sensor, pull-up 4.7k ke 3V3) | D4 | GPIO4 |
| Sensor pH analog | D34 | GPIO34 |

Catatan: nama pin yang valid untuk board `wokwi-esp32-devkit-v1` adalah `D4`, `D34`, `TX0`, `RX0`, dst. Jangan memakai `IO4`/`IO34`.

### Kontrak payload

Firmware melakukan POST JSON ke `https://fermsense.vercel.app/api/telemetry`:

```json
{"pH": 3.50, "temp": 24.0}
```

Nama field (`pH`, `temp`) harus disepakati dengan repo web/backend. Jangan mengubahnya sepihak.

---

## Build ulang firmware (opsional, hanya kalau mengubah kode)

Firmware siap pakai sudah disertakan di `build/`, jadi untuk sekadar menjalankan simulasi kamu **tidak perlu Docker dan tidak perlu langkah ini**.

> **Penting:** kalau hanya ingin menjalankan simulasi, lewati seluruh bagian ini. Docker hanya dibutuhkan untuk mengubah dan mengompilasi ulang kode program.

### Cara A - Pakai Docker (disarankan untuk build)

Syarat:

- Windows 11 dengan **Docker Desktop** (backend WSL2) terpasang dan **sudah dibuka** (ikon Docker di taskbar berwarna hijau).
- Proyek disimpan di path tanpa spasi, misalnya `C:\dev\SensorSourDough`.

Windows (buka terminal di folder proyek: klik kanan folder -> **Open in Terminal**):

```bat
build.bat
```

Linux / macOS:

```bash
./build.sh
```

Skrip akan membangun image (arduino-cli + core `esp32:esp32@2.0.6` + `OneWire` + `DallasTemperature`), menyalin sumber ke path Linux di dalam container, meng-compile, lalu menyalin `build/` kembali ke proyek. Build pertama mengunduh toolchain (image sekitar 4,7 GB), jadi lebih lama.

### Cara B - Tanpa Docker

Kalau Docker belum terpasang dan tidak ingin dipasang:

1. **Cara termudah:** minta folder `build/esp32.esp32.esp32/` terbaru dari pembuat proyek (yang punya Docker), lalu timpa folder `build/` di komputermu. Simulasi langsung memakai firmware baru itu.
2. **Mengompilasi sendiri (Arduino IDE 2.x):**
   1. Pasang **Arduino IDE 2.x** (https://www.arduino.cc/en/software).
   2. Buka **File -> Preferences**, isi **Additional boards manager URLs** dengan `https://espressif.github.io/arduino-esp32/package_esp32_index.json`.
   3. Buka **Tools -> Board -> Boards Manager**, cari **esp32**, pasang versi **2.0.6**.
   4. Buka **Tools -> Manage Libraries**, pasang **OneWire** dan **DallasTemperature**.
   5. Buka file `SensorSourDough.ino` dari folder ini.
   6. Pilih **Tools -> Board -> ESP32 Arduino -> ESP32 Dev Module**.
   7. Jalankan **Sketch -> Export Compiled Binary**.
   8. Letakkan hasil `SensorSourDough.ino.bin` (dan `.elf` bila ada) ke folder `build/esp32.esp32.esp32/`.

### Native (khusus mesin penulis, Linux)

```bash
./build-native.sh
```

Butuh arduino-cli + core esp32 + library `OneWire`/`DallasTemperature` + `python3-serial` yang sudah terpasang.

---

## Struktur

```
SensorSourDough.ino              sketch utama (nama file harus sama dengan nama folder)
diagram.json                     rangkaian Wokwi
wokwi.toml                       konfigurasi firmware untuk ekstensi Wokwi
libraries.txt                    daftar library untuk Wokwi
build/esp32.esp32.esp32/         firmware siap pakai (.bin/.elf)
docker/Dockerfile                image build (arduino-cli + core + library)
docker/entrypoint.sh             logika compile di dalam container
build.sh / build.bat             pembungkus build (Docker)
build-native.sh                  build native untuk mesin penulis
```

## Kalibrasi pH

Kurva `pH = 3.0 + voltage * (3.0 / 3.3)` hanya untuk potensiometer simulasi. Untuk modul pH asli, ganti dengan hasil kalibrasi dua titik memakai larutan buffer pH 4.0 dan 7.0.

## Terkait

- Web/backend (repo terpisah): https://fermsense.vercel.app

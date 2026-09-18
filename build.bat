@echo off
setlocal
cd /d "%~dp0"

where docker >nul 2>nul
if errorlevel 1 (
  echo Docker tidak ditemukan.
  echo.
  echo Untuk MENJALANKAN simulasi, Docker tidak diperlukan.
  echo Cukup buka folder ini di VS Code lalu jalankan "Wokwi: Start Simulator".
  echo.
  echo Untuk BUILD ULANG tanpa Docker, lihat "Cara B - Tanpa Docker" di README.md.
  exit /b 1
)

docker info >nul 2>nul
if errorlevel 1 (
  echo Docker terpasang tetapi daemon belum jalan.
  echo Buka Docker Desktop, tunggu sampai ikonnya hijau, lalu jalankan build.bat lagi.
  exit /b 1
)

set IMAGE=sensorsourdough-build:esp32-2.0.6
docker build -t %IMAGE% docker
if errorlevel 1 exit /b 1
docker run --rm -v "%cd%":/work %IMAGE%

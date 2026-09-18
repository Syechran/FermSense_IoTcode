#!/usr/bin/env bash
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="${HOME}/.cache/SensorSourDough-build/SensorSourDough"
CLI="${HOME}/bin/arduino-cli"
[ -x "$CLI" ] || CLI="$(command -v arduino-cli)"

export ARDUINO_DIRECTORIES_DATA="${ARDUINO_DIRECTORIES_DATA:-$HOME/snap/arduino-cli/current/.arduino15}"
export ARDUINO_DIRECTORIES_USER="${ARDUINO_DIRECTORIES_USER:-$HOME/snap/arduino-cli/current/Arduino}"

mkdir -p "$WORK"
rm -f "$WORK"/*.ino "$WORK/sketch.yaml" "$WORK/diagram.json" "$WORK/wokwi.toml" "$WORK/libraries.txt"
cp "$SRC/SensorSourDough.ino" "$SRC/diagram.json" "$SRC/wokwi.toml" "$SRC/libraries.txt" "$WORK/"

"$CLI" compile -e --fqbn esp32:esp32:esp32 "$WORK"

rm -rf "$SRC/build"
cp -r "$WORK/build" "$SRC/"
rm -f "$SRC/build/esp32.esp32.esp32/"*.map
echo "Firmware: $SRC/build/esp32.esp32.esp32/SensorSourDough.ino.bin"

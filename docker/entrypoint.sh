#!/usr/bin/env bash
set -euo pipefail

SRC=/work
BUILD=/tmp/sensorsourdough/SensorSourDough

mkdir -p "$BUILD"
rm -f "$BUILD"/*
cp "$SRC/SensorSourDough.ino" "$SRC/diagram.json" "$SRC/wokwi.toml" "$SRC/libraries.txt" "$BUILD/"

arduino-cli compile -e --fqbn esp32:esp32:esp32 "$BUILD"

rm -rf "$SRC/build"
cp -r "$BUILD/build" "$SRC/"
rm -f "$SRC/build/esp32.esp32.esp32/"*.map

echo "Firmware: build/esp32.esp32.esp32/SensorSourDough.ino.bin"

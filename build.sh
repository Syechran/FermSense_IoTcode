#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

IMAGE="sensorsourdough-build:esp32-2.0.6"

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker build -t "$IMAGE" docker/
  docker run --rm --user "$(id -u):$(id -g)" -v "$PWD":/work "$IMAGE"
else
  echo "Docker tidak tersedia; memakai build-native.sh" >&2
  exec "$(dirname "${BASH_SOURCE[0]}")/build-native.sh"
fi

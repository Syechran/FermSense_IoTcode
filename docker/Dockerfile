FROM debian:bookworm-slim

ARG ESP32_CORE_VERSION=2.0.6

ENV ARDUINO_DIRECTORIES_DATA=/arduino/data \
    ARDUINO_DIRECTORIES_DOWNLOADS=/arduino/downloads \
    ARDUINO_DIRECTORIES_USER=/arduino/user \
    ARDUINO_BOARD_MANAGER_ADDITIONAL_URLS=https://espressif.github.io/arduino-esp32/package_esp32_index.json \
    PATH=/arduino/bin:${PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl python3 python3-serial \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /arduino/bin /arduino/data /arduino/user /arduino/downloads \
    && curl -fsSL https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_64bit.tar.gz -o /tmp/arduino-cli.tar.gz \
    && tar -xzf /tmp/arduino-cli.tar.gz -C /arduino/bin arduino-cli \
    && rm /tmp/arduino-cli.tar.gz \
    && arduino-cli core update-index \
    && arduino-cli core install "esp32:esp32@${ESP32_CORE_VERSION}" \
    && arduino-cli lib install OneWire DallasTemperature \
    && chmod -R 777 /arduino

ENV HOME=/arduino \
    XDG_CACHE_HOME=/arduino/.cache

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /work
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

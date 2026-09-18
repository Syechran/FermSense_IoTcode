#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <OneWire.h>
#include <DallasTemperature.h>

#define ONE_WIRE_BUS 4
#define PH_PIN 34

const char* ssid = "Wokwi-GUEST";
const char* password = "";
const char* serverUrl = "https://fermsense.vercel.app/api/telemetry";

const unsigned long WIFI_TIMEOUT = 15000;
const unsigned long SEND_INTERVAL = 10000;

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

unsigned long lastSend = 0;

void connectWiFi() {
  if (WiFi.status() == WL_CONNECTED) return;

  Serial.print("Connecting to WiFi");
  WiFi.begin(ssid, password, 6);

  unsigned long start = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - start < WIFI_TIMEOUT) {
    delay(200);
    Serial.print(".");
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nWiFi Connected!");
  } else {
    Serial.println("\nWiFi gagal terhubung, coba lagi nanti.");
  }
}

void sendTelemetry(float pH, float temp) {
  if (WiFi.status() != WL_CONNECTED) {
    connectWiFi();
    if (WiFi.status() != WL_CONNECTED) return;
  }

  WiFiClientSecure client;
  client.setInsecure();

  HTTPClient http;
  http.begin(client, serverUrl);
  http.addHeader("Content-Type", "application/json");

  String jsonPayload = "{\"pH\":" + String(pH, 2) + ", \"temp\":" + String(temp, 1) + "}";
  Serial.println("Kirim Telemetri: " + jsonPayload);

  int httpResponseCode = http.POST(jsonPayload);
  if (httpResponseCode > 0) {
    Serial.println("Response Code: " + String(httpResponseCode));
  } else {
    Serial.println("Error HTTP POST: " + String(httpResponseCode));
  }

  http.end();
}

void setup() {
  Serial.begin(115200);
  sensors.begin();

  Serial.println("=== Fermentation Monitor Started ===");
  Serial.print("DS18B20 found: ");
  Serial.println(sensors.getDeviceCount());

  connectWiFi();
}

void loop() {
  sensors.requestTemperatures();

  Serial.println("--- Reading ---");
  for (int i = 0; i < sensors.getDeviceCount(); i++) {
    float temp = sensors.getTempCByIndex(i);
    Serial.print("Sensor ");
    Serial.print(i + 1);
    Serial.print(": ");
    Serial.print(temp);
    Serial.println(" °C");
  }

  int raw = analogRead(PH_PIN);
  float voltage = raw * (3.3 / 4095.0);
  float pH = 3.0 + voltage * (3.0 / 3.3); // mapping 0-3.3V → pH 3.0-6.0 (rentang fermentasi)
  Serial.print("pH (simulated): ");
  Serial.println(pH, 2);
  Serial.print("ADC raw: ");
  Serial.print(raw);
  Serial.print(" | voltage: ");
  Serial.print(voltage, 3);
  Serial.println(" V");
  Serial.print("Status fermentasi: ");
  Serial.println(pH <= 4.6 ? "FERMENTASI AKTIF (pH <= 4.6)" : "Belum matang (pH > 4.6)");

  if (millis() - lastSend >= SEND_INTERVAL) {
    lastSend = millis();
    float temp = sensors.getTempCByIndex(0);
    sendTelemetry(pH, temp);
  }

  Serial.println();
  delay(2000);
}

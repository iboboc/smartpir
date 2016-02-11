# ESP8266 SmartPIR with NodeMCU


## Requirements
 * ESP8266 ESP-01 or any
 * USB-TTL adapter for debug/programming
 * cheap battery powered motion sensor light
 * LM11117 3V3

## Description

With this code, we send a notification online (in cloud) every time the leds gets activated my motion (PIR sensor)

## Instructions

### Setting up your hardware

Please read this https://www.hackster.io/iboboc/smartbutton-pro-06ce5d

### Code logic explained:

- check and load if already is set up SSID name and password and URL
- try to connect to Wi-Fi
- start a timer and if an IP is not set in 10seconds, change the Wi-Fi mode to Access POint with the name "SmartButton" plus the unique ChipID
- start a web server on IP 192.168.1.1 and a form to enter SSID name, password and URL
- on submit, save to internal memmory and restart module
- once connected and an IP is available, get the current time from google
- connect to MQTT server if available
- create a TCP connection and send custom URL

NOTE: To reset wifi stored settings, connect GPIO02 to ground. If it is low, all settings are cleared (it will restart in Access Point mode).
In configuration mode, access it by connecting to PIR hotspot and open your browser to http://192.168.1.1


### Connections

The light gets powered by three batteries, which is around 4,5V
I've added a voltage regulator LM11117 which is soldered to LEDs voltage source.
Therefore, everytime the sensor is triggered, the regulator gets powered by 4V5, converts it 3V3 and then powering the ESP8266.
Once started, the code is executed and stays powered until LEDS goes off (around 60seconds)

- Power.
 - +5V to LM11117 from LEDs power supply
 - +3.3 volts from LM11117 to Vcc, Reset and CH_PD
 - ground from LED ground to ESP8266 and to LM11117 ground
- Communications.
 - TxD on the board to RxD on the adapter
 - RxD on the board to TxD on the adapter
 - Ground

 
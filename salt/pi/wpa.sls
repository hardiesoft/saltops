set_wifi_country:
  file.replace:
    - name: /etc/wpa_supplicant/wpa_supplicant.conf
    - pattern: "^country=.+"
    - repl: "country=NZ"

ensure_skynet_ssid:
  file.append:
    - name: /etc/wpa_supplicant/wpa_supplicant.conf
    - text: |
        network={
            ssid="skynet"
            psk="!!spotless-bird-morning"
        }
         

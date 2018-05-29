base:
  '*':
    - basics     
    - timezone     

  # Servers
  'server-*':
    - server/basics
    - server/unattended-upgrades
    - server/salt

  # Production servers
  'server-prod-*':
    - server/telegraf/main

  # Raspberry Pis
  'not server-*':
    - pi/basics
    - pi/auth
    - pi/salt-minion
    - pi/wpa
    - pi/rtc/main
    - pi/watchdog
    - pi/audio
    - pi/event-reporter
    - pi/thermal-recorder/main
    - pi/thermal-uploader/main
    - pi/dataplicity


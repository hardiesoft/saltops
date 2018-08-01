base:
  '*':
    - basics     
    - timezone     

  # Servers
  'server-*':
    - server/basics
    - server/unattended-upgrades
    - server/salt
    - server/users
    - server/sshd

  # Production servers
  'server-prod-*':
    - server/telegraf
    - server/mail-relay

  # Raspberry Pis
  'not server-*':
    - pi/basics
    - pi/auth
    - pi/salt-minion
    - pi/wpa
    - pi/rtc
    - pi/watchdog
    - pi/attiny-controller
    - pi/audio
    - pi/event-reporter
    - pi/audiobait
    - pi/thermal-recorder
    - pi/thermal-uploader
    - pi/dataplicity


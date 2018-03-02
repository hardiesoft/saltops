base:
  '*':
    - basics     
    - timezone     

  # Servers
  'server-*':
    - server/basics
    - server/unattended-upgrades

  # Raspberry Pis
  'not server-*':
    - pi/basics
    - pi/salt-minion
    - pi/watchdog
    - pi/pulseaudio
    - pi/thermal-recorder/main
    - pi/thermal-uploader/main
    - pi/dataplicity


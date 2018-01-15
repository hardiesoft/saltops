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
    - pi/salt-minion
    - pi/watchdog
    - pi/thermal-recorder/main
    - pi/thermal-uploader/main
    - pi/dataplicity


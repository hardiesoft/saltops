base:
  '*':
    - basics     
    - timezone     

  # Raspberry Pis
  'not server-*':
    - pi/salt-minion
    - pi/watchdog
    - pi/thermal-recorder/main
    - pi/thermal-uploader/main

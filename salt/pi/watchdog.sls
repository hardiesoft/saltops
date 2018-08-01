########################################################
# Configure systemd to ping the hardware watchdog
########################################################

/etc/systemd/system.conf:
  file.append:
    - text: 
      - "RuntimeWatchdogSec=15"

restart-systemd:
   module.wait:
     - name: cmd.run
     - cmd: "systemctl daemon-reexec"
     - watch:
       - file: /etc/systemd/system.conf

########################################################
# Update the 3g-watchdog and ensure it's running
########################################################

watchdog-pkgs:
  pkg.installed:
    - pkgs:
      - python3-rpi.gpio
      - python3-yaml

3g-watchdog:
  service.running:
    - enable: True
    - watch:
      - file: /usr/local/bin/3g-watchdog
      - file: /etc/systemd/system/3g-watchdog.service
      - file: /etc/cacophony/3g-watchdog.yaml
      - watchdog-pkgs

/usr/local/bin/3g-watchdog:
  file.managed:
    - source: salt://pi/3g-watchdog/3g-watchdog
    - mode: 755

/etc/cacophony/3g-watchdog.yaml:
  file.managed:
    - source: salt://pi/3g-watchdog/3g-watchdog.yaml.jinja
    - template: jinja
    - mode: 644

/etc/systemd/system/3g-watchdog.service:
  file.managed:
    - source: salt://pi/3g-watchdog/3g-watchdog.service

########################################################
# Remove watchdog daemon where it had been installed
########################################################
watchdog:
  pkg.purged: []
  service.dead:
    - enable: False

/etc/watchdog.d:
  file.absent

/usr/bin/uhubctl:
  file.managed:
    - source: salt://pi/power-savings/uhubctl
    - mode: 755

/usr/bin/power-savings:
  file.managed:
    - source: salt://pi/power-savings/power-savings
    - mode: 755

power-savings-service-file:
  file.managed:
    - name: /etc/systemd/system/power-savings.service
    - source: salt://pi/power-savings/power-savings.service
    - mode: 644

power-savings-daemon-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
      - power-savings-service-file

power-savings-service:
  service.enabled:
    - name: power-savings
    - watch:
      - power-savings-daemon-reload

/etc/systemd/system/basic.target.wants/hdmi-off.service:
   file.absent

/etc/systemd/system/hdmi-off.service:
   file.absent

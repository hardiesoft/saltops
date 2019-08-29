/boot/config.txt:
   file.managed:
     - source: salt://pi/config.txt.jinja
     - template: jinja

/etc/modules:
   file.managed:
     - source: salt://pi/modules

/etc/rsyslog.conf:
   file.managed:
     - source: salt://pi/rsyslog.conf

/etc/logrotate.d/rsyslog:
  file.managed:
    - source: salt://pi/rsyslog

/boot/cmdline.txt:
   file.replace:
      - pattern: "^(.(?!.*spidev.bufsiz).*)"
      - repl: "\\1 spidev.bufsiz=65536"

/etc/cacophony:
   file.directory

hdmi-off-service-file:
   file.managed:
     - name: /etc/systemd/system/hdmi-off.service
     - source: salt://pi/hdmi-off.service
     - mode: 644

hdmi-off-daemon-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
       - hdmi-off-service-file

hdmi-off-service:
  service.enabled:
    - name: hdmi-off
    - watch:
      - hdmi-off-daemon-reload

i2c-tools:
  pkg.installed: []

{% if not salt["grains.get"]("cacophony:hw:rev") %}
default-hw-rev:
  grains.present:
    - name: cacophony:hw:rev
    - value: 2
{% endif %}

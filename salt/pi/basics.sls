/boot/config.txt:
   file.managed:
     - source: salt://pi/config.txt

/etc/modules:
   file.managed:
     - source: salt://pi/modules

/etc/rsyslog.conf:
   file.managed:
     - source: salt://pi/rsyslog.conf

# Start fake-hwclock after /dev is loaded
start_fake_hwclock_after_sysinit:
  file.line:
    - name: /lib/systemd/system/fake-hwclock.service
    - mode: ensure
    - after: "DefaultDependencies=.+"
    - content: "After=sysinit.target"

# Start fake-hwclock before general startup
start_fake_hwclock_before_basic:
  file.replace:
    - name: /lib/systemd/system/fake-hwclock.service
    - pattern: "^Before=.+"
    - repl: "Before=basic.target"

dont_start_fake_hwclock_if_rtc_exists:
  file.line:
    - name: /lib/systemd/system/fake-hwclock.service
    - mode: ensure
    - after: "Conflicts=.+"
    - content: "ConditionPathExists=!/dev/rtc0"

rtc-service-file:
  file.managed:
    - name: /etc/systemd/system/rtc.service
    - source: salt://pi/rtc/rtc.service

/usr/bin/load-rtc:
   file.managed:
     - mode: 755
     - source: salt://pi/rtc/load-rtc

rtc-daemon-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
       - rtc-service-file

rtc-service:
  service.dead:
    - name: rtc
    - enable: True
    - watch:
      - rtc-daemon-reload

/etc/cron.daily/update-rtc:
  file.managed:
    - mode: 755
    - source: salt://pi/rtc/update-rtc

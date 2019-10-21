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


rtc-utils-pkg:
  cacophony.pkg_installed_from_github:
    - name: rtc-utils
    - version: "1.0.0"

# This has been replaced by /etc/cron.daily/sync-rtc which is
# installed by the rtc-utils package
/etc/cron.daily/update-rtc:
  file.absent: []

# Manage fake-hwclock service file.
/lib/systemd/system/fake-hwclock.service:
  file.managed:
    - source: salt://pi/rtc/fake-hwclock.service
    - mode: 644

rtc-utils-pkg:
  cacophony.pkg_installed_from_github:
    - name: rtc-utils
    - version: "1.3.0"

# This has been replaced by /etc/cron.daily/sync-rtc which is
# installed by the rtc-utils package
/etc/cron.daily/update-rtc:
  file.absent: []

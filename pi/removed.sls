########################################################
# Purge old cacophony stuff.
########################################################

thermal-recorder-service:
  service.dead:
    - name: thermal-recorder

thermal-recorder:
  pkg.purged

managementd-service:
  service.dead:
    - name: managementd

management-interface:
  pkg.purged

audiobait-service:
  service.dead:
    - name: audiobait

audiobait:
  pkg.purged

########################################################
# Random really old stuff to remove
########################################################

/usr/local/bin/change-identity:
   file.absent

/opt/cacophony/thermal-recorder:
  file.absent: []

/opt/cacophony/thermal-uploader:
  file.absent: []

# This has been replaced by /etc/cron.daily/sync-rtc which is
# installed by the rtc-utils package
/etc/cron.daily/update-rtc:
  file.absent: []


########################################################
# Ensure that old 3g-watchdog bits are removed
########################################################
3g-watchdog:
  service.dead:
    - enable: False

/usr/local/bin/3g-watchdog:
  file.absent

/etc/cacophony/3g-watchdog.yaml:
  file.absent

/etc/systemd/system/3g-watchdog.service:
  file.absent


/etc/systemd/system/multi-user.target.wants/cacophonator-management.service:
   file.absent
# Use ALSA directly instead of pulseaudio. Unattended usage of pulseaudio is
# too fragile.
pulseaudio:
  pkg.purged

pulseaudio-utils:
  pkg.purged

# Ensure bluetooth stuff is gone
bluez:
  pkg.purged

bluez-firmware:
  pkg.purged

pi-bluetooth:
  pkg.purged

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

# Ensure that Dataplicity is uninstalled
supervisor:
  pkg.purged

supervisord:
  process.absent

dataplicity:
  process.absent

/opt/dataplicity:
  file.absent

/etc/supervisor:
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

########################################################
#  Archive old config files
########################################################

/etc/cacophony/archive:
  file.directory

/etc/cacophony/archive/attiny.yaml:
    file.rename:
      - source: /etc/cacophony/attiny.yaml

/etc/cacophony/archive/modemd.yaml:
    file.rename:
      - source: /etc/cacophony/modemd.yaml

/etc/cacophony/archive/leptond.yaml:
    file.rename:
      - source: /etc/leptond.yaml

/etc/cacophony/archive/thermal-recorder.yaml:
    file.rename:
      - source: /etc/thermal-recorder.yaml

/etc/cacophony/archive/location.yaml:
    file.rename:
      - source: /etc/cacophony/location.yaml

/etc/cacophony/archive/device.yaml:
    file.rename:
      - source: /etc/cacophony/device.yaml

/etc/cacophony/archive/device-priv.yaml:
    file.rename:
      - source: /etc/cacophony/device-priv.yaml

/etc/cacophony/archive/managementd.yaml:
    file.rename:
      - source: /etc/cacophony/managementd.yaml

/etc/cacophony/archive/audiobait.yaml:
    file.rename:
      - source: /etc/audiobait.yaml

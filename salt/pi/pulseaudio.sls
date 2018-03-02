pulseaudio:
  pkg.installed

pulseaudio-utils:
  pkg.installed

/etc/pulse/default.pa:
  file.append:
    - require:
        - pulseaudio
    - text:
        - "# Use an externally connected audio interface as the default"
        - "load-module module-switch-on-connect"

# Ensure bluetooth stuff is gone
bluez:
  pkg.purged

bluez-firmware:
  pkg.purged

pi-bluetooth:
  pkg.purged


# Base alsa utilities (e.g. amixer)
alsa-utils:
  pkg.installed

# Ensure that the USB audio device gets allocated as card 1
/etc/modprobe.d/alsa-base.conf:
  file.managed:
    - contents:
      - options snd-usb-audio index=1

# sox has the "play" tool for playing audio files
sox:
  pkg.installed

libsox-fmt-mp3:
  pkg.installed

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


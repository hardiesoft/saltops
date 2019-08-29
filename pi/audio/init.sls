# Base alsa utilities (e.g. amixer)
alsa-utils:
  pkg.installed

# Ensure that the USB audio device gets allocated as card 1
/etc/modprobe.d/alsa-base.conf:
  file.managed:
    - contents:
      - options snd-usb-audio index=1

# Configuration for onboard sound
/etc/asound.conf:
   file.managed:
     - source: salt://pi/audio/asound.conf

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

# Ensure audio hardware is correctly setup
audio-hardware:
  cacophony.init_alsa


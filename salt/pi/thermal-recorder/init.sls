thermal-recorder-pkg:
  cacophony.pkg_installed_from_github:
    - name: thermal-recorder
    {% if salt['grains.get']('cacophony:recorder-beta') %}
    - version: "1.12"
    {% else %}
    - version: "1.10"
    {% endif %}

# Install support for exFAT & NTFS filesystems (for USB drives)
extra-filesystems:
  pkg.installed:
    - pkgs:
      - exfat-fuse
      - exfat-utils
      - ntfs-3g

# Mount point for USB drives to write CPTV files to
cp-volume-mount:
  file.append:
    - name: "/etc/fstab"
    - text:
      - "LABEL=cp /media/cp auto auto,nofail,noexec,nodev,noatime,nodiratime 0 2"

/etc/thermal-recorder.yaml:
  file.managed:
    {% if salt['grains.get']('cacophony:recorder-beta') %}
    - source: salt://pi/thermal-recorder/thermal-recorder-1.11.yaml.jinja
    {% else %}
    - source: salt://pi/thermal-recorder/thermal-recorder.yaml.jinja
    {% endif %}
    - template: jinja

/etc/leptond.yaml:
  file.managed:
    - source: salt://pi/thermal-recorder/leptond.yaml.jinja
    - template: jinja

thermal-recorder-service:
  service.running:
    - name: thermal-recorder
    - enable: True
    - watch:
      - thermal-recorder-pkg
      - /etc/thermal-recorder.yaml

leptond-service:
  service.running:
    - name: leptond
    - enable: True
    - watch:
      - thermal-recorder-pkg
      - /etc/leptond.yaml


set-thermal-recorder-output:
  service.enabled: []

# Remove files from old thermal-recorder versions
/opt/cacophony/thermal-recorder:
  file.absent: []

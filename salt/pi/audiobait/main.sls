{% set version = "0.5" %}

/var/lib/audiobait:
  file.directory

audiobait_installed:
  pkg.installed:
    - sources:
      - audiobait: https://github.com/TheCacophonyProject/audiobait/releases/download/v{{ version }}/audiobait_{{ version }}_arm.deb

audiobait-daemon-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
       - audiobait_installed

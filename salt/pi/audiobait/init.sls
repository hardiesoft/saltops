audiobait-pkg:
  cacophony.pkg_installed_from_github:
    - name: audiobait
    - version: "1.0"

/etc/audiobait.yaml:
  file.managed:
    - source: salt://pi/audiobait/audiobait.yaml

/var/lib/audiobait:
  file.directory

audiobait-service:
  service.running:
    - name: audiobait
    - enable: True
    - watch:
      - audiobait-pkg
      - /etc/audiobait.yaml

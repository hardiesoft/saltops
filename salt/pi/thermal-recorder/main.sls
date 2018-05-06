thermal-recorder-pkg:
  cacophony.pkg_installed_from_github:
    - name: thermal-recorder
    - version: 1.4

/etc/thermal-recorder.yaml:
  file.managed:
    - source: salt://pi/thermal-recorder/thermal-recorder.yaml.jinja
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

# Remove files from old thermal-recorder versions
/opt/cacophony/thermal-recorder:
  file.absent: []

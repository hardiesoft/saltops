/etc/thermal-recorder.yaml:
  file.managed:
    - source: salt://thermal-recorder.yaml.jinja
    - template: jinja

thermal-recorder:
  service.running:
    - enable: True
    - watch:
      - file: /etc/thermal-recorder.yaml 

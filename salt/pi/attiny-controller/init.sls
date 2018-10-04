attiny-controller-pkg:
  cacophony.pkg_installed_from_github:
    - name: attiny-controller
    - version: "2.0"

attiny-controller-service:
  service.running:
    - name: attiny-controller
    - enable: True
    - watch:
      - /etc/cacophony/attiny.yaml
      - attiny-controller-pkg

/etc/cacophony/attiny.yaml:
  file.managed:
    - source: salt://pi/attiny-controller/attiny.yaml.jinja
    - template: jinja

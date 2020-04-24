device-register-pkg:
  fever.pkg_installed_from_github:
    - name: device-register
    - version: "1.2.0"
    - cacophony_project: True

device-register-service:
  service.enabled:
    - name: device-register
    - onchanges:
      - device-register-pkg

device-register-override:
  file.managed:
    - name: /etc/systemd/system/device-register.service.d/override.conf
    - makedirs: True
    - source: salt://pi/device-register/override.conf
    - mode: 644

device-register-daemon-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
      - device-register-override

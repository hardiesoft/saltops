device-register-pkg:
  cacophony.pkg_installed_from_github:
    - name: device-register
    - version: "0.2"

device-register-service:
  service.enabled:
    - name: device-register
    - enable: True
    - watch:
      - device-register-pkg

device-register-pkg:
  cacophony.pkg_installed_from_github:
    - name: device-register
    - version: "0.3"

device-register-service:
  service.enabled:
    - name: device-register
    - watch:
      - device-register-pkg

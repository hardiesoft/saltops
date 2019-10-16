cacophony-config-pkg:
  cacophony.pkg_installed_from_github:
    - name: go-config
    - version: "1.0.4"
    - pkg_name: cacophony-config

cacophony-config-import-service:
  service.enabled:
    - name: cacophony-config-import
    - onchanges:
      - cacophony-config-pkg

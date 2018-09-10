management-interface-pkg:
  cacophony.pkg_installed_from_github:
    - name: management-interface
    - version: "0.1"

management-interface-service:
  service.running:
    - name: cacophonator-management
    - enable: True
    - watch:
      - management-interface-pkg

management-interface-pkg:
  cacophony.pkg_installed_from_github:
    - name: management-interface
    - version: "0.10"

management-interface-service:
  service.running:
    - name: cacophonator-management
    - enable: True
    - watch:
      - management-interface-pkg

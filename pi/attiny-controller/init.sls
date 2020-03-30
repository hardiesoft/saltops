attiny-controller-pkg:
  fever.pkg_installed_from_github:
    - name: attiny-controller
    - version: "3.3.0"
    - cacophony_project: True

attiny-controller-service:
  service.running:
    - name: attiny-controller
    - enable: True
    - watch:
      - attiny-controller-pkg

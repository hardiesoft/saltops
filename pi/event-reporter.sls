event-reporter-pkg:
  fever.pkg_installed_from_github:
    - name: event-reporter
    - version: "3.1.0"
    - cacophony_project: True

event-reporter-service:
  service.running:
    - name: event-reporter
    - enable: True
    - watch:
      - event-reporter-pkg

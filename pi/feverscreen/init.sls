feverscreen-pkg:
  fever.pkg_installed_from_github:
    - name: feverscreen
    - version: "0.5.3"

feverscreen-service:
  service.running:
    - name: feverscreen
    - enable: True
    - watch:
      - feverscreen-pkg

leptond-service:
  service.running:
    - name: leptond
    - enable: True
    - watch:
      - feverscreen-pkg

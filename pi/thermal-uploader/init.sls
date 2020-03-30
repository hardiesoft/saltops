thermal-uploader-pkg:
  fever.pkg_installed_from_github:
    - name: thermal-uploader
    - version: "2.2.0"
    - cacophony_project: True

thermal-uploader-service:
  service.running:
    - name: thermal-uploader
    - enable: True
    - watch:
      - thermal-uploader-pkg


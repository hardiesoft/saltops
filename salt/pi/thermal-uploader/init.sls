thermal-uploader-pkg:
  cacophony.pkg_installed_from_github:
    - name: thermal-uploader
    {% if salt['grains.get']('cacophony:recorder-beta') %}
    - version: "1.6"
    {% else %}
    - version: "1.5"
    {% endif %}

thermal-uploader-service:
  service.running:
    - name: thermal-uploader
    - enable: True
    - watch:
      - thermal-uploader-pkg

# Remove files from old thermal-uploader versions
/opt/cacophony/thermal-uploader:
  file.absent: []

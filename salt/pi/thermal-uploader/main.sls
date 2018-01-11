{% set version = "1.2" %}
{% set bin = "/usr/local/bin/thermal-uploader" %}
{% set download_base_url = "https://github.com/TheCacophonyProject/thermal-uploader/releases/download" %}
{% set extract_base_dir = "/opt/cacophony/thermal-uploader" %}

check-uploader-version:
  cmd.run:
    - name: test "`{{ bin }} --version`" = '{{ version }}' || echo 'changed=true'
    - stateful: True

# Download & extract the required uploader release if check-uploader-version
# reports that the installed uploader isn't the correct version.
extract-uploader:
  archive.extracted:
    - onchanges:
      - check-uploader-version
    - name: {{ extract_base_dir }}/{{ version }}
    - source: {{ download_base_url }}/v{{ version }}/thermal-uploader_{{ version }}.tar.gz
    - source_hash: {{ download_base_url }}/v{{ version }}/thermal-uploader_{{ version }}_checksums.txt
    - enforce_toplevel: False

# Ensure there's a symlink in /usr/local/bin to the uploader binary
uploader-symlink:
  file.symlink:
    - requires: 
      - extract-uploader
    - name: {{ bin }}
    - target: {{ extract_base_dir }}/{{ version }}/thermal-uploader
    - force: True

# TODO: install the systemd service file from the release

# Ensure the uploader service is running. The service gets restarted if the
# symlink or configuration changes.
thermal-uploader-service:
  service.running:
    - name: thermal-uploader
    - enable: True
    - watch:
      - uploader-symlink

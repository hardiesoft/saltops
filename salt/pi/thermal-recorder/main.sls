{% set version = "1.2" %}
{% set bin = "/usr/local/bin/thermal-recorder" %}
{% set download_base_url = "https://github.com/TheCacophonyProject/thermal-recorder/releases/download" %}
{% set extract_base_dir = "/opt/cacophony/thermal-recorder" %}

check-recorder-version:
  cmd.run:
    - name: test "`{{ bin }} --version`" = '{{ version }}' || echo 'changed=true'
    - stateful: True

# Download & extract the required recorder release if check-recorder-version
# reports that the installed recorder isn't the correct version.
extract-recorder:
  archive.extracted:
    - onchanges:
      - check-recorder-version
    - name: {{ extract_base_dir }}/{{ version }}
    - source: {{ download_base_url }}/v{{ version }}/thermal-recorder_{{ version }}.tar.gz
    - source_hash: {{ download_base_url }}/v{{ version }}/thermal-recorder_{{ version }}_checksums.txt
    - enforce_toplevel: False

# Ensure there's a symlink in /usr/local/bin to the recorder binary
recorder-symlink:
  file.symlink:
    - requires: 
      - extract-recorder
    - name: {{ bin }}
    - target: {{ extract_base_dir }}/{{ version }}/thermal-recorder
    - force: True

# Ensure the templated recoder configuration is up to date.
/etc/thermal-recorder.yaml:
  file.managed:
    - source: salt://pi/thermal-recorder/thermal-recorder.yaml.jinja
    - template: jinja

# TODO: install the server file from the release

# Ensure the recorder service is running. The service gets restarted if the
# symlink or configuration changes.
thermal-recorder-service:
  service.running:
    - name: thermal-recorder
    - enable: True
    - watch:
      - /etc/thermal-recorder.yaml 
      - recorder-symlink

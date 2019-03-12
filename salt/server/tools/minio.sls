{% from "server/tools/map.jinja" import minio with context %}

/usr/local/bin/minio:
  file.managed:
    - source: https://dl.minio.io/server/minio/release/linux-amd64/archive/minio.{{ minio.version }}
    - source_hash: https://dl.minio.io/server/minio/release/linux-amd64/archive/minio.{{ minio.version }}.sha256sum
    - user: root
    - group: root
    - mode: 755

/etc/systemd/system/minio.service:
  file.managed:
    - source: salt://server/tools/minio.service
    - user: root
    - group: root
    - mode: 755

/etc/default/minio:
  file.managed:
    - source: salt://server/tools/minio.config
    - user: root
    - group: root
    - mode: 644
    - replace: False

minio:
  service.running:
    - enable: True

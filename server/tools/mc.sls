{% from "server/tools/map.jinja" import mc with context %}

/usr/local/bin/mc:
  file.managed:
    - source: https://dl.minio.io/client/mc/release/linux-amd64/archive/mc.{{ mc.version }}
    - source_hash: https://dl.minio.io/client/mc/release/linux-amd64/archive/mc.{{ mc.version }}.sha256sum
    - user: root
    - group: root
    - mode: 755

{% from "server/influxdb/map.jinja" import influxdb with context %}

influxdb_pkg:
  pkg.installed:
    - sources:
      - influxdb: https://dl.influxdata.com/influxdb/releases/influxdb_{{ influxdb.version }}_amd64.deb

influxdb-daemon-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
       - influxdb_pkg

influxdb-service:
  service.running:
    - name: influxdb
    - enable: True
    - watch:
      - influxdb-daemon-reload

python-influxdb:
  pkg.installed

sleep 10:
  cmd.run

influx-db-test:
  influxdb_database.present:
    - name: server_metrics
    - require:
      - cmd: sleep 10
      - pkg: python-influxdb


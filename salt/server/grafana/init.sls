{% from "server/grafana/map.jinja" import grafana with context %}

grafana_pkg:
  pkg.installed:
    - sources:
      - grafana: https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_{{ grafana.version }}_amd64.deb

/etc/grafana/grafana.ini:
  file.managed:
    - source: salt://server/grafana/grafana.ini

grafana-daemon-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
       - grafana_pkg

grafana-service:
  service.running:
    - name: grafana-server
    - enable: True
    - watch:
      - /etc/grafana/grafana.ini
      - grafana-daemon-reload

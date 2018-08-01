/etc/ssh/sshd_config:
  file.managed:
    - source: salt://server/sshd/sshd_config

sshd-service:
  service.running:
    - name: sshd
    - enable: True
    - watch:
      - /etc/ssh/sshd_config

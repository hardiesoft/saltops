/etc/salt/pki/minion/minion_master.pub:
  file.managed:
    - source: salt://salt-migration/master.pub
    - mode: 644

/etc/salt/minion.d/ports.conf:
  file.managed:
    - source: salt://salt-migration/ports.conf
    - mode: 644

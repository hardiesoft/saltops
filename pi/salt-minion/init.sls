salt_pkgrepo:
  pkgrepo.managed:
    - humanname: SaltStack
    - name: deb http://repo.saltstack.com/apt/debian/9/armhf/2018.3 stretch main
    - file: /etc/apt/sources.list.d/saltstack.list
    - clean_file: True
    - refresh: False

# If this changes we need to manually restart the salt minion afterwards
/etc/salt/minion:
  file.managed:
    - source: salt://pi/salt-minion/minion

/etc/systemd/system/salt-minion.service.d/override.conf:
   file.managed:
     - makedirs: True
     - source: salt://pi/salt-minion/override.conf

/usr/local/bin/check-salt-keys:
  file.managed:
    - source: salt://pi/salt-minion/check-salt-keys
    - mode: 755

/etc/cron.hourly/check-salt-keys:
  file.managed:
    - source: salt://pi/salt-minion/check-salt-keys.cron
    - mode: 755
